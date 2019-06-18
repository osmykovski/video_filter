import unittest
import random
import os

from PIL import Image
import urllib.request
import matplotlib.pyplot as plt
import numpy as np

from myhdl import Simulation, StopSimulation, Signal, delay, concat, \
                  intbv, negedge, posedge, now, Cosimulation, always, \
                  always_comb, modbv

cmd = 'vsim -c -quiet -pli myhdl_vpi.dll -do cosim.do filter_test'

def UUT(clk, reset,
        s_axis_video_tdata, s_axis_video_tvalid, s_axis_video_tready,
        s_axis_video_tuser, s_axis_video_tlast,
        m_axis_video_tdata, m_axis_video_tvalid, m_axis_video_tready,
        m_axis_video_tuser, m_axis_video_tlast, tp):
    os.system('vlog -quiet ../stream_video_filter.v \
        +define+FILTER_DIM=%d \
        +define+COE_WIDTH=%d \
        +define+COE_FILE_NAME=%s \
        +define+MAX_IMG_RES=%d \
        +define+NORM_FACTOR=%d' % (
        tp['filter_dim'],
        tp['coe_width'],
        tp['coe_file'],
        tp['max_img_res'],
        tp['norm_factor'])
    )
    os.system('vlog -quiet filter_test.v \
        +define+FILTER_DIM=%d \
        +define+COE_WIDTH=%d \
        +define+COE_FILE_NAME=%s \
        +define+MAX_IMG_RES=%d \
        +define+NORM_FACTOR=%d' % (
        tp['filter_dim'],
        tp['coe_width'],
        tp['coe_file'],
        tp['max_img_res'],
        tp['norm_factor'])
    )
    
    return Cosimulation(cmd, **locals())

ref_uri = (
    "https://upload.wikimedia.org/" \
    "wikipedia/commons/5/50/" \
    "Vd-Orig.png"
)


def get_img(imlink, filename):
    urllib.request.urlretrieve(imlink, filename)
    img_file = Image.open(filename).convert('RGB')
    img = np.array(img_file)
    return img

def plot_images(orig, img_out, img_ref):
    plt.subplot(131)
    plt.imshow(orig)

    plt.subplot(132)
    plt.imshow(img_out)

    plt.subplot(133)
    plt.imshow(img_ref)

    plt.show()

def calc_diff(ref_image, ref_out_image, out_image):
    out_image = np.array(out_image).reshape(np.shape(ref_image))
    image_diff = np.absolute(ref_out_image - out_image)
    return image_diff


class TestStreamVideoFilter(unittest.TestCase):

    def is_similar(self, ref_out_image, out_image, image_diff):
        max_diff = np.argmax(any(image_diff.flatten()))
        # within rounding error
        if max_diff > 1:
            plot_images(ref_out_image, out_image, image_diff)
        self.assertFalse(max_diff > 1)

    def is_identical(self, ref_out_image, out_image, image_diff):
        if image_diff.any():
            plot_images(ref_out_image, out_image, image_diff)
        self.assertFalse(image_diff.any())
    
    def clock_gen(self, clock):
        while 1:
            yield delay(10)
            clock.next = not clock

    def reset_gen(self, reset):
        reset.next = 0
        yield delay(50)
        reset.next = 1
    
    def rx_frame(self, m_tdata, m_tvalid, m_tready, m_tuser, clock, reset,
            count_tuser, out_im):
        
        @always(clock.posedge)
        def CountTU():
            if not reset:
                count_tuser.next = 0
            elif m_tvalid and m_tready and m_tuser:
                count_tuser.next += 1
        
        @always(clock.posedge)
        def GetFrame():
            m_tready.next = random.getrandbits(1)
            if m_tvalid and m_tready:
                if (count_tuser == 1 and not m_tuser) or \
                        (count_tuser == 0 and m_tuser):
                    out_im.append(int(m_tdata[24:16]))
                    out_im.append(int(m_tdata[16:8]))
                    out_im.append(int(m_tdata[8:0]))
        
        @always(clock.posedge)
        def SimTermination():
            if count_tuser == 2:
                raise StopSimulation
        
        return CountTU, GetFrame, SimTermination
    
    def tx_frame(self, s_tdata, s_tvalid, s_tready, s_tuser, s_tlast,
            clock, reset, ref_im, count_line, count_col):

        @always_comb
        def SetTxData():
            if reset:
                # start of frame
                s_tuser.next = (count_line == 0 and count_col == 0)
                
                # end of line
                s_tlast.next = (count_col == count_col.max-1)
                
                # update data
                sub_0 = int(ref_im[count_line][count_col][0])
                sub_1 = int(ref_im[count_line][count_col][1])
                sub_2 = int(ref_im[count_line][count_col][2])
                
                s_tdata.next = concat(
                    intbv(sub_0, 0, 256),
                    intbv(sub_1, 0, 256),
                    intbv(sub_2, 0, 256))
        
        @always(clock.posedge)
        def TxDataCount():
            if reset:
                s_tvalid.next = random.getrandbits(1)
                if (s_tvalid and s_tready):
                    count_col.next += 1
                    if count_col == count_col.max-1:
                        count_line.next += 1
        
        return SetTxData, TxDataCount
    
    def simulate(self, testparams, ref_image, out_image):
        # init one bit signals
        s_tvalid, s_tready, s_tuser, s_tlast, \
        m_tvalid, m_tready, m_tuser, m_tlast, \
        clk, reset = [Signal(intbv(0)) for i in range(10)]
        
        # init data signals
        s_tdata, m_tdata = [
            Signal(intbv(0, min=0, max=2**24)) for i in range(2)]
        
        # auxiliary signals
        count_line = Signal(modbv(0, min=0, max=ref_image.shape[0]))
        count_col = Signal(modbv(0, min=0, max=ref_image.shape[1]))
        count_tuser = Signal(modbv(0, min=0, max=3))
        
        UUT_inst = UUT(clk, reset, s_tdata, s_tvalid, s_tready, s_tuser,
            s_tlast, m_tdata, m_tvalid, m_tready, m_tuser, m_tlast, testparams)
        
        CLK_inst = self.clock_gen(clk)
        RST_inst = self.reset_gen(reset)
        TX_inst = self.tx_frame(s_tdata, s_tvalid, s_tready, s_tuser, s_tlast,
            clk, reset, ref_image, count_line, count_col)
        RX_inst = self.rx_frame(m_tdata, m_tvalid, m_tready, m_tuser,
            clk, reset, count_tuser, out_image)
        
        sim = Simulation(
            UUT_inst,
            CLK_inst,
            RST_inst,
            TX_inst,
            RX_inst
        )
        sim.run()
    
    def tearDown(self):
        os.system('del transcript')
        os.system('del *.png')
        os.system('RMDIR work /S /Q')
        os.system('RMDIR __pycache__ /S /Q')
    
    def test_Identity(self):
        
        testparams = {
            'filter_dim': 5,
            'coe_width': 16,
            'coe_file': 'IDENTITY_COEF',
            'max_img_res': 110,
            'norm_factor': 2**16}
        
        # get input image
        ref_image = get_img(ref_uri, 'img_in.png')
        
        out_image = []
        
        # start simulation to get output image
        self.simulate(testparams, ref_image, out_image)
        
        # calculate diffrence
        image_diff = calc_diff(ref_image, ref_image, out_image)
        
        # show results
        self.is_identical(ref_image, out_image, image_diff)
    
    def test_EdgeDetect1(self):
    
        out_ref_url = (
            "https://upload.wikimedia.org/" \
            "wikipedia/commons/8/8d/" \
            "Vd-Edge1.png"
        )
        
        testparams = {
            'filter_dim': 3,
            'coe_width': 8,
            'coe_file': 'EDETECT1_COEF',
            'max_img_res': 110,
            'norm_factor': (2**16)
        }
        
        # get input image
        ref_image = get_img(ref_uri, 'img_in.png')
        # get refrence output image
        ref_out_image = get_img(out_ref_url, 'ref.png')
        
        out_image = []
        
        # start simulation to get output image
        self.simulate(testparams, ref_image, out_image)
        
        # calculate diffrence
        image_diff = calc_diff(ref_image, ref_out_image, out_image)
        
        # show results
        self.is_identical(ref_out_image, out_image, image_diff)
    
    def test_EdgeDetect2(self):
    
        out_ref_url = (
            "https://upload.wikimedia.org/" \
            "wikipedia/commons/8/83/" \
            "Vd-Edge2.png"
        )
        
        testparams = {
            'filter_dim': 3,
            'coe_width': 8,
            'coe_file': 'EDETECT2_COEF',
            'max_img_res': 110,
            'norm_factor': (2**16)
        }
        
        # get input image
        ref_image = get_img(ref_uri, 'img_in.png')
        # get refrence output image
        ref_out_image = get_img(out_ref_url, 'ref.png')
        
        out_image = []
        
        # start simulation to get output image
        self.simulate(testparams, ref_image, out_image)
        
        # calculate diffrence
        image_diff = calc_diff(ref_image, ref_out_image, out_image)
        
        # show results
        self.is_identical(ref_out_image, out_image, image_diff)
    
    def test_EdgeDetect3(self):
    
        out_ref_url = (
            "https://upload.wikimedia.org/" \
            "wikipedia/commons/6/6d/" \
            "Vd-Edge3.png"
        )
        
        testparams = {
            'filter_dim': 3,
            'coe_width': 8,
            'coe_file': 'EDETECT3_COEF',
            'max_img_res': 110,
            'norm_factor': (2**16)
        }
        
        # get input image
        ref_image = get_img(ref_uri, 'img_in.png')
        # get refrence output image
        ref_out_image = get_img(out_ref_url, 'ref.png')
        
        out_image = []
        
        # start simulation to get output image
        self.simulate(testparams, ref_image, out_image)
        
        # calculate diffrence
        image_diff = calc_diff(ref_image, ref_out_image, out_image)
        
        # show results
        self.is_identical(ref_out_image, out_image, image_diff)
    
    def test_Sharpen(self):
    
        out_ref_url = (
            "https://upload.wikimedia.org/" \
            "wikipedia/commons/4/4e/" \
            "Vd-Sharp.png"
        )
        
        testparams = {
            'filter_dim': 3,
            'coe_width': 8,
            'coe_file': 'SHARPEN_COEF',
            'max_img_res': 110,
            'norm_factor': (2**16)
        }
        
        # get input image
        ref_image = get_img(ref_uri, 'img_in.png')
        # get refrence output image
        ref_out_image = get_img(out_ref_url, 'ref.png')
        
        out_image = []
        
        # start simulation to get output image
        self.simulate(testparams, ref_image, out_image)
        
        # calculate diffrence
        image_diff = calc_diff(ref_image, ref_out_image, out_image)
        
        # show results
        self.is_identical(ref_out_image, out_image, image_diff)
        
    def test_BoxBlur(self):
    
        out_ref_url = (
            "https://upload.wikimedia.org/" \
            "wikipedia/commons/0/04/" \
            "Vd-Blur2.png"
        )
        
        testparams = {
            'filter_dim': 3,
            'coe_width': 8,
            'coe_file': 'BOX_BLUR_COEF',
            'max_img_res': 110,
            'norm_factor': 7282
        }
        
        # get input image
        ref_image = get_img(ref_uri, 'img_in.png')
        # get refrence output image
        ref_out_image = get_img(out_ref_url, 'ref.png')
        
        out_image = []
        
        # start simulation to get output image
        self.simulate(testparams, ref_image, out_image)
        
        # calculate diffrence
        image_diff = calc_diff(ref_image, ref_out_image, out_image)
        
        # show results
        self.is_similar(ref_out_image, out_image, image_diff)
    
    def test_GaussianBlur(self):
    
        out_ref_url = (
            "https://upload.wikimedia.org/" \
            "wikipedia/commons/2/28/" \
            "Vd-Blur1.png"
        )
        
        testparams = {
            'filter_dim': 3,
            'coe_width': 8,
            'coe_file': 'GAUSSIAN_BLUR_COEF',
            'max_img_res': 110,
            'norm_factor': 4096
        }
        
        # get input image
        ref_image = get_img(ref_uri, 'img_in.png')
        # get refrence output image
        ref_out_image = get_img(out_ref_url, 'ref.png')
        
        out_image = []
        
        # start simulation to get output image
        self.simulate(testparams, ref_image, out_image)
        
        # calculate diffrence
        image_diff = calc_diff(ref_image, ref_out_image, out_image)
        
        # show results
        self.is_similar(ref_out_image, out_image, image_diff)
    
    def test_GaussianBlur5x5(self):
    
        out_ref_url = (
            "https://upload.wikimedia.org/" \
            "wikipedia/commons/0/04/" \
            "Vd-Blur_Gaussian_5x5.png"
        )
        
        testparams = {
            'filter_dim': 5,
            'coe_width': 8,
            'coe_file': 'GAUSSIAN_BLUR_5_5_COEF',
            'max_img_res': 110,
            'norm_factor': 256
        }
        
        # get input image
        ref_image = get_img(ref_uri, 'img_in.png')
        # get refrence output image
        ref_out_image = get_img(out_ref_url, 'ref.png')
        
        out_image = []
        
        # start simulation to get output image
        self.simulate(testparams, ref_image, out_image)
        
        # calculate diffrence
        image_diff = calc_diff(ref_image, ref_out_image, out_image)
        
        # show results
        self.is_similar(ref_out_image, out_image, image_diff)
    
    def test_UnsharpMasking(self):
    
        out_ref_url = (
            "https://upload.wikimedia.org/" \
            "wikipedia/commons/e/ef/" \
            "Vd-Unsharp_5x5.png"
        )
        
        testparams = {
            'filter_dim': 5,
            'coe_width': 16,
            'coe_file': 'UNSHARP_MASKING_COEF',
            'max_img_res': 110,
            'norm_factor': -256
        }
        
        # get input image
        ref_image = get_img(ref_uri, 'img_in.png')
        # get refrence output image
        ref_out_image = get_img(out_ref_url, 'ref.png')
        
        out_image = []
        
        # start simulation to get output image
        self.simulate(testparams, ref_image, out_image)
        
        # calculate diffrence
        image_diff = calc_diff(ref_image, ref_out_image, out_image)
        
        # show results
        self.is_similar(ref_out_image, out_image, image_diff)
        
        
if __name__ == '__main__':
    unittest.main()
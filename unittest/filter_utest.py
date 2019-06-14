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

# tests:
#     Identity
#     Edge detection var. 0
#     Edge detection var. 1
#     Edge detection var. 2
#     Sharpen
#     Box blur
#     Gaussian blur 3x3
#     Gaussian blur 5x5
#     Unsharp masking

cmd = 'vsim -c -quiet -pli myhdl_vpi.dll -do cosim.do filter_test'

def UUT(clk, reset,
        s_axis_video_tdata, s_axis_video_tvalid, s_axis_video_tready,
        s_axis_video_tuser, s_axis_video_tlast,
        m_axis_video_tdata, m_axis_video_tvalid, m_axis_video_tready,
        m_axis_video_tuser, m_axis_video_tlast, tp):
    os.system('clear_simulation.bat')
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

class TestStreamVideoFilter(unittest.TestCase):
    
    def ClockGen(self, clock):
        while 1:
            yield delay(10)
            clock.next = not clock

    def ResetGen(self, reset):
        reset.next = 0
        yield delay(20)
        reset.next = 1
    
    def RxFrame(self, m_tdata, m_tvalid, m_tready, m_tuser, clock, reset, 
            tuser_count, out_im):
        
        @always(clock.negedge)
        def CountTU():
            if not reset:
                tuser_count.next = 0
            elif m_tvalid and m_tready and m_tuser:
                tuser_count.next += 1
        
        @always(clock.posedge)
        def GetFrame():
            m_tready.next = random.getrandbits(1)
            if m_tvalid and m_tready:
                if tuser_count == 1:
                    out_im.append(int(m_tdata[24:16]))
                    out_im.append(int(m_tdata[16:8]))
                    out_im.append(int(m_tdata[8:0]))
        
        @always(clock.posedge)
        def SimTermination():
            if tuser_count == 2:
                raise StopSimulation
        
        return CountTU, GetFrame, SimTermination
    
    def TxFrame(self, s_tdata, s_tvalid, s_tready, s_tuser, s_tlast,
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
    
    def test_Identity(self):

        s_tvalid, s_tready, s_tuser, s_tlast, \
        m_tvalid, m_tready, m_tuser, m_tlast, \
        clk, reset = [Signal(intbv(0)) for i in range(10)]

        ref_image, out_image, image_diff = [[], [], []]

        s_tdata, m_tdata = [
            Signal(intbv(0, min=0, max=2**24)) for i in range(2)]
        
        testparams = {
            'filter_dim': 5,
            'coe_width': 16,
            'coe_file': 'IDENTITY_COEF',
            'max_img_res': 300,
            'norm_factor': 2**16}
            
        urllib.request.urlretrieve(
            "https://upload.wikimedia.org/wikipedia/commons/5/50/Vd-Orig.png",
            "identity.png")

        img_file = Image.open('identity.png').convert('RGB')
        ref_image = np.array(img_file)
        
        
        count_line = Signal(modbv(0, min=0, max=ref_image.shape[0]))
        count_col = Signal(modbv(0, min=0, max=ref_image.shape[1]))
        tuser_count = Signal(modbv(0, min=0, max=3))
        
        UUT_inst = UUT(clk, reset, s_tdata, s_tvalid, s_tready, s_tuser,
            s_tlast, m_tdata, m_tvalid, m_tready, m_tuser, m_tlast, testparams)
        CLK_inst = self.ClockGen(clk)
        TX_inst = self.TxFrame(s_tdata, s_tvalid, s_tready, s_tuser, s_tlast,
            clk, reset, ref_image, count_line, count_col)
        RST_inst = self.ResetGen(reset)
        RX_inst = self.RxFrame(m_tdata, m_tvalid, m_tready, m_tuser,
            clk, reset, tuser_count, out_image)
        
        sim = Simulation(
            UUT_inst,
            CLK_inst,
            RST_inst,
            TX_inst,
            RX_inst
        )
        sim.run()
        
        # calculate diffrence
        
        out_image = np.array(out_image).reshape(np.shape(ref_image))
        image_diff = np.absolute(ref_image - out_image)
        
        # show results
        
        plt.subplot(131)
        plt.imshow(ref_image)

        plt.subplot(132)
        plt.imshow(out_image)

        plt.subplot(133)
        plt.imshow(image_diff)

        plt.show()



if __name__ == '__main__':
    unittest.main()
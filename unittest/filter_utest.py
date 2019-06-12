import unittest
import random
import os

from PIL import Image
import urllib.request
import matplotlib.pyplot as plt
import numpy as np

from myhdl import Simulation, StopSimulation, Signal, delay, concat, \
                  intbv, negedge, posedge, now, Cosimulation

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
    
    def СlockGen(self, clock):
        while 1:
            yield delay(10)
            clock.next = not clock
    
    def ResetGen(self, reset):
        reset.next = 0
        yield delay(20)
        reset.next = 1
        
    def RunControl(self, m_tuser, clock):
        tuser_count = 0
        while 1:
            yield posedge(clock)
            if m_tuser:
                tuser_count += 1
                if tuser_count == 2:
                    raise StopSimulation
    
    def TxFrame(self, s_tdata, s_tvalid, s_tready, s_tuser, s_tlast,
                clock, ref_im):
        yield delay(30)
        count_line, count_col = [0, 0]
        while 1:
            yield posedge(clock)
            s_tvalid.next = random.getrandbits(1)
            s_tvalid.next = 1
            
            if (s_tvalid == 1 and s_tready == 1):
                # update data
                s_tdata.next = concat(
                    intbv(int(ref_im[count_line][count_col][0]), 0, 256),
                    intbv(int(ref_im[count_line][count_col][1]), 0, 256),
                    intbv(int(ref_im[count_line][count_col][2]), 0, 256))
            
                # start of frame
                s_tuser.next = (count_line == 0 and count_col == 0)
                
                # end of line
                s_tlast.next = (count_col == (ref_im.shape[1]-1))
                
                # increment counters
                count_col += 1
                if count_col == ref_im.shape[1]:
                    count_col = 0
                    count_line = (count_line + 1) % ref_im.shape[0]
    
    def RxFrame(self, m_tdata, m_tvalid, m_tready, m_tuser, m_tlast,
                clock, out_im):
        yield delay(30)
        tuser_count = 0
        while 1:
            yield posedge(clock)
            m_tready.next = random.getrandbits(1)
            m_tready.next = 1
            if m_tvalid == 1 and m_tready == 1:
                if m_tuser:
                    tuser_count += 1
                if tuser_count == 1:
                    out_im.append(int(m_tdata[:16]))
                    out_im.append(int(m_tdata[15:8]))
                    out_im.append(int(m_tdata[7:0]))
    
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
        
        line_buff = []
        for i in range(256):
            line_buff = []
            for j in range(256):
                line_buff.append([j, j, j])
            ref_image.append(line_buff)
        
        ref_image = np.array(ref_image)
        
        UUT_inst = UUT(clk, reset, s_tdata, s_tvalid, s_tready, s_tuser,
            s_tlast, m_tdata, m_tvalid, m_tready, m_tuser, m_tlast, testparams)
        CLK_inst = self.СlockGen(clk)
        RST_inst = self.ResetGen(reset)
        TX_inst = self.TxFrame(
            s_tdata, s_tvalid, s_tready, s_tuser, s_tlast, clk, ref_image)
        RX_inst = self.RxFrame(
            m_tdata, m_tvalid, m_tready, m_tuser, m_tlast, clk, out_image)
        CRTL_inst = self.RunControl(m_tuser, clk)
        
        sim = Simulation(
            UUT_inst, CLK_inst, RST_inst, TX_inst, RX_inst, CRTL_inst)
        sim.run()
        
        # calculate diffrence
        
        ref_image = np.array(ref_image)
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
        
        pass



if __name__ == '__main__':
    unittest.main()
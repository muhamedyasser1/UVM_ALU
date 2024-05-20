interface aluInterface (
    input bit clk
);

logic        srcCy, srcAc, bit_in, rst;
logic  [3:0] op_code;
logic  [7:0] src1, src2, src3;
logic        desCy, desAc, desOv;
logic  [7:0] des1, des2, des_acc, sub_result;


clocking monitor_cb @(posedge clk);
	default input #0 output #0;
	input  desCy, desAc, desOv;
	input  des1, des2, des_acc, sub_result;
	input  srcCy, srcAc, bit_in;
	input  op_code;
	input  src1, src2, src3;
endclocking

clocking driver_cb @(posedge clk);
	default input #0 output #0;
	output srcCy, srcAc, bit_in;
	output op_code;
	output src1, src2, src3;
	input  desCy, desAc, desOv;
	input  des1, des2, des_acc, sub_result;
endclocking

modport DRIVER(clocking driver_cb, input clk, output rst);
modport MONITOR(clocking monitor_cb, input clk, output rst);
    
	
endinterface //interfacenamess

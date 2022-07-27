// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
// Date        : Mon Nov 22 16:18:15 2021
// Host        : birlutiuclaudiu-HP-Pavilion-Laptop-15-cs3xxx running 64-bit Ubuntu 21.04
// Command     : write_verilog -force -mode synth_stub
//               /home/birlutiuclaudiu/Facultate/An3_sem1/SSC/Laborator/Lab6/TransmitatorUART/TransmitatorUART.srcs/sources_1/ip/vio_0/vio_0_stub.v
// Design      : vio_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "vio,Vivado 2019.1" *)
module vio_0(clk, probe_in0, probe_out0)
/* synthesis syn_black_box black_box_pad_pin="clk,probe_in0[1:0],probe_out0[7:0]" */;
  input clk;
  input [1:0]probe_in0;
  output [7:0]probe_out0;
endmodule

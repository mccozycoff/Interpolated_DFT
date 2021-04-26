# Interpolated_DFT
Implementation of Interpolated DFT algorithms for Rife – Vincent Class I windows

##
Function *[ w_delta, phi_delta, V_delta ] = IpDFT(p,M,V)* performs interpolation of DFT spectrum given by vector V. This vector can be a return product of fft(x) matlab function.

Other input parameters:

p - method : 2 or 3 point interpolation

M - order of Rife Vincent Class I Window used to analyse examined digital signal

Return values:

w_delta - estimated main frequency of spectrum V

phi_delta - estimated main phase 

V_delta - estimated main amplitude

###
Script *draft_analysis.m* presents use of IpDFT function. 

*RVC1.m* file contains windowing function for Rife - Vincent Class I windows. 


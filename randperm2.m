 function [x_permuted] = randperm2(input1,input2)
 
 input1_permuted = randperm(input1);
 x_permuted = input1_permuted(1:input2);
 
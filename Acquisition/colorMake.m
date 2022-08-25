function [ output_args ] = colorMake(swap,nBlks)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if swap
    temp = [1,0,1,0,1;0,1,0,1,1];
else
     temp = [0,1,0,1,1;1,0,1,0,1];
end

    output_args = [1,0,0,1,1;repmat(temp,nBlks,1);1,0,0,1,1];
function [ output_args ] = colorMakeDynamic(nBlks,lrnBlks)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    temp = [1,0,1,0,1;0,1,0,1,1];
    temp2 = [1,0,0,1,1;0,1,1,0,1;];
    output_args = [repmat(temp2,lrnBlks,1);repmat(temp,nBlks,1);repmat(temp2,lrnBlks,1)];
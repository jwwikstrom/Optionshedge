function [ vol ] = volFromKT( K, F, T, delta )
%VOLFROMKT Summary of this function goes here
%   Detailed explanation goes here
    vol = log(K/F)*(T/2-norminv(delta)*sqrt(T))^(-1)
end


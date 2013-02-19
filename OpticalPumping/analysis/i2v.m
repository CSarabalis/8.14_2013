function [ volts ] = i2v( current )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

volts = current*1e-3*49.2; %49.2 ohms, current in ma
end


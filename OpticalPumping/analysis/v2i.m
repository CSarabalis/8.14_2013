function [ current ] = v2i( volts )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

current = volts/49.2*1000; %49.2 ohms, current in ma
end


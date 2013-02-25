function [ volts ] = i2v( current )
%i2v(current) = volts
% uses 49.2 ohms for the resistance of the Z-coil

volts = current*1e-3*49.2; %49.2 ohms, current in ma
end


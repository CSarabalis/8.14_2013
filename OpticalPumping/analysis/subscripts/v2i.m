function [ current ] = v2i( volts )
%v2i Converts voltage applied to the coils in volts to current in
%milliamps

current = volts/49.2*1000; %49.2 ohms, current in ma
end


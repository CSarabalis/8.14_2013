function [ current ] = v2i( volts )
%v2i Converts voltage applied to the coils in volts to current in
%milliamps

current = volts/55.57*1000; %55.57+-0.33 ohms, current in ma
end


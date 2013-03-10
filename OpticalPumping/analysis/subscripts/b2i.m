function [ i ] = b2i( magfield, direction )
% Converts magnetic field in Gauss to current in mA

muNot = 4*pi*10^-7; % SI
b = 10^-4*magfield;  %convert Gauss to Tesla

if strcmpi(direction, 'x')
    N = 50;
    R = 7.3*2.54*0.01;
elseif strcmpi(direction,'y')
    N = 75;
    R = 8.9*2.54*0.01;
elseif strcmpi(direction,'z')
    N = 180;
    R = 11.0*2.54*0.01;  %these radii are to the middle of the rings, can be improved in the future
else
    error('incorrect input: 2nd argument "direction"');
end

current = b.*(sqrt(125) * R)/(8 .* muNot .* N); %in Amperes
i = current * 10^3; %convert A to mA

end
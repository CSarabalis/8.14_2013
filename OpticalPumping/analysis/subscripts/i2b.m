function [ b ] = i2b( current, direction )
% Converts current in mA to magnetic field in Gauss

muNot = 4*pi*10^-7; % SI
current = current * 10^-3; %convert mA to A


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

b = 8 .* muNot .* N .* current ./(sqrt(125) * R); %in Tesla
b = 10^4*b;  %convert Tesla to Gauss

end
function [ y ] = lorentzian( x, a, scale )
%lorentzian dawg, it's a lorentzian

y = a(1)*scale(1)./(((x-a(2)*scale(2))/a(3)/scale(3)).^2+1);

end


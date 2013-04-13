function bananas = getCoeffs(fh,isotope)

j=1.5;

a = (Cf(fh,isotope)-Cf(fh-1,isotope))/2;

if isotope == 87
    i=1.5;
end
if isotope == 85
    i=2.5;
end

b_pre = (1/(2*i*(2*i-1)*j*(2*j-1)));
b = b_pre*(3/4)*(Cf(fh,isotope)*(Cf(fh,isotope)+1)-Cf(fh-1,isotope)*(Cf(fh-1,isotope)+1));

bananas = [a b];

end
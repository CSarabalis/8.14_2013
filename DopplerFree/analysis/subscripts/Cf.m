function bananas = Cf(f,isotope)

j=1.5;

if isotope == 87
    i=1.5;
end
if isotope == 85
    i=2.5;
end

cf = f*(f+1) - j*(j+1) - i*(i+1);

bananas = cf;

end

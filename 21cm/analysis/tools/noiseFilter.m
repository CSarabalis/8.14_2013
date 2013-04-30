function bananas = noiseFilter(data,index)

span = 5;
range = 9:141;
filterRange = 1:80;

y = fft(data(index).counts(range));
y = y(filterRange);

x = abs(ifft(y));
x = smooth(x,span);

bananas = x;

end
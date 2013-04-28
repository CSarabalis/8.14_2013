function bananas = noiseFilter(data,index)

y = fft(data(index).counts);
y = y(1:100);

bananas = ifft(y);

end
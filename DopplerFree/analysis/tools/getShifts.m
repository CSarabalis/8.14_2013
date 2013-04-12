function bananas = getShifts(data,index)

% fp vals
i=index;
fp = data{i}.fp(data{i}.peakIndices);

m=data{i}.peakOrder+1;
amp = abs(data{i}.sineY(m+1)-data{i}.sineY(m))/2;
off = (data{i}.sineY(m+1)+data{i}.sineY(m))/2;
m=m-1;

%scale values greater than +-1 to +-1 so that asin doesnt give imaginary
%results
args = (fp-off)./amp;
for j=1:max(size(args))
    if args(j) >= 1
        args(j) = 1;
    end
    if args(j) <= -1
        args(j) = -1;
    end
end

shifts = asin(args);

% convert arcsin into freq diffs
shifts = (-1).^(m+1).*shifts+(m+1/2)*pi; % convert arcsin into phase diffs
shifts = sort(shifts/(2*pi)); % convert phase diffs to wavenumbers and sort
shifts = shifts-shifts(1); % normalize to first peak

L = 0.4655;  % length of FP
uncert_L = 0.005;  % uncert in length of FP
c = 2.998*10^8;  % speed of light
n_air = 1.000277;  % refractive index of air
fsr = c/(2*n_air*L); % calculate free spectral range of FP. FSR = 321.9 MHz

shifts = shifts*fsr/10^9;  % get frequencies in GHz
shifts_diff = [0; diff(shifts)];  % get freq diffs in GHz

data{index}.shifts = shifts;
data{index}.shiftsDiff = shifts_diff;

bananas = data;

end
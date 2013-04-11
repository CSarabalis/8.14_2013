function bananas = shiftsAvg(data, indices)

shifts = [];
shifts_diff = [];

for i=indices
    shifts = [shifts data{i}.shifts];
    shifts_diff = [shifts_diff data{i}.shiftsDiff];
end

a = mean(shifts,2);
b = mean(shifts_diff,2);

c = std(shifts,0,2);
d = std(shifts_diff,0,2);

bananas=struct;

bananas.shifts = a;
bananas.shiftsDiff = b;
bananas.shiftsStatUncert = c;
bananas.shiftsDiffStatUncert = d;
    
end
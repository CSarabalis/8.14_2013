function bananas = azscan(data,indices,l,r)

a=[];

peak_l = l;
peak_r = r;

for i=indices
    a = [a; data(i).az_offset sum(data(i).counts(peak_l:peak_r)) data(i).el];
end

figure()
plot(a(:,1),a(:,2),'.')
xlabel('Azimuth Offset')
ylabel('Sum of counts in peak')
title(['Sun azimuth scan. El = ' num2str(mean(a(:,3)))])


end
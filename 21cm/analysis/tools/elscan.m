function bananas = elscan(data,indices,l,r)

a=[];

peak_l = l;
peak_r = r;

for i=indices
    a = [a; data(i).el_offset sum(data(i).counts(peak_l:peak_r)) data(i).az];
end

figure()
plot(a(:,1),a(:,2),'.')
xlabel('Elevation offset')
ylabel('Sum of counts in peak')
title(['Sun elevation scan. Az = ' num2str(mean(a(:,3)))])


end
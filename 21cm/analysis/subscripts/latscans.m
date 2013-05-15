% jlab has broken us

%% G175
a=[];

peak_l = 43;
peak_r = 73;

for i=2:6
    a = [a; latscang175(i).glat sum(latscang175(i).counts(peak_l:peak_r)) latscang175(i).glon];
end

figure()
plot(a(:,1),a(:,2),'.')
xlabel('Galactic Latitude')
ylabel('Sum of counts in peak')
title(['Galactic latitude scan. Glon = ' num2str(mean(a(:,3)))])

clear a i peak_r peak_l


%% G190

a=[];

baseline_index = 3;

peak_l = 31;
peak_r = 59;

for i=2:14
    a = [a; latscang190(i).glat sum(latscang190(i).counts(peak_l:peak_r)-...
        latscang190(baseline_index).counts(peak_l:peak_r)) latscang190(i).glon];
end

figure()
plot(a(:,1),smooth(a(:,2),3),'-')
xlabel('Galactic Latitude','FontSize',20)
ylabel('Sum of counts in peak','FontSize',20)
title(['Galactic latitude scan. Glon = ' num2str(mean(a(:,3)))],'FontSize',20)

clear a i peak_r peak_l baseline_index

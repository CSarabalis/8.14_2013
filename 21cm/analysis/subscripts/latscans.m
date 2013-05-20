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

x = a(:,1);
y = smooth(a(:,2),3);
errs = smooth(abs(y-a(:,2)),6)/5+10;
a0 = [240 2 8 0.1];
gaussian = @(x,a) a(1)*exp(-((x+a(2))/a(3)).^2)+a(4);

[a,aerr,chisq,yfit,corr] = levmar(x,y,errs,gaussian,a0,0,0);

chi2nu = chisq/max(size(x));



figure()
hold on
errorbar(x,y,errs,'.')
plot([-24.9:0.1:24.9],gaussian([-24.9:0.1:24.9],a),'r')
xlabel('Galactic Latitude [deg]','FontSize',20)
ylabel('Sum of counts in peak','FontSize',20)
title(['Galactic latitude scan showing galaxy width ' num2str(round(a(:,3))) ' degrees'],'FontSize',20)
text(0,100,{['$y = a_1 \exp \left[ \frac{-(x-a_2)^2}{a_3{}^2} \right] + a_4$'],
    ['$a_1 = $ ' num2str(round(10*a(1))/10.0) '$\pm$' num2str(round(10*aerr(1))/10.0)...
    ', $a_2 = $ ' num2str(round(10*a(2))/10.0) '$\pm$' num2str(round(10*aerr(2))/10.0)],
    ['$a_3 = $ ' num2str(round(10*a(3))/10.0) '$\pm$' num2str(round(10*aerr(3))/10.0)...
    ', $a_4 = $ ' num2str(round(10*a(4))/10.0) '$\pm$' num2str(round(10*aerr(4))/10.0)],
    ['$\chi^2_{\nu} = $' num2str(round(10*chi2nu)/10.0)]})
    
clear a i peak_r peak_l baseline_index

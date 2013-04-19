% guess 1
model = @(x,a) a(1)*x.^2 + a(2)*x + a(3);

i=4; 
a = cluster{i}.autocorr.fits{1}.a;
peak = cluster{i}.autocorr.fits{1}.peak;
covar = cluster{i}.autocorr.fits{1}.covar;

s2 = (0.5*a(2)/a(1)^2)^2*covar(1,1)^2 + (2*a(1))^-2*covar(2,2)^2+...
    0.5*(-a(2)/a(1)^3)*covar(1,2)^2;
sqrt(s2)
sqrt(s2)/peak

% so relative error is 1 in 10 million --> negligible





%% plotting
x = [-100:1:100];
y = model(x,a);
ACF = cluster{4}.autocorr.ACF;
hold all
plot(x+peak,y*10^-6+0.75)
plot(ACF)
% A is the acef model
% B is the abc model

% peak 1 models
peak1.A = [peak1.shiftsDiff(2)+peak1.shiftsDiff(3);
    peak1.shiftsDiff(4)+peak1.shiftsDiff(5);
    peak1.shiftsDiff(6)];
peak1.Aexp = [0.2667; 0.1569; 0.0722];
peak1.Au = [peak1.uncerts(1)^2+peak1.uncerts(2)^2+peak1.uncerts(3)^2;
    peak1.uncerts(4)^2+peak1.uncerts(5)^2+peak1.uncerts(3)^2;
    peak1.uncerts(6)^2+peak1.uncerts(5)^2].^(0.5);
% cross-over peak stuff
peak1.Axover = peak1.A(1:2)/2;
peak1.Axoverexp = peak1.Aexp(1:2)/2;
peak1.Axoveru = peak1.Au(1:2)/sqrt(2);


peak1.B = [peak1.shiftsDiff(2);
    peak1.shiftsDiff(3)];
peak1.Bexp = [0.1569; 0.0722];
peak1.Bu = [peak1.uncerts(1)^2+peak1.uncerts(2)^2;
    peak1.uncerts(1)^2+peak1.uncerts(2)^2].^0.5;


% peak 4 models
peak4.A = [peak4.shiftsDiff(2)+peak4.shiftsDiff(3);
    peak4.shiftsDiff(4)+peak4.shiftsDiff(5);
    peak4.shiftsDiff(6)];
peak4.Aexp = peak1.Aexp;
peak4.Au = [peak4.uncerts(1)^2+peak4.uncerts(2)^2+peak4.uncerts(3)^2;
    peak4.uncerts(4)^2+peak4.uncerts(5)^2+peak4.uncerts(3)^2;
    peak4.uncerts(6)^2+peak4.uncerts(5)^2].^(0.5);
peak4.Axover = peak4.A(1:2)/2;
peak4.Axoverexp = peak4.Aexp(1:2)/2;
peak4.Axoveru = peak4.Au(1:2)/sqrt(2);


peak4.B = [peak4.shiftsDiff(2);
    peak4.shiftsDiff(3)];
peak4.Bexp = peak1.Bexp;
peak4.Bu = [peak4.uncerts(1)^2+peak4.uncerts(2)^2;
    peak4.uncerts(2)^2+peak4.uncerts(3)^2].^0.5;



% peak 2 models
peak2.C = [peak2.shiftsDiff(2)+peak2.shiftsDiff(3);
    peak2.shiftsDiff(4)];
peak2.exp = [63.4; 29.3]*10^-3;
peak2.Cu = [peak2.uncerts(1)^2+peak2.uncerts(2)^2+peak2.uncerts(3)^2;
    peak2.uncerts(3)^2+peak2.uncerts(4)^2].^0.5;


% peak 3 models
peak3.C = [peak3.shiftsDiff(2)+peak3.shiftsDiff(3);
    peak3.shiftsDiff(4)];
peak3.exp = [63.4; 29.3]*10^-3;
peak3.Cu = [peak3.uncerts(1)^2+peak3.uncerts(2)^2+peak3.uncerts(3)^2;
    peak3.uncerts(3)^2+peak3.uncerts(4)^2].^0.5;


for j=1:6
% % peak 2 models
% peak2.C = [peak2.shiftsDiff(2)+peak2.shiftsDiff(3);
%     peak2.shiftsDiff(4);
%     peak2.shiftsDiff(5)];
% peak2.exp = [121.0; 63.4; 29.3]*10^-3;
% peak2.Cu = [peak2.uncerts(1)^2+peak2.uncerts(2)^2+peak2.uncerts(3)^2;
%     peak2.uncerts(3)^2+peak2.uncerts(4)^2;
%     peak2.uncerts(4)^2+peak2.uncerts(5)^2].^0.5;
% % peak 3 models
% peak3.C = [peak3.shiftsDiff(2)+peak3.shiftsDiff(3);
%     peak3.shiftsDiff(4);
%     peak3.shiftsDiff(5)];
% peak3.exp = [121.0; 63.4; 29.3]*10^-3;
% peak3.Cu = [peak3.uncerts(1)^2+peak3.uncerts(2)^2+peak3.uncerts(3)^2;
%     peak3.uncerts(3)^2+peak3.uncerts(4)^2;
%     peak3.uncerts(4)^2+peak3.uncerts(5)^2].^0.5;
end 
clear j


% evaluate p-values
means = [peak1.Aexp; peak1.Bexp; peak2.exp; peak3.exp; peak4.Aexp; peak4.Bexp;...
    peak1.Axoverexp; peak4.Axoverexp];
stds = [peak1.Au; peak1.Bu; peak2.Cu; peak3.Cu; peak4.Au; peak4.Bu; ...
    peak1.Axoveru; peak4.Axoveru];
datas = [peak1.A; peak1.B; peak2.C; peak3.C; peak4.A; peak4.B; ...
    peak1.Axover; peak4.Axover];

pvals = []; % prob of getting worse result
pvalsInner = []; % prob of getting better result

% calculates p-value for each peak
for i=1:max(size(means))
    pvals = [pvals; 2*cdf(gmdistribution(0,stds(i)^2),-abs(means(i)-datas(i)))];
    pvalsInner = [pvals; 2*(cdf(gmdistribution(0,stds(i)^2),abs(means(i)-datas(i)))-0.5)];
end


% designation of output
peak1.Apvals = pvals(1:3);
peak1.Bpvals = pvals(4:5);
peak2.Cpvals = pvals(6:7);
peak3.Cpvals = pvals(8:9);
peak4.Apvals = pvals(10:12);
peak4.Bpvals = pvals(13:14);
peak1.Axoverpvals = pvals(15:16);
peak4.Axoverpvals = pvals(17:18);

% prob of getting better result for each peak cluster
peak1.ApvalsInner = pvalsInner(1:3);
peak1.BpvalsInner = pvalsInner(4:5);
peak2.CpvalsInner = pvalsInner(6:7);
peak3.CpvalsInner = pvalsInner(8:9);
peak4.ApvalsInner = pvalsInner(10:12);
peak4.BpvalsInner = pvalsInner(13:14);
peak1.AxoverpvalsInner = pvalsInner(15:16);
peak4.AxoverpvalsInner = pvalsInner(17:18);

% prob of getting worse result for each cluster
peak1.Ap = 1-prod(peak1.ApvalsInner);
peak1.Bp = 1-prod(peak1.BpvalsInner);
peak2.Cp = 1-prod(peak2.CpvalsInner);
peak3.Cp = 1-prod(peak3.CpvalsInner);
peak4.Ap = 1-prod(peak4.ApvalsInner);
peak4.Bp = 1-prod(peak4.BpvalsInner);
peak1.Apxover = 1-prod(peak1.ApvalsInner)*prod(peak1.AxoverpvalsInner);
peak4.Apxover = 1-prod(peak4.ApvalsInner)*prod(peak4.AxoverpvalsInner);

clear means stds datas pvals pvalsInner i overallP 


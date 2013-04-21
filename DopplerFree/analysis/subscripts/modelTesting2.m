% peak 1
peak1.ADF = [peak1.shiftsDiff(2)+peak1.shiftsDiff(3)+peak1.shiftsDiff(4);
    peak1.shiftsDiff(5)+peak1.shiftsDiff(6)];
peak1.ADFexp = [0.2667; 0.1569];
peak1.ADFu = [peak1.uncerts(1)^2+peak1.uncerts(2)^2+peak1.uncerts(3)^2+peak1.uncerts(4)^2;
    peak1.uncerts(4)^2+peak1.uncerts(5)^2+peak1.uncerts(6)^2].^(0.5);
% cross-over peak stuff
peak1.ADFxover = [peak1.shiftsDiff(2);
    peak1.shiftsDiff(2)+peak1.shiftsDiff(3);
    peak1.shiftsDiff(5)];    
peak1.ADFxoverexp = [0.1333; 0.2118; 0.0785];
peak1.ADFxoveru =[peak1.uncerts(1)^2+peak1.uncerts(2)^2;
    peak1.uncerts(2)^2+peak1.uncerts(3)^2+peak1.uncerts(1)^2;
    peak1.uncerts(4)^2+peak1.uncerts(5)^2];


%peak 4
peak4.ADF = [peak4.shiftsDiff(2)+peak4.shiftsDiff(3)+peak4.shiftsDiff(4);
    peak4.shiftsDiff(5)+peak4.shiftsDiff(6)];
peak4.ADFexp = [0.2667; 0.1569];
peak4.ADFu = [peak4.uncerts(1)^2+peak4.uncerts(2)^2+peak4.uncerts(3)^2+peak4.uncerts(4)^2;
    peak4.uncerts(4)^2+peak4.uncerts(5)^2+peak4.uncerts(6)^2].^(0.5);
% cross-over peak stuff
peak4.ADFxover = [peak4.shiftsDiff(2);
    peak4.shiftsDiff(2)+peak4.shiftsDiff(3);
    peak4.shiftsDiff(5)];
peak4.ADFxoverexp = [0.1333; 0.2118; 0.0785];
peak4.ADFxoveru =[peak4.uncerts(1)^2+peak4.uncerts(2)^2;
    peak4.uncerts(2)^2+peak4.uncerts(3)^2+peak4.uncerts(1)^2;
    peak4.uncerts(4)^2+peak4.uncerts(5)^2];


%peak 2
peak2.ACE = [peak2.shiftsDiff(2)+peak2.shiftsDiff(3)+peak2.shiftsDiff(4)/2;
    peak2.shiftsDiff(4)/2+peak2.shiftsDiff(5)];
peak2.ACEexp = [63.4; 29.3]*10^-3;
peak2.ACEu = [peak2.uncerts(1)^2+peak2.uncerts(2)^2+peak2.uncerts(3)^2;
    peak2.uncerts(3)^2+peak2.uncerts(4)^2+peak2.uncerts(5)^2].^0.5;
    

%peak 3
peak3.ACE = [peak3.shiftsDiff(2)+peak3.shiftsDiff(3)/2;
    peak3.shiftsDiff(4)+peak3.shiftsDiff(5)/2];
peak3.ACEexp = [63.4; 29.3]*10^-3;
peak3.ACEu = [peak3.uncerts(1)^2+peak3.uncerts(2)^2+peak3.uncerts(3)^2;
    peak3.uncerts(3)^2+peak3.uncerts(4)^2+peak3.uncerts(5)^2].^0.5;


%scaling = 0.82;
peak1.ADF = peak1.ADF*scaling;
peak1.ADFxover = peak1.ADFxover*scaling;
peak4.ADF = peak4.ADF*scaling;
peak4.ADFxover = peak4.ADFxover*scaling;
peak3.ACE = peak3.ACE*scaling;
peak2.ACE = peak2.ACE*scaling;


%% eval pvals

% evaluate p-values
means = [peak1.ADFexp; peak2.ACEexp; peak3.ACEexp; peak4.ADFexp;...
    peak1.ADFxoverexp; peak4.ADFxoverexp];
stds = [peak1.ADFu; peak2.ACEu; peak3.ACEu; peak4.ADFu;...
    peak1.ADFxoveru; peak4.ADFxoveru];
datas = [peak1.ADF; peak2.ACE; peak3.ACE; peak4.ADF;...
    peak1.ADFxover; peak4.ADFxover];

pvals = []; % prob of getting worse result
pvalsInner = []; % prob of getting better result

% calculates p-value for each peak
for i=1:max(size(means))
    pvals = [pvals; 2*(cdf(gmdistribution(0,stds(i)^2),abs(means(i)-datas(i)))-0.5)];
end

% designation of output
peak1.ADFpvals = pvals(1:2);
peak2.ACEpvals = pvals(3:4);
peak3.ACEpvals = pvals(5:6);
peak4.ADFpvals = pvals(7:8);
peak1.ADFxoverpvals = pvals(9:11);
peak4.ADFxoverpvals = pvals(12:14);

% prob of getting worse result for each cluster
peak1.ADFp = 1-prod(peak1.ADFpvals);
peak2.ACEp = 1-prod(peak2.ACEpvals);
peak3.ACEp = 1-prod(peak3.ACEpvals);
peak4.ADFp = 1-prod(peak4.ADFpvals);
peak1.ADFpxover = 1-prod(peak1.ADFpvals)*prod(peak1.ADFxoverpvals);
peak4.ADFpxover = 1-prod(peak4.ADFpvals)*prod(peak4.ADFxoverpvals);

% peak1.ADFp = prod(peak1.ADFpvals);
% peak2.ACEp = prod(peak2.ACEpvals);
% peak3.ACEp = prod(peak3.ACEpvals);
% peak4.ADFp = prod(peak4.ADFpvals);
% peak1.ADFpxover = prod(peak1.ADFpvals)*prod(peak1.ADFxoverpvals);
% peak4.ADFpxover = prod(peak4.ADFpvals)*prod(peak4.ADFxoverpvals);

clear means stds datas pvals pvalsInner i overallP 

%collectResults2


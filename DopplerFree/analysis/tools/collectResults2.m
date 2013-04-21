format short
bananas = [peak1.ADF*10^3 peak1.ADFu*10^3 peak1.ADFexp*10^3 1-peak1.ADFpvals;
        peak4.ADF*10^3 peak4.ADFu*10^3 peak4.ADFexp*10^3 1-peak4.ADFpvals];
bananas = [bananas;
        %peak2.ACE*10^3 peak2.ACEu*10^3 peak2.ACEexp*10^3 1-peak2.ACEpvals;
        peak3.ACE*10^3 peak3.ACEu*10^3 peak3.ACEexp*10^3 1-peak3.ACEpvals];
    
1-peak1.ADFp
1-peak4.ADFp
%1-peak2.ACEp
1-peak3.ACEp

bananas
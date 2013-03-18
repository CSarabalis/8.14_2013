function [fit_agg sweep_amp, sweep_rate] = fitagg(table_letter, peak_num, agg, Btotal)

D_indices = [1:7];
E_indices = [8:11];
G_indices = [12:15];
indices = [1:15];

if table_letter == 'D'
    indices = D_indices;
end
if table_letter == 'EU'
    indices = E_indices([1 3]);
end
if table_letter == 'ED'
    indices = E_indices([2 4]);
end
if table_letter == 'GU'
    indices = G_indices([1 3]);
end
if table_letter == 'GD'
    indices = G_indices([2 4]);
end

peak_uncert_col = 4;
Btot = Btotal(:,2);

if peak_num == 1
    peak_uncert_col = 5;
    Btot = Btotal(:,1);
end
if peak_num == 2
    peak_uncert_col = 4;
    Btot = Btotal(:,2);
end

sweep_amp = mean(agg(indices,8));
sweep_rate = mean(agg(indices,9));

fit_agg = linearFit(agg(indices,1),Btot(indices),i2b(v2i(0.2e-3*agg(indices,peak_uncert_col)),'z'))
%plot model
hold on
plot(agg(indices,1),fit_agg.a*agg(indices,1)+fit_agg.b,'-r')
%annotate
title({'Agg :: Fixed Frequency, Varied B',['Table ' table_letter ': Peak' num2str(peak_num)]})
xlabel('Resonance Frequency [kHz]')
ylabel('Total Magnetic Field [G]')
%fontSize(16)

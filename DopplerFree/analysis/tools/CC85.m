function bananas = CC85(peak)

peak.ACE = [0; peak.ACE];
peak.ACEu = [0; peak.ACEu];

A85 = [];
B85 = [];
% Rb85
% 3-2, 2-1
dum = inv([[getCoeffs(3,85)]; [getCoeffs(2,85)]])*10^3*[peak.ACE(2); peak.ACE(3)];
A85 = [A85; dum(1)];
B85 = [B85; dum(2)];

% % 4-3, 3-2
% dum = inv([[getCoeffs(4,85)]; [getCoeffs(3,85)]])*10^3*[peak.C(1); peak.C(2)];
% A85 = [A85; dum(1)];
% B85 = [B85; dum(2)];
% 
% % 4-3, 2-1
% dum = inv([[getCoeffs(4,85)]; [getCoeffs(2,85)]])*10^3*[peak.C(1); peak.C(3)];
% A85 = [A85; dum(1)];
% B85 = [B85; dum(2)];

A85u = [];
B85u = [];
% Rb85 error propagation
% 3-2, 2-1
% 3-2, 2-1
dum = inv([[getCoeffs(3,85)]; [getCoeffs(2,85)]])*10^3*[peak.ACEu(2); peak.ACEu(3)];
A85u = [A85u; dum(1)];
B85u = [B85u; dum(2)];

% % 4-3, 3-2
% dum = inv([[getCoeffs(4,85)]; [getCoeffs(3,85)]])*10^3*[peak.Cu(1); peak.Cu(2)];
% A85u = [A85u; dum(1)];
% B85u = [B85u; dum(2)];
% 
% % 4-3, 2-1
% dum = inv([[getCoeffs(4,85)]; [getCoeffs(2,85)]])*10^3*[peak.Cu(1); peak.Cu(3)];
% A85u = [A85u; dum(1)];
% B85u = [B85u; dum(2)];



A85 = [A85 abs(A85u)];
B85 = [B85 abs(B85u)];

bananas = {A85, B85};

end
function bananas = CC87(peak)

% Rb87
A87 = [];
B87 = [];
% 3-2, 2-1
dum = inv([[getCoeffs(3,87)]; [getCoeffs(2,87)]])*10^3*[peak.A(1); peak.A(2)];
A87 = [A87; dum(1)];
B87 = [B87; dum(2)];
% 2-1, 1-0
dum = inv([[getCoeffs(2,87)]; [getCoeffs(1,87)]])*10^3*[peak.A(2); peak.A(3)];
A87 = [A87; dum(1)];
B87 = [B87; dum(2)];
% 3-2, 1-0
dum = inv([[getCoeffs(3,87)]; [getCoeffs(1,87)]])*10^3*[peak.A(1); peak.A(3)];
A87 = [A87; dum(1)];
B87 = [B87; dum(2)];

% Rb87 error propagation
A87u = [];
B87u = [];
% 3-2, 2-1
dum = inv([[getCoeffs(3,87)]; [getCoeffs(2,87)]])*10^3*[peak.Au(1); peak.Au(2)];
A87u = [A87u; dum(1)];
B87u = [B87u; dum(2)];
% 2-1, 1-0
dum = inv([[getCoeffs(2,87)]; [getCoeffs(1,87)]])*10^3*[peak.Au(2); peak.Au(3)];
A87u = [A87u; dum(1)];
B87u = [B87u; dum(2)];
% 3-2, 1-0
dum = inv([[getCoeffs(3,87)]; [getCoeffs(1,87)]])*10^3*[peak.Au(1); peak.Au(3)];
A87u = [A87u; dum(1)];
B87u = [B87u; dum(2)];

A87 = [A87 abs(A87u)];
B87 = [B87 abs(B87u)];

bananas = {A87, B87};

end
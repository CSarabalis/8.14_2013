% 3,1
model = @(x,a) a(1)*-21.2500*(x-a(2)*0.78336)+...
  a(3)*0.025*exp(a(4)*(x-0.79084)/1e-4);
nonLinDerivFit(data,3,1,model,[1 1 1 1]);

% 3,2
model = @(x,a) a(1)*1000*(2.7e-5-5.1e-5)/(0.7895-0.7878)*(x-a(2)*0.7911)...
    - a(3)*1000*1.5e-5/2.718*exp(-a(4)*(x-0.785)/7e-4);
nonLinDerivFit(data,3,2,model,[1 1 1 1]);

% 6,1
model = @(x,a) a(1)*-21.7507*(x-0.786*a(2)) +...
  a(3)*0.025*exp(a(4)*(x-0.79338)/1e-4);
nonLinDerivFit(data,6,1,model,[1 1 1 1]);

% 6,2
model = @(x,a) a(1)*1000*(2.7e-5-5.1e-5)/(0.7895-0.7878)*(x-a(2)*0.7911)...
    - a(3)*1000*1.5e-5/2.718*exp(-a(4)*(x-0.785)/7e-4);
nonLinDerivFit(data,6,2,model,[1 1 1 1]);

% 7,1
model = @(x,a) a(1)*-21.7507*(x-0.786*a(2)) +...
  a(3)*0.025*exp(a(4)*(x-0.79338)/1e-4);
nonLinDerivFit(data,7,1,model,[1 1 1 1]);

% 7,2
model = @(x,a) a(1)*-0.047/(0.794-0.79049)*(x-a(2)*0.794)+...
a(3)*-0.014*exp(-a(4)*(x-0.78759)/1.3e-4);
nonLinDerivFit(data,7,2,model,[1 1 1 1]);

%8,1
model = @(x,a) a(1)*-21.7507*(x-0.786*a(2)) +...
  a(3)*25*exp(a(4)*(x-0.79338)/1e-4);
nonLinDerivFit(data,8,1,model,[1 1 1 1]);

%8,2
model = @(x,a) a(1)*-0.047/(0.794-0.79049)*(x-a(2)*0.794)+...
a(3)*-0.05*exp(-a(4)*(x-0.7855)/1e-4);
nonLinDerivFit(data,8,2,model,[1 1 1 1]);

%9,1
model = @(x,a) a(1)*-21.7507*(x-0.78098*a(2)) +...
  a(3)*0.02*exp(a(4)*(x-0.78694)/1e-4);
nonLinDerivFit(data,9,1,model,[1 1 1 1]);

%9,2
model = @(x,a) a(1)*-1*(x-a(2)*0.7871)+...
a(3)*-0.05*exp(-a(4)*(x-0.7815)/5e-4);
nonLinDerivFit(data,9,2,model,[1 1 1 1]);
gtext({'$$-a_1(x-a_2)0.7871 -\frac{a_3}{2}\exp\left(\frac{-a_4(x-0.7815)}{50000}\right)$$', ...
    'a = [13.57 1 0.683 0.640]', '$$\chi^2_{\nu} = 2115.6$$'})

%10,1
model = @(x,a) a(1)*-20*(x-0.3185*a(2)) +...
  a(3)*0.01*exp(a(4)*(x-0.3206)/1e-4);
nonLinDerivFit(data,10,1,model,[1 1 1 1]);

%10,2
model = @(x,a) a(1)*-10*(x-a(2)*0.32065)+...
a(3)*-0.05*exp(-a(4)*(x-0.3186)/3e-4);
nonLinDerivFit(data,10,2,model,[1 1 1 1]);

%11,1
model = @(x,a) a(1)*-20*(x-0.20235*a(2)) +...
  a(3)*0.01*exp(a(4)*(x-0.20335)/0.5e-4);
nonLinDerivFit(data,11,1,model,[1 1 1 1]);

%11,2
model = @(x,a) a(1)*-10*(x-a(2)*0.2034)+...
a(3)*-0.005*exp(-a(4)*(x-0.2024)/5e-4);
nonLinDerivFit(data,11,2,model,[1 1 1 1]);

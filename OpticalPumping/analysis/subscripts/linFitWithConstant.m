function[fitParameters, covarianceMatrix, chi2] = linFitWithConstant(varargin)
%Solves A X = Y for X.   X is a vector of fit parameters and includes a constant.
%   A is a matrix of coefficients containing information about the data.  
%   Y is a vector that contains information about the data.  The analysis 
%   follows Bevington Chapter 7.2.
%
%Inputs
%   columns of independent variables (highest order first i.e, in order of
%   x^n x^n-1 ... x^2 x) 
%   column of dependent variables 
%   estimated standard deviations of the parent distribution for each point
% Assumptions: all must have the same length
%
%Outputs
%   fitParameters: array of fit coefficients for a linear model with the
%       last entry being a constant
%   covarianceMatrix: the covariances of the fit parameters
%   chi2: the reduced chi squared of the fit


n = nargin;

%CHECK INPUT array dimensions for consistency

for i = 1:n-3
    if length(varargin{i}) ~= length(varargin{i+1})
        error('Input vectors dimensions mismatch. Check the ',num2str(i+1),' argument.')
    end
end

%PARSE INPUTS and place them in variables called x, y, sigma

x = zeros(length(varargin{1}),n-2);
for i = 1:n-2
    x(:,i) = varargin{i};
end
y = varargin{n-1};
sigma = varargin{n};


%A is the matrix of coefficients of the fit parameters in the linear system
%   that results from minimizing chi^2 assuming Gaussian statistics. Refer
%   to Bevington chapter 7.2. (A is the matrix bev calls alpha)

A = zeros(n-1,n-1); %preallocate
for j = 1:n-2   
    for k = 1:j
        A(j,k) = sum(x(:,j).*x(:,k)./sigma.^2);
        A(k,j) = A(j,k);   %use matrix symmetry to reduce computations
    end
end
for j = 1:n-2 % to handle the constant term
    A(j,n-1) = sum(x(:,j)./sigma.^2);
    A(n-1,j) = A(j,n-1);  %use matrix symmetry to reduce computations
end
A(n-1,n-1) = sum(1./sigma.^2); %constant term on the diag

%Y,not to be confused with y, is on the right side of the matrix equation.
% (Y is the vector bev calls beta)

Y = zeros(n-1,1); %preallocate
for j = 1:n-2
    Y(j) = sum(y.*x(:,j)./sigma.^2);
end
Y(n-1) = sum(y./sigma.^2);

covarianceMatrix = inv(A);
fitParameters = covarianceMatrix*Y; % the vector bev calls a
ymodel = [x,ones(length(y),1)]*fitParameters;
chi2 = sum((y - ymodel).^2./sigma.^2)/(length(y)-n+1);

end
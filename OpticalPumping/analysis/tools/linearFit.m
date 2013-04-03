function[fit] = linearFit(x,y,err,varargin)
%linearFit fits a line and plots the result with fit statistics.
%
%  fit = linearFit(x,y,err) plots y vs x with errorbars and a fit of 
%  y = a*x + b, and returns a structure with .a,the propagated uncertainty 
%  in a .aerr, .b, the propagated uncertaintyt in b .berr, .residuals, and 
%  the reduced chi square .chi2.
%
%  varargin can hold raw data x, raw data y; and additionally an array of
%  indices to be excluded from the fit

priorHoldState = ishold;

%plot the raw data if provided
hold on
if nargin >= 4
    plot(varargin{1},varargin{2},'.','Color',[.87 .92 .98])
end

%plot excluded errorbars and cut data if exlusion indices are provided
if nargin >= 6
    %plot errorbars
    errorbar(x(varargin{3}),y(varargin{3}),err(varargin{3}),'.r')
    %cut the data
    x(varargin{3})=[];
    y(varargin{3})=[];
    err(varargin{3})=[];
end

%components of the computation
x2     = x.^2;
var    = err.^2;
ovar   = sum(var.^-1);
x2ovar = sum(x2./var);
xovar  = sum(x./var);
yovar  = sum(y./var);
xyovar = sum(x.*y./var);

%compute fit parameters, errors, and residuals
delta         = ovar*x2ovar - xovar^2;
fit.a         = (ovar*xyovar - xovar*yovar)/delta;
fit.aerr      = sqrt(ovar/delta);
fit.b         = (x2ovar*yovar - xovar*xyovar)/delta;
fit.berr      = sqrt(x2ovar/delta);
fit.residuals = y - fit.a*x - fit.b;
fit.chi2      = sum(fit.residuals.^2./var)/length(y);

%plot
plot(x,fit.a*x+fit.b,'-','Color',[0 0 .8])
errorbar(x,y,err,'.','Color',[.2 .2 1])
%annotate
axisDim = axis();
text(axisDim(1) + (axisDim(2)-axisDim(1))/10,axisDim(4) -...
    (axisDim(4)-axisDim(3))/10,{'$$y = a x + b$$',...
    ['$$a = ',num2str(fit.a),' \pm $$',num2str(fit.aerr)],...
    ['$$b = ',num2str(fit.b),' \pm $$',num2str(fit.berr)],...
    ['$$\chi_\nu = $$',num2str(fit.chi2)]})

%return to prior hold state
if priorHoldState
	hold on
else
	hold off
end

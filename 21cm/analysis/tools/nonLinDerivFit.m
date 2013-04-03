function[] = nonLinDerivFit(data,i,j,model,a0)
%encapsulates a script to plot and fit the rates data
%
%   data: cell array of data structures
%   i:    index of the data set
%   j:    index of the range
%   model is the model used in levmar, e.g @(x,a)= a(1)x+ exp(a(2)*x);
%
%if model is empty, plots the raw data and derivative

%define working variables
indices = data{i}.range{j};
x = data{i}.data(indices,1);
y = data{i}.data(indices,2);
z = diff(y)/0.001;
err = sqrt(2)*1e-3*ones(length(z),1);

%plot raw
figure
subplot(2,1,1)
plot(x,y,'.')
%annotate
xlabel('Time [s]')
ylabel('Photodiode Voltage [V]')
title(['(',num2str(i),',',num2str(j),')'])
%plot derivative
subplot(2,1,2)
errorbar(y(1:end-1),z,err,'.')
%annotate
xlabel('Photodiode Voltage [V]')
ylabel('dV/dt [V/s]')

data{i}.nonLin = cell(2);

if ~isempty(model)
  %store the model
  data{i}.nonLin{j}.model = model;
  
  display([num2str(i),',',num2str(j)])
  %nonlinear fit
  [data{i}.nonLin{j}.a,data{i}.nonLin{j}.aerr,data{i}.nonLin{j}.chisq,...
      data{i}.nonLin{j}.yfit,data{i}.nonLin{j}.corr]=levmar(y(1:end-1),...
      z,err,model,a0,0,0);
    

  %plot fit
  subplot(2,1,2)
  hold on
  plot(y(1:end-1),data{i}.nonLin{j}.yfit,'-r')

end


end
function [fit1,a5,a6,d4,eegz4] = fitness_calc(A1, numreps,subject)
% function simulated model

Liley_params;
% Load data
load('EEG_data_ctl.mat')
data = EEG_data_ctl(subject,:)-mean(EEG_data_ctl(subject,:));
data = zscore(data);
data = filter_b_f(data, 2, 256,'high',4);% 2 Hz high pass filter
data = zscore(data);


[dd,lags] = pwelch(data,[],[],[],256);
dd1 = dd(lags>2&lags<20);
dd1=dd1/sum(dd1);
dd2 = dd(lags>2&lags<20);
dd2=dd2/sum(dd2);


fhz1 = 19.965*4; % main timstep
tcut=5000;
TDatend=20000;
T1 = 0:1/fhz1:(TDatend+tcut);
TDat = linspace(0,19.9961,5120);
vg= fast_HVG(zscore(data), TDat, 'w');
d = full(sum(vg));
paramstoest =[1:22,25];
paramsinput = [paramsvec, zeros(1,10)];
paramsinput(paramstoest) = A1;

% load in the data to fit against
eegdatadegdist = d;

a2=[];
a4=[];
fithvg=[];
d3=[];
eegz3=[];
for RunIter = 1:numreps % run 5 times for stability: - take the mean value for the fitness func
% run model
T=T1;
y=em_Liley_mex(T,paramsinput);

% EEG output is first row
final_eeg=y(1,fhz1*tcut:end);
final_eeg = final_eeg-mean(final_eeg);
eegz = zscore(final_eeg);

% calculate and compare the degree dist of the hvg
eegz2 = resample(eegz,1,78*4);
eegz2=zscore(eegz2);
eegz3 = [eegz3;eegz2];

vg2= fast_HVG(eegz2, linspace(0,19.9961,length(eegz2)), 'w');
d2 = full(sum(vg2));
d3=[d3;d2];
[~,~,ks2stat] = kstest2(d2,eegdatadegdist);
fithvg=[fithvg,ks2stat];

% PSD fit 
if isnan(final_eeg(end))
final_eeg=0;
else
    
% fit spectra
[a,lags] = pwelch(eegz,[],[],8000*fhz1,fhz1);
% limit to frequency range of data
lags=lags*1000;
a3=a(lags>2&lags<45);
a3=a3/sum(a3);
a=a(lags>2&lags<20);
a=a/sum(a);
a2=[a2,a];
a4=[a4,a3];

end
end

% If unable to  clauclate, set fitness to a high value
if isempty(a2)||isnan(a2(1))
    fit1=[100,100];
else

% Calculate mean and normalise
a5=mean(a2,2);
a5=a5/sum(a5);
a6=mean(a4,2);
a6=a6/sum(a6);

d4 = d3(1,:);
eegz4 = eegz3(1,:);

fitobj1 = sum(((a5-dd1).^2)); 
fitobj3= mean(fithvg);

if isnan(fitobj1)||isnan(fitobj3)
    fit1=[100,100];
else
fit1=[fitobj1,fitobj3];
end
end

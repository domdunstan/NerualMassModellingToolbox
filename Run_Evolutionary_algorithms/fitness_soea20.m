function fit1 = fitness_soea20(A1, paramsvec, eegdata1, paramstoest, T1,tcut, fhz1)
paramsinput = [paramsvec, zeros(1,10)];
paramsinput(paramstoest) = A1;
% load in the data to fit against
eegautocor = eegdata1{2};

a2=[];
parfor RunIter = 1:5 % run 5 times for stability: - take the mean value for the fitness func
% run model
T=T1;
y=em_Liley_mex(T,paramsinput);


% EEG output is first row
final_eeg=y(1,fhz1*tcut:end);
final_eeg = final_eeg-mean(final_eeg);
eegz = zscore(final_eeg);

% PSD fit 
if isnan(final_eeg(end))
final_eeg=0;
else
    
% fit spectra
[a,lags] = pwelch(eegz,[],[],8000*fhz1,fhz1);
% limit to frequency range of data
lags=lags*1000;
a=a(lags>2&lags<20);
a=a/sum(a);
a2=[a2,a];

end
end

% If unable to  clauclate, set fitness to a high value
if isempty(a2)||isnan(a2(1))
    fit1=100;
else

% Calculate mean and normalise
a3=mean(a2,2);
a3=a3/sum(a3);
fitobj1 = sum(((a3-eegautocor).^2)); 

if isnan(fitobj1)
    fit1=100;
else
fit1 = fitobj1;
end
end

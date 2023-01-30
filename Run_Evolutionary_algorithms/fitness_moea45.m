function fit1 = fitness_moea45(A1, paramsvec, eegdata1, paramstoest, T1,tcut, fhz1)
paramsinput = [paramsvec, zeros(1,10)];
paramsinput(paramstoest) = A1;

% load in the data to fit against
eegautocor = eegdata1{1};
eegdatadegdist = eegdata1{4};
z = eegdata1{2};
z2 = eegdata1{3};
a4=[];
fithvg=[];
parfor RunIter = 1:5 % run 5 times for stability: - take the mean value for the fitness func
% run model
T=T1;
y=em_Liley_mex(T,paramsinput);



% EEG output is first row
final_eeg=y(1,fhz1*tcut:end);
final_eeg = final_eeg-mean(final_eeg);
eegz = zscore(final_eeg);

% calculate and compare the degree dist of the hvg
eegz2 = resample(eegz,1,312);
eegz2 = zscore(eegz2);

vg2= fast_HVG(eegz2, linspace(0,19.9961,length(eegz2)), 'w');
d2 = full(sum(vg2));
[~,~,ks2stat] = kstest2(d2,eegdatadegdist);
fithvg=[fithvg,ks2stat];

% PSD fit 
if isnan(final_eeg(end))
final_eeg=0;
else
    
% fit spectra
[a,lags] = pwelch(eegz,[],[],8000*fhz1,fhz1);
lags = lags*1000;
a = a(lags>2&lags<45);
a=a/sum(a);
% convert to log log
a2 = log(a);
% pre whiten
a3 = a2 - z;
a3 = a3-z2;
a3 = a3/sum(a3);
a4=[a4,a3];

end
end

% If unable to  clauclate, set fitness to a high value
if isempty(a4)||isnan(a4(1))
    fit1=[100,100];
else

% Calculate mean and normalise
a5=mean(a4,2);
a5=a5/sum(a5);


fitobj1 = sum(((a5-eegautocor).^2)); 
fitobj3= mean(fithvg);

if isnan(fitobj1)||isnan(fitobj3)
    fit1=[100,100];
else
fit1=[fitobj1,fitobj3];
end
end

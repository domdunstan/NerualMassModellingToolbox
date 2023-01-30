function [a1,a2,d2,eegz] = fitness_calc_swd(A1)
% Simulate model for SWD 
Liley_params;
fs = 255.5661;
tcut = 2; % apply for transients
TDatend = 2.3047;
T1=0:1/fs:TDatend+tcut; 
T2 = 0:1/fs:TDatend; 
T1 = T1*1000; % cnvert to ms
or=-1;


paramstoest = 1:22;
paramsinput = [paramsvec, zeros(1,10)];
paramsinput(paramstoest) = A1;
paramsinput(25) = 0;
[y,t2] = ode45_Liley(T1, paramsinput);

% interpolate to match data
y2 = interp1(t2,y(:,1),T1);

% EEG output is first row
final_eeg=y2(floor(fs*tcut):end-1);
eegz = zscore(final_eeg);
eegz = eegz*or;

vg2= fast_HVG(eegz, T2, 'w');
d2 = full(sum(vg2));

% fit spectra
[a,lags] = pwelch(eegz,[],[],1000,fs);
% limit to frequency range of data
a1=a(lags>2&lags<20);    
a1=a1/sum(a1);

a2=a(lags>2&lags<45);    
a2=a2/sum(a2);

a2 = a2(1:end-1);
end

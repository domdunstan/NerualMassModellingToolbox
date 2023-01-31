function MOEA20_Liley(M,run_number,population_size)

% Script runs the Multiobjecitve evolutionary algorithm MOEA20. See paper
% for details.

% Load data
load('Control_EEG_data.mat')
data = Control_EEG_data(M,:)-mean(Control_EEG_data(M,:));
data = zscore(data);
data = filter_b_f(data, 2, 256,'high',4);% 2 Hz high pass filter
data = zscore(data);
fhz1 = 19.965*4; % main timstep
tcut = 5000; % apply for transients
TDatend = 20000;
T1=0:1/fhz1:TDatend+tcut;
TDat = linspace(0,19.9961,5120);
paramnames= {
'he_rest' ,'hi_rest','Nee_beta','Nei_beta','Nie_beta','Nii_beta','Gamma_e',...
'Gamma_i','gamma_e','gamma_i','Tau_e','Tau_i','Se_max', 'Si_max', 'mu_e',...
'mu_i','sigma_e','sigma_i','he_eq' ,'hi_eq', 'pee','pei','pie','pii','\xi'};
paramstoest=[1:22,25];
npars_est = length(paramstoest);
Liley_params;

[dd,lags_data] = pwelch(data,[],[],[],256);
dd=dd(lags_data>2&lags_data<20);
lags_data=lags_data(lags_data>2&lags_data<20);
vg= fast_HVG(zscore(data), TDat, 'w');
d = full(sum(vg));
dd = dd/sum(dd); % normalise
eegdattot = {data, dd, tcut,lags_data,d};
% set up fitness function
ff = @(x) fitness_moea20(x, paramsvec, eegdattot, paramstoest,T1, tcut, fhz1);

npop = population_size;
lhc_Liley;
pop=p1;
scores1 = [];
% Calculate inital pop. scores
for i=1:size(pop,1)
    scores1(i,:) = ff(pop(i,:));
end
scores2=scores1;


%% set ga options
Liley_params;
options1 = optimoptions('gamultiobj','UseParallel', ...
    true,'PopulationSize', size(pop,1));%,'PlotFcn',@gaplotscorediversity);

% apply crososver function
options1.CrossoverFcn = @crossoverscattered;


options2 = options1;
% add to save output from each generation
options2.MaxTime = 60*60*8; % maximum GA time
options2.Display = 'none';
options2.InitialPopulationMatrix=pop;
options2.InitialScoresMatrix=scores2;   
options2.MaxStallGenerations = 50;
options2.MaxGenerations = 50;

[x,fval,exitflag,output,population,scores] = gamultiobj(ff, npars_est, [],[],[],[], lb(paramstoest),ub(paramstoest),[], options2);

out = {x,fval,exitflag,output,population,scores};
save(['MOEA20_subject_' num2str(M) '_' num2str(run_number) '.mat'],'out');

end
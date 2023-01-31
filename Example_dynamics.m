function Example_dynamics

% Script recreates figure 2 from the manuscript. This provides example dynamics to 2
% subjects using simulations obtained from applying the SOEA20, SOEA45,
% MOEA20 and MOEA45 to resting control EEG data.

%%

FS1 = 7; % fontsize


M1 = 13; % define subject1 to analyse
M2 = 4; % define subject2 to analyse

% Define a simulation number for each algorithm
sim1 = 1; sim2 = 1; sim3 = 1; sim4 = 1;

% Load simulation data
load('Total_Simulations_soea20.mat')
load('Total_Simulations_soea45.mat')
load('Total_Simulations_moea20.mat')
load('Total_Simulations_moea45.mat')

rng(6) % define a random number generator to reproduce same time series

%% First for subject 1

% EEG data
load('Control_EEG_data.mat')
data = Control_EEG_data(M1,:)-mean(Control_EEG_data(M1,:));
data = zscore(data);
data = filter_b_f(data, 2, 256,'high',4);% 2 Hz high pass filter
data = zscore(data);

% caluclate data PSD and HVG 
[dd,lags3] = pwelch(data,[],[],[],256);
dd1 = dd(lags3>2&lags3<20);
dd1 = dd1/sum(dd1);
lags1 = lags3(lags3>2&lags3<20);
[dd,lags4] = pwelch(data,[],[],[],256);
dd2 = dd(lags4>2&lags4<45);
dd2 = dd2/sum(dd2);
lags2 = lags4(lags4>2&lags4<45);
edges = linspace(-2,2,100);
edges2 = linspace(-5,5,100);
vg= fast_HVG(data, linspace(0,19.9961,5120), 'w');
d = full(sum(vg));

% Load parameter sets from simulation data
pop1 = Total_Simulations_soea20.population;
pop1 = squeeze(pop1(M1,sim1,:));
pop2 = Total_Simulations_soea45.population;
pop2 = squeeze(pop2(M1,sim2,:));
pop3 = Total_Simulations_moea20.population;
pop3 = squeeze(pop3(M1,sim3,:));
pop4 = Total_Simulations_moea45.population;
pop4 = squeeze(pop4(M1,sim4,:));

% simulate at these parameter sets
numreps = 5;
[~,a1,a1_2,d1,eeg1] = fitness_calc(pop1, numreps,M1);
[~,a2,a2_2,d2,eeg2] = fitness_calc(pop2, numreps,M1);
[~,a3,a3_2,d3,eeg3] = fitness_calc(pop3, numreps,M1);
[~,a4,a4_2,d4,eeg4] = fitness_calc(pop4, numreps,M1);

% approcimate hvg disitrbution from time series
hvgd=ksdensity(d,edges);
hvg1=ksdensity(d1,edges);
hvg2=ksdensity(d2,edges);
hvg3=ksdensity(d3,edges);
hvg4=ksdensity(d4,edges);

% Additionally calculate the amplitude distributions from time series
ampd=ksdensity(data,edges2);
amp1=ksdensity(eeg1,edges2);
amp2=ksdensity(eeg2,edges2);
amp3=ksdensity(eeg3,edges2);
amp4=ksdensity(eeg4,edges2);

%% Plot results
% define colors for plotting
c1 = [0 0 0]; % data
c2 = [51, 153, 255]/255; % soga20
c3 = [0/255,0/255,153/255]; % soga45
c4 = [0.6, 0, 0.6]; % moga20
c5 = [0.6350 0.0780 0.1840]; % moga45
ctot = [c5;c4;c3;c2;c1];
ctot2 = [c1;c2;c3;c4;c5];

h = figure1(19,14);
subplot = @(m,n,p) subtightplot (m, n, p, [0.07 0.04], [0.07 0.075], [0.04 0.05]);
subplot(4,4,[1,2,5,6])

% preview the plots
t1 = linspace(0,19.9961,5120);
temp1 = [eeg4' eeg3' eeg2' eeg1' data'];
h1 = offplot1(temp1(:, :), 8, t1,ctot);
xlabel('Time (s)')
box off
set(gca,'ytick', []);
set(gca,'FontSize', FS1)
set(gca,'TickDir','out');
str1={'Data','SOEA20','SOEA45','MOEA20','MOEA45'};
ylim([-3,35])
temp = [a4 a3 a2 a1 dd1];
title(['Subject ' num2str(M1)])
ylabel('Z-scored time series')


subplot(4,4,9)
h1 = offplot1(temp,0.04, lags1,ctot);
xlabel('Frequency (Hz)')
ylabel({'Normalised'; 'power'})
box off
set(gca,'Ytick', []);
box off
xlim([7,12])
set(gca,'FontSize', FS1)
set(gca,'TickDir','out');
temp = [hvgd' hvg1' hvg2' hvg3' hvg4'];
ylim([0,.34])

subplot(4,4,13)
h1=plot(edges, temp);
for i=1:5
    h1(i).Color=ctot2(i,:);
    h1(i).LineWidth=1;
end

xlabel('wHVG sum of node weights')
ylabel({'Normalised' ;'frequency'})
box off
set(gca,'FontSize', FS1)
set(gca,'Ytick', []);
set(gca,'TickDir','out');
ylim([0,max(max(temp))*1.1])

subplot(4,4,10)
set(gca,'TickDir','out');

temp3 = [a4_2 a3_2 a2_2 a1_2 dd2];
inds=1:length(lags2);
h1=[];
xt1 = [];
for i=1:5
    h1(i) = plot(lags2,log(exp(4*i)*temp3(:,i)));
    hold on
    xt1(i) = log(exp(2*i)*temp3(1,i));
end
xt1(end) = xt1(4)+abs(xt1(4)-xt1(3));
hold off
xlabel('Frequency (Hz)')
ylabel({'Normalised'; 'power'})
box off
axis tight
set(gca,'Ytick', []);

for i=1:5
    set(h1(i), 'LineWidth',1);
    set(h1(i), 'Color',ctot2(6-i, :));
    
end
box off
set(gca,'FontSize', FS1)
set(gca,'TickDir','out');
temp = [ampd' amp1' amp2' amp3' amp4'];
subplot(4,4,14)


h1=plot(edges2, temp);
for i=1:5
    h1(i).Color=ctot2(i,:);
    h1(i).LineWidth=1;
end
xlabel('Amplitude (z-scored)')
ylabel({'Normalised'; 'frequency'})
% set(gca, 'Fontsize', 12)
box off
set(gca,'FontSize', FS1)
set(gca,'Ytick', []);

set(findall(gcf,'-property','FontSize'),'FontSize',FS1)
set(gca,'TickDir','out');
ylim([0,max(max(temp))*1.1])
xlim([-4,4])






%% Then for subject 2
% Define a simulation number for each algorithm
rng(6);
sim1 = 13; sim2 = 5; sim3 = 4; sim4 = 3;

% Load EEG data
data = Control_EEG_data(M2,:)-mean(Control_EEG_data(M2,:));
data = zscore(data);
data = filter_b_f(data, 2, 256,'high',4);% 2 Hz high pass filter
data = zscore(data);

% caluclate data PSD and HVG 
[dd,lags3] = pwelch(data,[],[],[],256);
dd1 = dd(lags3>2&lags3<20);
dd1 = dd1/sum(dd1);
lags1 = lags3(lags3>2&lags3<20);
[dd,lags4] = pwelch(data,[],[],[],256);
dd2 = dd(lags4>2&lags4<45);
dd2 = dd2/sum(dd2);
lags2 = lags4(lags4>2&lags4<45);
edges = linspace(-2,2,100);
edges2 = linspace(-5,5,100);
vg= fast_HVG(data, linspace(0,19.9961,5120), 'w');
d = full(sum(vg));

% Load parameter sets from simulation data
pop1 = Total_Simulations_soea20.population;
pop1 = squeeze(pop1(M2,sim1,:));
pop2 = Total_Simulations_soea45.population;
pop2 = squeeze(pop2(M2,sim2,:));
pop3 = Total_Simulations_moea20.population;
pop3 = squeeze(pop3(M2,sim3,:));
pop4 = Total_Simulations_moea45.population;
pop4 = squeeze(pop4(M2,sim4,:));

% simulate at these parameter sets
numreps = 5;
[~,a1,a1_2,d1,eeg1] = fitness_calc(pop1, numreps,M2);
[~,a2,a2_2,d2,eeg2] = fitness_calc(pop2, numreps,M2);
[~,a3,a3_2,d3,eeg3] = fitness_calc(pop3, numreps,M2);
[~,a4,a4_2,d4,eeg4] = fitness_calc(pop4, numreps,M2);

% approcimate hvg disitrbution from time series
hvgd=ksdensity(d,edges);
hvg1=ksdensity(d1,edges);
hvg2=ksdensity(d2,edges);
hvg3=ksdensity(d3,edges);
hvg4=ksdensity(d4,edges);

% Additionally calculate the amplitude distributions from time series
ampd=ksdensity(data,edges2);
amp1=ksdensity(eeg1,edges2);
amp2=ksdensity(eeg2,edges2);
amp3=ksdensity(eeg3,edges2);
amp4=ksdensity(eeg4,edges2);

% Plot results
% define colors for plotting
c1 = [0 0 0]; % data
c2 = [51, 153, 255]/255; % soga20
c3 = [0/255,0/255,153/255]; % soga45
c4 = [0.6, 0, 0.6]; % moga20
c5 = [0.6350 0.0780 0.1840]; % moga45
ctot = [c5;c4;c3;c2;c1];
ctot2 = [c1;c2;c3;c4;c5];

subplot = @(m,n,p) subtightplot (m, n, p, [0.07 0.04], [0.07 0.075], [0.05 0.02]);
subplot(4,4,[3,4,7,8])

% preview the plots
t1 = linspace(0,19.9961,5120);
temp1 = [eeg4' eeg3' eeg2' eeg1' data'];
h1 = offplot1(temp1(:, :), 8, t1,ctot);
xlabel('Time (s)')
box off
set(gca,'ytick', []);
set(gca,'FontSize', FS1)
set(gca,'TickDir','out');
str1={'Data','SOEA20','SOEA45','MOEA20','MOEA45'};

ylabel('Z-scored time series')

h2 = legend(h1(end:-1:1), str1);
h2.NumColumns = 5;

title(['Subject ' num2str(M2)])
ylim([-3,35])
temp = [a4 a3 a2 a1 dd1];

subplot(4,4,11)
h1 = offplot1(temp,0.04, lags1,ctot);
xlabel('Frequency (Hz)')
ylabel({'Normalised'; 'power'})
box off
set(gca,'Ytick', []);
box off
xlim([7,12])
ylim([0,.28])
set(gca,'FontSize', FS1)
set(gca,'TickDir','out');
temp = [hvgd' hvg1' hvg2' hvg3' hvg4'];
subplot(4,4,15)

h1=plot(edges, temp);
for i=1:5
    h1(i).Color=ctot2(i,:);
    h1(i).LineWidth=1;
end

xlabel('wHVG sum of node weights')
ylabel({'Normalised' ;'frequency'})
box off
set(gca,'FontSize', FS1)
set(gca,'Ytick', []);
set(gca,'TickDir','out');
ylim([0,max(max(temp))*1.1])

subplot(4,4,12)
set(gca,'TickDir','out');

temp3 = [a4_2 a3_2 a2_2 a1_2 dd2];
inds=1:length(lags2);
h1=[];
xt1 = [];
for i=1:5
    h1(i) = plot(lags2,log(exp(4*i)*temp3(:,i)));
    hold on
    xt1(i) = log(exp(2*i)*temp3(1,i));
end
xt1(end) = xt1(4)+abs(xt1(4)-xt1(3));
hold off
xlabel('Frequency (Hz)')
ylabel({'Normalised'; 'power'})
box off
axis tight
set(gca,'Ytick', []);

for i=1:5
    set(h1(i), 'LineWidth',1);
    set(h1(i), 'Color',ctot2(6-i, :));
    
end
box off
set(gca,'FontSize', FS1)
set(gca,'TickDir','out');
temp = [ampd' amp1' amp2' amp3' amp4'];
subplot(4,4,16)


h1=plot(edges2, temp);
for i=1:5
    h1(i).Color=ctot2(i,:);
    h1(i).LineWidth=1;
end
xlabel('Amplitude (z-scored)')
ylabel({'Normalised'; 'frequency'})
box off
set(gca,'FontSize', FS1)
set(gca,'Ytick', []);

set(findall(gcf,'-property','FontSize'),'FontSize',FS1)
set(gca,'TickDir','out');
ylim([0,max(max(temp))*1.1])
xlim([-4,4])





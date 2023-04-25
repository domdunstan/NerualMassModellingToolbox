function Spike_wave_discharge

% Script recreates figure 12 from the manuscript. This plots an example fit
% to a spike wave discharge rhythm, recovered from applying each of the
% SOEA20, SOEA45, MOEA20 and MOEA45 to data. We note that the data segment
% contain an SWD rhythm is not loaded here. See paper for details about
% obtaining the original data.

FS1 = 7; % fontsize
% select mean from 10 repeats
sims = 10;
% Load simulation results
% moea20
load('Total_Simulations_Euclid_MOEA20_SWD.mat')
p_moea_temp = Total_Simulations_Euclid_MOEA20_SWD.population;  p_moea_temp = p_moea_temp(1:sims,:);
l1 = size(p_moea_temp,1);
p_moea20 = p_moea_temp(1,:);

% moea45
load('Total_Simulations_Euclid_MOEA45_SWD.mat')
p_moea_temp2 = Total_Simulations_Euclid_MOEA45_SWD.population; p_moea_temp2 = p_moea_temp2(1:sims,:);
l1 = size(p_moea_temp2,1);
p_moea45 = p_moea_temp2(1,:);

% soea20
load('Total_Simulations_SOEA20_SWD.mat')
p_soea_temp = Total_Simulations_SOEA20_SWD.population; p_soea_temp = p_soea_temp(1:sims,:);
l1 = size(p_soea_temp,1);
p_soea20 = p_soea_temp(1,:);


% soea45
load('Total_Simulations_SOEA45_SWD.mat')
p_soea_temp2 = Total_Simulations_SOEA45_SWD.population; p_soea_temp2 = p_soea_temp2(1:sims,:);
l1 = size(p_soea_temp2,1);
p_soea45 = p_soea_temp2(1,:);



%% simulate dynamics
% moea20
 [psd_moea20,psd_moea20_2,hvg_moea20,eeg_moea20] = fitness_calc_swd(p_moea20);
% moea45
 [psd_moea45,psd_moea45_2,hvg_moea45,eeg_moea45] = fitness_calc_swd(p_moea45);
% soea20
 [psd_soea20,psd_soea20_2,hvg_soea20,eeg_soea20] = fitness_calc_swd(p_soea20);
% soea45
 [psd_soea45,psd_soea45_2,hvg_soea45,eeg_soea45] = fitness_calc_swd(p_soea45);

colors = [[0.6350 0.0780 0.1840];[0.6,0,0.6];[0/255,0/255,153/255];[51, 153, 255]/255;[0,0,0]];
%% plot output
fs = 255.5661;
TDatend = 2.3047;
time_segment = linspace(0,TDatend,590);

h = figure1(14,10);
subplot = @(m,n,p) subtightplot (m, n, p, [0.08 0.035], [0.085 0.09], [0.05 0.02]);
subplot(2,2,1);
eeg_total = [eeg_moea45;eeg_moea20;eeg_soea20;eeg_soea45];
h1 = offplot1(eeg_total, 5, time_segment,colors);
box off
set(gca,'FontSize', FS1)
set(gca,'TickDir','out');
xlabel('Time (s)')
xlim([0,2.3])
set(gca,'TickDir','out');
set(gca,'fontsize',FS1)
set(gca,'ytick', []);
ylabel('Z-scored time series')
str1={'SOEA20','SOEA45','MOEA20','MOEA45'};

h2 = legend(h1(end:-1:1), str1);
h2.Location = 'northoutside';
h2.FontSize=7;
h2.Orientation='horizontal';
ylim([-3,18])




% psd 2-20Hz
subplot(2,2,3)
lags1 = linspace(2,19.9680,71);
psd_total = [psd_moea45,psd_moea20,psd_soea45,psd_soea20];
h1 = offplot1(psd_total, .035, lags1,colors);
box off
set(gca,'FontSize', FS1)
set(gca,'TickDir','out');
xlabel('Frequency (Hz)')
xlim([2,20])
set(gca,'TickDir','out');
set(gca,'fontsize',FS1)
set(gca,'ytick', []);
ylim([0,.18])
ylabel('Normalised power')
xticks([2,5,8,11,14,17,20])


% psd 2-45Hz
subplot(2,2,4)
lags2 = linspace(2.125,44.8,168);
psd_total2 = [psd_moea45_2,psd_moea20_2,psd_soea45_2,psd_soea20_2];

for i=1:4
    h1(i) = plot(lags2,log(exp(3*i)*psd_total2(:,i)),'color',colors(i,:),'LineWidth',1);
    hold on
    xt1(i) = log(exp(3*i)*psd_total2(1,i));
end
xt1(end) = xt1(4)+abs(xt1(4)-xt1(3));
hold off
xlabel('Frequency (Hz)')
ylabel('Normalised power')
box off
axis tight
set(gca,'Ytick', []);
set(gca,'fontsize',FS1)
set(gca,'TickDir','out');
xlim([2,45])



% hvg
subplot(2,2,2)
edges = linspace(-1.3,1.3,100);
[f_moea20,~] = ksdensity(hvg_moea20,edges,'Bandwidth',0.05);
[f_soea20,~] = ksdensity(hvg_soea20,edges,'Bandwidth',0.05);
[f_soea45,~] = ksdensity(hvg_soea45,edges,'Bandwidth',0.05);
[f_moea45,~] = ksdensity(hvg_moea45,edges,'Bandwidth',0.05);

hvg_total = [f_moea45;f_moea20;f_soea45;f_soea20];
h1 = offplot1(hvg_total, .03, edges,colors);
set(gca,'TickDir','out');
xlabel('wHVG sum of node weights')
ylabel({'Normalised frequency'})
box off
set(gca,'ytick',[])
set(gca,'yticklabels',[])
set(gca,'fontsize',FS1)
ylim([0,max(max(hvg_total))+0.1])
xlim([-1.1,1.1])


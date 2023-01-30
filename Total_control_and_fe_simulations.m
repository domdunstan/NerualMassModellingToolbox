function Total_control_and_fe_simulations

% Script recreates figure 10 from the manuscript. This compares the PSD and
% wHVG distribution from data and model simulations for control and FE
% subjects. 

% Load simulation results
FS1 = 7; % fontsize
sims = 100;
subjects = 20;


% load controls
load('Total_Simulations_moea20.mat')
psd_control_temp = Total_Simulations_moea20.psd1; 
psd_control = squeeze(mean(psd_control_temp,2));
hvg_control_temp = Total_Simulations_moea20.hvg; 

% load fe
load('Total_Simulations_moea20_fe.mat')
psd_fe_temp = Total_Simulations_moea20_fe.psd1;
psd_fe = squeeze(mean(psd_fe_temp,2));
hvg_fe_temp = Total_Simulations_moea20_fe.hvg; 

% caluclate hvg
edges = linspace(-2,2,100);
for k=1:subjects
    for i=1:sims
[hvg_control_temp2(k,i,:),~] = ksdensity(squeeze(hvg_control_temp(k,i,:)),edges,'Bandwidth',0.05);
[hvg_fe_temp2(k,i,:),~] = ksdensity(squeeze(hvg_fe_temp(k,i,:)),edges,'Bandwidth',0.05);
    end
end
hvg_control = squeeze(mean(hvg_control_temp2,2));
hvg_fe = squeeze(mean(hvg_fe_temp2,2));

%% caluclate data metrics
% control
load('EEG_data_ctl.mat')
for n=1:subjects
data = EEG_data_ctl(n,:)-mean(EEG_data_ctl(n,:));
data = zscore(data);
data = filter_b_f(data, 2, 256,'high',4);% 2 Hz high pass filter
data = zscore(data);
[dd,lags] = pwelch(data,[],[],[],256);
dd = dd(lags>2&lags<20);
psd_control_data(n,:)=dd/sum(dd);
vg= fast_HVG(data, linspace(0,19.9961,5120), 'w');
d = full(sum(vg));
[hvg_control_data(n,:),~] = ksdensity(d,edges,'Bandwidth',0.05);
end

% fe
load('FE_EEG_data.mat')
for n=1:subjects
data = FE_EEG_data(n,:)-mean(FE_EEG_data(n,:));
data = zscore(data);
data = filter_b_f(data, 2, 256,'high',4);% 2 Hz high pass filter
data = zscore(data);
[dd,lags] = pwelch(data,[],[],[],256);
lags2 = lags(lags>2&lags<20);
dd = dd(lags>2&lags<20);
psd_fe_data(n,:)=dd/sum(dd);
vg2= fast_HVG(data, linspace(0,19.9961,5120), 'w');
d2 = full(sum(vg2));
[hvg_fe_data(n,:),~] = ksdensity(d2,edges,'Bandwidth',0.05);
end








%% plot 

% plot data
h = figure1(19,10);
subplot = @(m,n,p) subtightplot (m, n, p, [0.1 0.04], [0.09 0.09], [0.07 0.02]);

s1 = subplot(2,2,1);
plot_areaerrorbar(lags2,psd_control_data,[ 52 148 186]./255,[128 193 219]./255)
hold on
plot_areaerrorbar(lags2,psd_fe_data,[236 112  22]./255,[243 169 114]./255)
hold off
xlim([2,20])
ylim([0,.085])
box off
set(gca,'TickDir','out');
% title('PSD')
xlabel('Frequency (Hz)')
% ylabel({'Dada';'';'PSD'})
ylabel('Normalised power')
set(gca,'ytick', [])
set(gca,'Yticklabels',[])
% title('                                                                                                                             Data')
set(gca,'fontsize', 7)

s2 = subplot(2,2,3);
plot_areaerrorbar(lags2,psd_control,[ 52 148 186]./255,[128 193 219]./255)
hold on
plot_areaerrorbar(lags2,psd_fe,[236 112  22]./255,[243 169 114]./255)
hold off
xlim([2,20])
ylim([0,.085])
box off
set(gca,'TickDir','out');
xlabel('Frequency (Hz)')
ylabel('Normalised power')
set(gca,'ytick', [])
set(gca,'Yticklabels',[])
set(gca,'fontsize', 7)


% plot model sims
s3 = subplot(2,2,2);
plot_areaerrorbar(edges',hvg_control_data,[ 52 148 186]./255,[128 193 219]./255)
hold on
plot_areaerrorbar(edges',hvg_fe_data,[236 112  22]./255,[243 169 114]./255)
hold off
xlim([-1.5,1.5])
ylim([0,1.4])
box off
set(gca,'TickDir','out');
% title('HVG')
xlabel('wHVG sum of node weights')
ylabel('Normalised frequency')
set(gca,'ytick', [])
set(gca,'Yticklabels',[])
set(gca,'fontsize', 7)


h1 = text(-5.1,0.5,'Data','FontSize',10,'FontWeight','bold');
set(h1,'Rotation',90);
h1 = text(-5.1,-1.65,'Model Simulation','FontSize',10,'FontWeight','bold');
set(h1,'Rotation',90);


s4 = subplot(2,2,4);
plot_areaerrorbar(edges',hvg_control,[ 52 148 186]./255,[128 193 219]./255)
hold on
plot_areaerrorbar(edges',hvg_fe,[236 112  22]./255,[243 169 114]./255)
hold off
xlim([-1.5,1.5])
ylim([0,1.4])
box off
set(gca,'TickDir','out');
xlabel('wHVG sum of node weights')
ylabel('Normalised frequency')
set(gca,'ytick', [])
set(gca,'Yticklabels',[])
set(gca,'fontsize', 7)

l1 = legend('Contol standard deviation','Control mean','Focal epilpesy standard deviation','Focal epilepsy mean');
l1.NumColumns = 4;

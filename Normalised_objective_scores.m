function Normalised_objective_scores

% Script recreates figure 4 from the manuscript. This compares the normalised
% objecitve scores obtained from all algorithms, to data. Note, pseduodata
% is used in this repository, so minor differences in values between those
% caluclated here and displayed in the manuscript may occour.

%% load all simulation data
clear

FS1 = 7; % fontsize

% Load simulations
load('Total_Simulations_moea20.mat')
load('Total_Simulations_soea20.mat')
load('Total_Simulations_soea45.mat')
load('Total_Simulations_moea45.mat')


sims = 100;
subjects = 20;

% load data
load('Control_EEG_data.mat')

%% PSD 2-20Hz
psd_moga20 = Total_Simulations_moea20.psd1;
psd_moga45 = Total_Simulations_moea45.psd1;
psd_soga20 = Total_Simulations_soea20.psd1;
psd_soga45 = Total_Simulations_soea45.psd1;
for M=1:subjects
psd_temp1 = squeeze(psd_moga20(M,:,:));
psd_temp4 = squeeze(psd_moga45(M,:,:));
psd_temp2 = squeeze(psd_soga20(M,:,:));
psd_temp3 = squeeze(psd_soga45(M,:,:));

data = Control_EEG_data(M,:)-mean(Control_EEG_data(M,:));
data = zscore(data);
data = filter_b_f(data, 2, 256,'high',4);% 2 Hz high pass filter
data = zscore(data);
[dd,lags] = pwelch(data,[],[],[],256);
dd1 = dd(lags>2&lags<20);
dd1=dd1/sum(dd1);
dd2 = dd(lags>2&lags<20);
dd2=dd2/sum(dd2);

% caluclate score
for ss=1:sims
psd20_moga20(M,ss) = sum((dd2'-psd_temp1(ss,:)).^2);
psd20_moga45(M,ss) = sum((dd2'-psd_temp4(ss,:)).^2);
psd20_soga20(M,ss) = sum((dd2'-psd_temp2(ss,:)).^2);
psd20_soga45(M,ss) = sum((dd2'-psd_temp3(ss,:)).^2);
end
end

psd20_moga20_m = median(psd20_moga20,2);
psd20_moga45_m = median(psd20_moga45,2);
psd20_soga20_m = median(psd20_soga20,2);
psd20_soga45_m = median(psd20_soga45,2);



%% PSD 2-45Hz
psd_moga20 = Total_Simulations_moea20.psd2;
psd_moga45 = Total_Simulations_moea45.psd2;
psd_soga20 = Total_Simulations_soea20.psd2;
psd_soga45 = Total_Simulations_soea45.psd2;
for M=1:subjects
psd_temp1 = squeeze(psd_moga20(M,:,:));
psd_temp4 = squeeze(psd_moga45(M,:,:));
psd_temp2 = squeeze(psd_soga20(M,:,:));
psd_temp3 = squeeze(psd_soga45(M,:,:));


data = Control_EEG_data(M,:)-mean(Control_EEG_data(M,:));
data = zscore(data);
data = filter_b_f(data, 2, 256,'high',4);% 2 Hz high pass filter
data = zscore(data);
[dd,lags] = pwelch(data,[],[],[],256);
dd1 = dd(lags>2&lags<45);
dd1=dd1/sum(dd1);
dd2 = dd(lags>2&lags<45);
dd2=dd2/sum(dd2);
lags2 = lags(lags>2&lags<45);
% convert to log log
dd3 = log(dd2);
lags3 = log(lags2);
% pre whiten
b = robustfit(lags3,dd3);
z = b(1)+lags3*b(2);
dd4 = dd3 - z;
z2 = min(dd4);
dd4 = dd4-z2;
dd4 = dd4/sum(dd4);



% caluclate score

for ss=1:sims
% apply to model sims
a_temp1 = log(psd_temp1(ss,:));
a_temp1_2 = a_temp1' - z;
a_temp1_3 = a_temp1_2-z2;
a_temp1_3 = a_temp1_3/sum(a_temp1_3);

a_temp2 = log(psd_temp2(ss,:));
a_temp2_2 = a_temp2' - z;
a_temp2_3 = a_temp2_2-z2;
a_temp2_3 = a_temp2_3/sum(a_temp2_3);

a_temp3 = log(psd_temp3(ss,:));
a_temp3_2 = a_temp3' - z;
a_temp3_3 = a_temp3_2-z2;
a_temp3_3 = a_temp3_3/sum(a_temp3_3);

a_temp4 = log(psd_temp4(ss,:));
a_temp4_2 = a_temp4' - z;
a_temp4_3 = a_temp4_2-z2;
a_temp4_3 = a_temp4_3/sum(a_temp4_3);

psd45_moga20(M,ss) = sum((dd4-a_temp1_3).^2);
psd45_moga45(M,ss) = sum((dd4-a_temp4_3).^2);
psd45_soga20(M,ss) = sum((dd4-a_temp2_3).^2);
psd45_soga45(M,ss) = sum((dd4-a_temp3_3).^2);

end
end

psd45_moga20_m = median(psd45_moga20,2);
psd45_moga45_m = median(psd45_moga45,2);
psd45_soga20_m = median(psd45_soga20,2);
psd45_soga45_m = median(psd45_soga45,2);



%% HVG
hvg_moga20 = Total_Simulations_moea20.Scores;
hvg_moga45 = Total_Simulations_moea45.Scores;
hvg_soga20 = Total_Simulations_soea20.Scores;
hvg_soga45 = Total_Simulations_soea45.Scores;
hvg_moga20 = squeeze(hvg_moga20(:,:,2));
hvg_moga45 = squeeze(hvg_moga45(:,:,2));
hvg_soga20 = squeeze(hvg_soga20(:,:,2));
hvg_soga45 = squeeze(hvg_soga45(:,:,2));
hvg_moga20_m = median(hvg_moga20,2);
hvg_moga45_m = median(hvg_moga45,2);
hvg_soga20_m = median(hvg_soga20,2);
hvg_soga45_m = median(hvg_soga45,2);


%% caluclate differences

hvg_moga_total = median(hvg_moga20');
hvg_moga45_total = median(hvg_moga45');
hvg_soga_total = median(hvg_soga20');
hvg_soga45_total = median(hvg_soga45');
psd_moga_total = median(psd20_moga20');
psd_moga45_total = median(psd20_moga45');
psd_soga_total = median(psd20_soga20');
psd_soga45_total = median(psd20_soga45');
psd45_moga_total = median(psd45_moga20');
psd45_moga45_total = median(psd45_moga45');
psd45_soga_total = median(psd45_soga20');
psd45_soga45_total = median(psd45_soga45');



% convert to [0,1] scale
m1 = max([hvg_moga_total,hvg_moga45_total,hvg_soga_total,hvg_soga45_total]);
m2 = max([psd_moga_total,psd_moga45_total,psd_soga_total,psd_soga45_total ]);
m3 = max([psd45_moga_total,psd45_moga45_total,psd45_soga_total,psd45_soga45_total ]);

n1 = min([hvg_moga_total,hvg_moga45_total,hvg_soga_total,hvg_soga45_total]);
n2 = min([psd_moga_total,psd_moga45_total,psd_soga_total,psd_soga45_total]);
n3 = min([psd45_moga_total,psd45_moga45_total,psd45_soga_total,psd45_soga45_total]);

hvg_moga = (hvg_moga_total - n1)/(m1-n1);
hvg_moga45 = (hvg_moga45_total - n1)/(m1-n1);
hvg_soga = (hvg_soga_total - n1)/(m1-n1);
hvg_soga45 = (hvg_soga45_total - n1)/(m1-n1);

psd_moga = (psd_moga_total - n2)/(m2-n2);
psd_moga45 = (psd_moga45_total - n2)/(m2-n2);
psd_soga = (psd_soga_total - n2)/(m2-n2);
psd_soga45 = (psd_soga45_total - n2)/(m2-n2);

psdHF_moga = (psd45_moga_total - n3)/(m3-n3);
psdHF_moga45 = (psd45_moga45_total - n3)/(m3-n3);
psdHF_soga = (psd45_soga_total - n3)/(m3-n3);
psdHF_soga45 = (psd45_soga45_total - n3)/(m3-n3);



%% plot differences from MOEA20
h = figure1(19,6);
subplot = @(m,n,p) subtightplot (m, n, p, [0.075 0.08], [0.1 0.075], [0.05 -0.05]);

diff1 = hvg_moga-hvg_soga;
diff2 = hvg_moga-hvg_soga45;
diff3 = hvg_moga-hvg_moga45;
colors = [[51, 153, 255]/255;[0/255,0/255,153/255];[0.6350 0.0780 0.1840]];

subplot(1,3,1)
v1 = violinplot([diff1;diff2;diff3]');
v1(1).ViolinColor = {colors(1,:)};
v1(2).ViolinColor = {colors(2,:)};
v1(3).ViolinColor = {colors(3,:)};
xticks([1,2,3])
xticklabels({'SOEA20','SOEA45','MOEA45'})
ylabel('Normalised difference in medians')
box off
set(gca,'TickDir','out');
ylim([-1,1])
yline(0,'-','MOEA20                                                ','Color',[0.6,0,0.6], 'LineWidth',2,'FontSize',FS1)
title('wHVG')
xtickangle(0)
set(gca,'FontSize', FS1)


diff4 = psd_moga-psd_soga;
diff5 = psd_moga-psd_soga45;
diff6 = psd_moga-psd_moga45;

s2 = subplot(1,3,2);
v2 = violinplot([diff4;diff5;diff6]');
v2(1).ViolinColor = {colors(1,:)};
v2(2).ViolinColor = {colors(2,:)};
v2(3).ViolinColor = {colors(3,:)};
xticks([1,2,3])
xticklabels({'SOEA20','SOEA45','MOEA45'})
box off
set(gca,'TickDir','out');
ylim([-1,1])
yline(0,'-','MOEA20','Color',[0.6,0,0.6], 'LineWidth',2,'FontSize',FS1)
title('PSD (2-20Hz)')
xtickangle(0)
set(gca,'FontSize', FS1)


diff7 = psdHF_moga-psdHF_soga;
diff8 = psdHF_moga-psdHF_soga45;
diff9 = psdHF_moga45-psdHF_soga45;

s3 = subplot(1,3,3);
v3=violinplot([diff7;diff8;diff9]');
v3(1).ViolinColor = {colors(1,:)};
v3(2).ViolinColor = {colors(2,:)};
v3(3).ViolinColor = {colors(3,:)};
xticks([1,2,3])
xticklabels({'SOEA20','SOEA45','MOEA45'})
box off
set(gca,'TickDir','out');
ylim([-1,1])
yline(0,'-','MOEA20                                                ','Color',[0.6,0,0.6], 'LineWidth',2,'FontSize',FS1)
title('Log-transformed PSD (2-45Hz)')
xtickangle(0)
set(gca,'FontSize', FS1)



% adjust postion of subplots
s2.Position(1) = s2.Position(1)-0.03;
s3.Position(1) = s3.Position(1)-0.06;









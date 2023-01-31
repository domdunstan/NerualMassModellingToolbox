function Investigating_model_simulation_waveforms

% Script recreates Figure 3 from the manuscript. This compares the wHVG from a
% segment of model time series obtained using each optimisation method. We note, pseduo data is
% applied for this script, and hence small devations from the data
% in the paper will be apparent.


% Define a sim with nonlinear dynamics
sim1 = 1; sim2 = 1; sim3 = 1; sim4 = 1;

% define color
c1 = [0 0 0]; % data
c2 = [51, 153, 255]/255; % soga20
c3 = [0/255,0/255,153/255]; % soga45
c4 = [0.6, 0, 0.6]; % moga20
c5 = [0.6350 0.0780 0.1840]; % moga45
ctot = [c5;c4;c3;c2;c1];
ctot2 = [c1;c2;c3;c4;c5];
FS1 = 7; % fontsize


% Load simulation data
load('Total_Simulations_soea20.mat')
load('Total_Simulations_soea45.mat')
load('Total_Simulations_moea20.mat')
load('Total_Simulations_moea45.mat')


M=13; 
edges = linspace(-2,2,100);
edges2 = linspace(-5,5,100);


% Load EEG data
load('Control_EEG_data.mat')
data = Control_EEG_data(M,:)-mean(Control_EEG_data(M,:));
data = zscore(data);
data = filter_b_f(data, 2, 256,'high',4);% 2 Hz high pass filter
data = zscore(data);

[dd,lags3] = pwelch(data,[],[],[],256);
dd1 = dd(lags3>2&lags3<20);
dd1 = dd1/sum(dd1);
lags1 = lags3(lags3>2&lags3<20);


[dd,lags4] = pwelch(data,[],[],[],256);
dd2 = dd(lags4>2&lags4<45);
dd2 = dd2/sum(dd2);
lags2 = lags4(lags4>2&lags4<45);


vg= fast_HVG(data, linspace(0,19.9961,5120), 'w');
d = full(sum(vg));
f_data=ksdensity(d,edges);


% Load parameter sets from simulation data
pop1 = Total_Simulations_soea20.population;
pop1 = squeeze(pop1(M,sim1,:));
pop2 = Total_Simulations_soea45.population;
pop2 = squeeze(pop2(M,sim2,:));
pop3 = Total_Simulations_moea20.population;
pop3 = squeeze(pop3(M,sim3,:));
pop4 = Total_Simulations_moea45.population;
pop4 = squeeze(pop4(M,sim4,:));

% simulate at these parameter sets
numreps = 5;
rng(2); % set random number generator for fixed results
[fit1,a1,a1_2,d1,eeg1] = fitness_calc(pop1, numreps,M);
[fit2,a2,a2_2,d2,eeg2] = fitness_calc(pop2, numreps,M);
[fit3,a3,a3_2,d3,eeg3] = fitness_calc(pop3, numreps,M);
[fit4,a4,a4_2,d4,eeg4] = fitness_calc(pop4, numreps,M);


%% plot
h = figure1(19,15);
subplot = @(m,n,p) subtightplot (m, n, p, [0.0075 0.05], [0.065 0.05], [0.08 0.01]);

% define time intervals
t1 = linspace(0,19.9961,5120);
start = 11.2;
stop = 12.7;
ind = t1>start & t1<stop;
t2 = t1(ind);
% calculate hvg across segments
vgd = fast_HVG(zscore(data(ind)), t2, 'w');
vg1 = fast_HVG(zscore(eeg1(ind)), t2, 'w');
vg2 = fast_HVG(zscore(eeg2(ind)), t2, 'w');
vg3 = fast_HVG(zscore(eeg3(ind)), t2, 'w');
vg4 = fast_HVG(zscore(eeg4(ind)), t2, 'w');
d = full(sum(vgd));
d1 = full(sum(vg1));
d2 = full(sum(vg2));
d3 = full(sum(vg3));
d4 = full(sum(vg4));


hvgd=ksdensity(d,edges);
hvg1=ksdensity(d1,edges);
hvg2=ksdensity(d2,edges);
hvg3=ksdensity(d3,edges);
hvg4=ksdensity(d4,edges);

hvgdh = histcounts(d, edges, 'normalization', 'pdf');
hvg1h = histcounts(d1, edges, 'normalization', 'pdf');
hvg2h = histcounts(d2, edges, 'normalization', 'pdf');
hvg3h = histcounts(d3, edges, 'normalization', 'pdf');
hvg4h = histcounts(d4, edges, 'normalization', 'pdf');

% calculate the amplitude distributions across segments
ampd=ksdensity(data,edges2);
amp1=ksdensity(eeg1,edges2);
amp2=ksdensity(eeg2,edges2);
amp3=ksdensity(eeg3,edges2);
amp4=ksdensity(eeg4,edges2);

% plot
subplot(7,2,[1 3 5 7 9])
temp1 = [eeg4' eeg3' eeg2' eeg1' data'];
h1 = offplot1(zscore(temp1(ind, :)), 4.8, t2,ctot);
xlabel('Time (s)')
ylabel('Z-scored time series')

box off
set(gca,'FontSize', FS1)
yticks(0:4:5*4)
set(gca,'ytick', [])
set(gca,'TickDir','out');
xlim([start,stop])
ylim([-2,21.5])
str1={'Data','SOEA20','SOEA45','MOEA20','MOEA45'};
h2 = legend(h1(end:-1:1), str1);
h2.FontSize=FS1;
h2.Orientation='horizontal';


temp = [hvgd' hvg1' hvg2' hvg3' hvg4'];
temph = [hvgdh' hvg1h' hvg2h' hvg3h' hvg4h'];
ymax = max(max(temph));
tempinds = [2 4 6 8 10];
for i=1:5
    subplot(7,2,tempinds(i))
    b1 = bar(edges(1:end-1), temph(:,i));    
    b1.FaceColor=ctot2(i,:);
    b1.EdgeColor=ctot2(i,:);
set(gca,'ytick', [])
set(gca,'Fontsize', FS1)
box off
ylim([0 ymax])
set(gca,'TickDir','out');
ylabel({'Normalised';'frequency'},'FontSize',FS1)
if i<5
    set(gca,'xtick', [])
end
end
xlabel('wHVG sum of node weights')

% plot
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.02], [0.065 0.16], [0.08 0.01]);
subplot(7,2,11:14)

eegda = data(ind);
map= vals2colormap(d, 'hot', [-1 1]);
for i=1:length(eegda)
    h1 = plot(t2(i),eegda(i), 'o');
h1.MarkerSize=5;
    h1.MarkerFaceColor = map(i,:);
    h1.Color = map(i,:);
    hold on
end
set(gca,'TickDir','out');
eeg2a=eeg2(ind);
map= vals2colormap(d2, 'hot', [-1 1]);
for i=1:length(eeg2a)
    h1 = plot(t2(i),eeg2a(i)-6, 'o');
h1.MarkerSize=5;
    h1.MarkerFaceColor = map(i,:);
    h1.Color = map(i,:);
    hold on
end
box off
eeg3a=eeg3(ind);
map= vals2colormap(d3, 'hot', [-1 1]);
for i=1:length(eeg3a)
    h1 = plot(t2(i),eeg3a(i)-12, 'o');
h1.MarkerSize=5;
    h1.MarkerFaceColor = map(i,:);
    h1.Color = map(i,:);
    hold on
end

% Create Colorbar
cmap = colormap('hot') ; %Create Colormap
cbh = colorbar ; 
cbh.Ticks = 0:0.2:1; 
cbh.TickLabels = {'-1';'-0.6';'-0.2';'0.2';'0.6';'1'} ; 
hold off
axis tight
yticks([-12,-6,0])
set(gca,'yticklabel', {'MOEA20','SOEA45','Data'})

set(gca,'FontSize', FS1)
xlabel('Time (s)')
box off

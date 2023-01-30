function Example_recovered_parameters

% Script recreates figure 5 from the manuscript. This provides an example of the recovered parameters to 2
% subjects using simulations obtained from applying the SOEA20, SOEA45,
% MOEA20 and MOEA45. 

FS1 = 7; % fontsize

% Load simulations
load('Total_Simulations_moea20.mat')
load('Total_Simulations_moea45.mat')
load('Total_Simulations_soea20.mat')
load('Total_Simulations_soea45.mat')


paramnames= {
'h_{e}^{rest}' ,'h_{i}^{rest}','N_{ee}^{\beta}','N_{ei}^{\beta}','N_{ie}^{\beta}','N_{ii}^{\beta}','\Gamma_e',...
'\Gamma_i','\gamma_e','\gamma_i','\tau_{e}','\tau_i','S_{e}^{max}', 'S_{i}^{max}', '\mu_e',...
'\mu_i','\sigma_e','\sigma_i','h_{e}^{eq}' ,'h_{i}^{eq}', 'p_{ee}','p_{ei}','p_{ie}','p_{ii}','\xi'};

simulations = 100;

% define subjects to plot
M1 = 13;
M2 =  4;


%% FIRST FOR SUBJECT M1

% load all simulations
% moea20
p_moga_e = Total_Simulations_moea20.population;
p_moga_e = squeeze(p_moga_e(M1,1:simulations,1:23));

% soea20
p_soga =  Total_Simulations_soea20.population;
p_soga = squeeze(p_soga(M1,1:simulations,1:23));

% soea45
p_soga_45 =  Total_Simulations_soea45.population;
p_soga_45 = squeeze(p_soga_45(M1,1:simulations,1:23));

% moea45
p_moga_45 =  Total_Simulations_moea45.population;
p_moga_45 = squeeze(p_moga_45(M1,1:simulations,1:23));

total_params = [p_soga;p_soga_45;p_moga_e;p_moga_45];
% normalise parameter matrix
Liley_params;
width = ub([1:22,25])-lb([1:22,25]);
total_params2 = (total_params-lb([1:22,25]))./width;


%% First sillhoutte scores from total space

% caluclate silhouette directly from known labels
% soea20 v soea45
X1_full = [total_params2(1:simulations,:);total_params2(simulations+1:2*simulations,:)];
clust1 = [ones(1,simulations),2*ones(1,simulations)];
% soea20 v moea20
X2_full  = [total_params2(1:simulations,:);total_params2(2*simulations+1:3*simulations,:)];
clust2 = [ones(1,simulations),2*ones(1,simulations)];
% soea45 v moea20
X3_full  = [total_params2(simulations+1:2*simulations,:);total_params2(2*simulations+1:3*simulations,:)];
clust3 = [ones(1,simulations),2*ones(1,simulations)];
% moea20 v moea45
X4_full  = [total_params2(3*simulations+1:4*simulations,:);total_params2(2*simulations+1:3*simulations,:)];
clust4= [ones(1,simulations),2*ones(1,simulations)];

s1_full = abs(mean(silhouette(X1_full,clust1)));
s2_full = abs(mean(silhouette(X2_full,clust2)));
s3_full = abs(mean(silhouette(X3_full,clust3)));
s4_full = abs(mean(silhouette(X4_full,clust4)));




%% next use MDS to caluclate sillhoute from 2d space

% calculate distance matrix
s1 = size(total_params2,1);
for j=1:s1
    for i=1:s1
        p1=total_params2(j,:);
        p2=total_params2(i,:);
D(j,i)=pdist2(p1,p2,'euclidean');

    end
end

% Multi dimensional scaling 2d
[Y,e] = cmdscale(D,2) ;


% caluclate silhouette directly from known labels
% soea20 v soea45
X1 = [Y(1:simulations,:);Y(simulations+1:2*simulations,:)];
clust1 = [ones(1,simulations),2*ones(1,simulations)];
% soea20 v moea20
X2 = [Y(1:simulations,:);Y(2*simulations+1:3*simulations,:)];
clust2 = [ones(1,simulations),2*ones(1,simulations)];
% soea45 v moea20
X3 = [Y(simulations+1:2*simulations,:);Y(2*simulations+1:3*simulations,:)];
clust3 = [ones(1,simulations),2*ones(1,simulations)];
% moea20 v moea45
X4 = [Y(3*simulations+1:4*simulations,:);Y(2*simulations+1:3*simulations,:)];
clust4 = [ones(1,simulations),2*ones(1,simulations)];

s1 = abs(mean(silhouette(X1,clust1)));
s2 = abs(mean(silhouette(X2,clust2)));
s3 = abs(mean(silhouette(X3,clust3)));
s4 = abs(mean(silhouette(X4,clust4)));




%% plot

% define colors
c1 = [0 0 0]; % data
c2 = [51, 153, 255]/255; % soea20
c3 = [0/255,0/255,153/255]; % soea45
c4 = [0.6, 0, 0.6]; % moea20
c5 = [0.6350 0.0780 0.1840]; % moea45
ctot = [c1;c2;c3;c4;c5];
figure1(19,15)
subplot = @(m,n,p) subtightplot (m, n, p, [0.035 0.025], [0.08 0.1], [0.04 0.06]);


total_params1 = {p_soga;p_soga_45;p_moga_e;p_moga_45};
paramvec = [9 10 17];
nbins = 20;
titlevec = {'SOEA20', 'SOEA45', 'MOEA20', 'MOEA45'};
for j = 1:length(paramvec)
    param1=paramvec(j);
        for i=1:4

    edges = linspace(lb(param1),ub(param1),nbins);
    width = edges(2)-edges(1);
    temp = total_params1{i};
    temp1 = histcounts(temp(:,param1), edges,'normalization', 'pdf');
    subplot(5,8,i+(j-1)*8)
    b11 = bar(edges(1:end-1), temp1);
    b11.FaceColor=ctot(i+1,:);
    b11.EdgeColor=ctot(i+1,:);
    ylim([0,max(temp1)])
    set(gca,'fontsize', 7)
    set(gca,'ytick',[])
xticks([lb(paramvec(j)),ub(paramvec(j))])
    box off
    xlim([lb(param1)-width/2,ub(param1)])

set(gca,'TickDir','out');
if j==1; title(sprintf(titlevec{i}),'FontWeight','Normal'); end
if i==1; ylabel({'Normalised';'Frequency'}); end
xlabel(paramnames(paramvec(j)))
    xh = get(gca,'xlabel');
p = get(xh,'position');
p(2) = p(2)/10 ;                    
set(xh,'position',p);
if j==2&&i==2
    title({['                               Subject ' num2str(M1)];'';'';'';'';'';'';'';'';''})
end
    end
end
ms=20;

subplot = @(m,n,p) subtightplot (m, n, p, [0.045 0.015], [0.035 0.1], [0.038 0.07]);

% soea20 v soea45
subplot(5,8,25:26)
p1 = plot(Y(1:simulations,1),Y(1:simulations,2), '.', 'markersize', ms); 
p1.Color=ctot(2,:);
hold on
p1=plot(Y(simulations+1:2*simulations,1),Y(simulations+1:2*simulations,2), '.', 'markersize', ms);
p1.Color=ctot(3,:);
hold off
set(gca,'fontsize', 7)
set(gca,'xtick', [])
set(gca,'ytick', [])
title([sprintf('s=%.2f', s1),sprintf(' (s_{full}=%.2f', s1_full),')'])
ylabel('Component 2')
box off
set(gca,'TickDir','out');
xlim([-1,1.3])
ylim([-1,1.3])


%soea20 v moea20
subplot(5,8,27:28)
p1=plot(Y(1:simulations,1),Y(1:simulations,2), '.k', 'markersize', ms); % soga20
p1.Color=ctot(2,:);
hold on
p1=plot(Y(simulations*2+1:3*simulations,1),Y(simulations*2+1:3*simulations,2), '.r', 'markersize', ms);
p1.Color=ctot(4,:);
hold off
set(gca,'fontsize', 7)
set(gca,'xtick', [])
set(gca,'ytick', [])
title([sprintf('s=%.2f', s2),sprintf(' (s_{full}=%.2f', s2_full),')'])
box off
set(gca,'TickDir','out');
xlim([-1,1.3])
ylim([-1,1.3])

% soea45 v moea20
subplot(5,8,33:34)
p1=plot(Y(simulations+1:2*simulations,1),Y(simulations+1:2*simulations,2), '.', 'markersize', ms);
p1.Color=ctot(3,:);
hold on
p1=plot(Y(simulations*2+1:3*simulations,1),Y(simulations*2+1:3*simulations,2), '.r', 'markersize', ms);
p1.Color=ctot(4,:);
hold off
set(gca,'fontsize', 7)
set(gca,'xtick', [])
set(gca,'ytick', [])
title([sprintf('s=%.2f', s3),sprintf(' (s_{full}=%.2f', s3_full),')'])
ylabel('Component 2')
box off
set(gca,'TickDir','out');
xlim([-1,1])
ylim([-1,1])
ylabel('Component 2')
xlabel('Component 1')

% moea20 v moea45
subplot(5,8,35:36)
p1=plot(Y(simulations*3+1:end,1),Y(3*simulations+1:end,2), '.k', 'markersize', ms); % soga20
p1.Color=ctot(5,:);
hold on
p1=plot(Y(simulations*2+1:simulations*3,1),Y(simulations*2+1:simulations*3,2), '.r', 'markersize', ms);
p1.Color=ctot(4,:);
hold off
set(gca,'fontsize', 7)
set(gca,'xtick', [])
set(gca,'ytick', [])
title([sprintf('s=%.2f', s4),sprintf(' (s_{full}=%.2f', s4_full),')'])

box off
set(gca,'TickDir','out');
xlim([-1,1.3])
ylim([-1,1.3])
xlabel('Component 1')











%% Then for subject M2

% load all simulations
% moea20
p_moga_e = Total_Simulations_moea20.population;
p_moga_e = squeeze(p_moga_e(M2,1:simulations,1:23));

% soea20
p_soga =  Total_Simulations_soea20.population;
p_soga = squeeze(p_soga(M2,1:simulations,1:23));

% soea45
p_soga_45 =  Total_Simulations_soea45.population;
p_soga_45 = squeeze(p_soga_45(M2,1:simulations,1:23));

% moea45
p_moga_45 =  Total_Simulations_moea45.population;
p_moga_45 = squeeze(p_moga_45(M2,1:simulations,1:23));

total_params = [p_soga;p_soga_45;p_moga_e;p_moga_45];
% normalise parameter matrix
Liley_params;
width = ub([1:22,25])-lb([1:22,25]);
total_params2 = (total_params-lb([1:22,25]))./width;


%% First sillhoutte scores from total space

% caluclate silhouette directly from known labels
% soga20 v soga45
X1_full = [total_params2(1:simulations,:);total_params2(simulations+1:2*simulations,:)];
clust1 = [ones(1,simulations),2*ones(1,simulations)];
% soga20 v moga20
X2_full  = [total_params2(1:simulations,:);total_params2(2*simulations+1:3*simulations,:)];
clust2 = [ones(1,simulations),2*ones(1,simulations)];
% soga45 v moga20
X3_full  = [total_params2(simulations+1:2*simulations,:);total_params2(2*simulations+1:3*simulations,:)];
clust3 = [ones(1,simulations),2*ones(1,simulations)];
% moga20 v moga45
X4_full  = [total_params2(3*simulations+1:4*simulations,:);total_params2(2*simulations+1:3*simulations,:)];
clust4= [ones(1,simulations),2*ones(1,simulations)];

s1_full = abs(mean(silhouette(X1_full,clust1)));
s2_full = abs(mean(silhouette(X2_full,clust2)));
s3_full = abs(mean(silhouette(X3_full,clust3)));
s4_full = abs(mean(silhouette(X4_full,clust4)));




%% next use MDS to caluclate sillhoute from 2d space

% calculate distance matrix
s1 = size(total_params2,1);
for j=1:s1
    for i=1:s1
        p1=total_params2(j,:);
        p2=total_params2(i,:);
D(j,i)=pdist2(p1,p2,'euclidean');

    end
end

% Multi dimensional scaling 2d
[Y,e] = cmdscale(D,2) ;

% caluclate silhouette directly from known labels
% soea20 v soea45
X1 = [Y(1:simulations,:);Y(simulations+1:2*simulations,:)];
clust1 = [ones(1,simulations),2*ones(1,simulations)];
% soea20 v moea20
X2 = [Y(1:simulations,:);Y(2*simulations+1:3*simulations,:)];
clust2 = [ones(1,simulations),2*ones(1,simulations)];
% soea45 v moea20
X3 = [Y(simulations+1:2*simulations,:);Y(2*simulations+1:3*simulations,:)];
clust3 = [ones(1,simulations),2*ones(1,simulations)];
% moea20 v moea45
X4 = [Y(3*simulations+1:4*simulations,:);Y(2*simulations+1:3*simulations,:)];
clust4 = [ones(1,simulations),2*ones(1,simulations)];

s1 = abs(mean(silhouette(X1,clust1)));
s2 = abs(mean(silhouette(X2,clust2)));
s3 = abs(mean(silhouette(X3,clust3)));
s4 = abs(mean(silhouette(X4,clust4)));




%% plot

subplot = @(m,n,p) subtightplot (m, n, p, [0.035 0.025], [0.08 0.1], [0.08 0.015]);

total_params1 = {p_soga;p_soga_45;p_moga_e;p_moga_45};
paramvec = [9 10 17];
nbins = 20;
titlevec = {'SOEA20', 'SOEA45', 'MOEA20', 'MOEA45'};
for j = 1:length(paramvec)
    param1=paramvec(j);
        for i=1:4

    edges = linspace(lb(param1),ub(param1),nbins);
    width = edges(2)-edges(1);
    temp = total_params1{i};
    temp1 = histcounts(temp(:,param1), edges,'normalization', 'pdf');
    subplot(5,8,4+i+(j-1)*8)
    b11 = bar(edges(1:end-1), temp1);
    b11.FaceColor=ctot(i+1,:);
    b11.EdgeColor=ctot(i+1,:);
    ylim([0,max(temp1)])
    set(gca,'fontsize', 7)
    set(gca,'ytick',[])
xticks([lb(paramvec(j)),ub(paramvec(j))])
    box off
    xlim([lb(param1)-width/2,ub(param1)])

set(gca,'TickDir','out');
if j==1; title(sprintf(titlevec{i}),'FontWeight','Normal'); end
if i==1; ylabel({'Normalised';'Frequency'}); end

xlabel(paramnames(paramvec(j)))
    xh = get(gca,'xlabel');
p = get(xh,'position');
p(2) = p(2)/10 ;                    
set(xh,'position',p);
if j==2&&i==2
    title({['                               Subject ' num2str(M2)];'';'';'';'';'';'';'';'';''})
end
    end
end
 % add for legend purposes only
hold on
bar(nan, nan,'Facecolor',ctot(2,:))
bar(nan, nan,'Facecolor',ctot(3,:))
bar(nan, nan,'Facecolor',ctot(4,:))
bar(nan, nan,'Facecolor',ctot(5,:))
hold off
l1 = legend('','SOEA20', 'SOEA45', 'MOEA20', 'MOEA45');
l1.NumColumns=4;
ms=20;
% add in the clustering: 
subplot = @(m,n,p) subtightplot (m, n, p, [0.045 0.015], [0.035 0.1], [0.09 0.016]);

% soea20 v soea45
subplot(5,8,29:30)
p1 = plot(Y(1:simulations,1),Y(1:simulations,2), '.', 'markersize', ms); 
p1.Color=ctot(2,:);
hold on
p1=plot(Y(simulations+1:2*simulations,1),Y(simulations+1:2*simulations,2), '.', 'markersize', ms);
p1.Color=ctot(3,:);
hold off
set(gca,'fontsize', 7)
set(gca,'xtick', [])
set(gca,'ytick', [])
title([sprintf('s=%.2f', s1),sprintf(' (s_{full}=%.2f', s1_full),')'])
ylabel('Component 2')
box off
set(gca,'TickDir','out');
xlim([-1,1.3])
ylim([-1,1.3])


%soea20 v moea20
subplot(5,8,31:32)
p1=plot(Y(1:simulations,1),Y(1:simulations,2), '.k', 'markersize', ms); % soga20
p1.Color=ctot(2,:);
hold on
p1=plot(Y(simulations*2+1:3*simulations,1),Y(simulations*2+1:3*simulations,2), '.r', 'markersize', ms);
p1.Color=ctot(4,:);
hold off
set(gca,'fontsize', 7)
set(gca,'xtick', [])
set(gca,'ytick', [])
title([sprintf('s=%.2f', s2),sprintf(' (s_{full}=%.2f', s2_full),')'])
box off
set(gca,'TickDir','out');
xlim([-1,1.3])
ylim([-1,1.3])

% soea45 v moea20
subplot(5,8,37:38)
p1=plot(Y(simulations+1:2*simulations,1),Y(simulations+1:2*simulations,2), '.', 'markersize', ms);
p1.Color=ctot(3,:);
hold on
p1=plot(Y(simulations*2+1:3*simulations,1),Y(simulations*2+1:3*simulations,2), '.r', 'markersize', ms);
p1.Color=ctot(4,:);
hold off
set(gca,'fontsize', 7)
set(gca,'xtick', [])
set(gca,'ytick', [])
title([sprintf('s=%.2f', s3),sprintf(' (s_{full}=%.2f', s3_full),')'])
ylabel('Component 2')
box off
set(gca,'TickDir','out');
xlim([-1,1])
ylim([-1,1])
ylabel('Component 2')
xlabel('Component 1')

% moea45 v moea20
subplot(5,8,39:40)
p1=plot(Y(simulations*3+1:end,1),Y(3*simulations+1:end,2), '.k', 'markersize', ms); % soga20
p1.Color=ctot(5,:);
hold on
p1=plot(Y(simulations*2+1:simulations*3,1),Y(simulations*2+1:simulations*3,2), '.r', 'markersize', ms);
p1.Color=ctot(4,:);
hold off
set(gca,'fontsize', 7)
set(gca,'xtick', [])
set(gca,'ytick', [])
title([sprintf('s=%.2f', s4),sprintf(' (s_{full}=%.2f', s4_full),')'])

box off
set(gca,'TickDir','out');
xlim([-1,1.3])
ylim([-1,1.3])
xlabel('Component 1')








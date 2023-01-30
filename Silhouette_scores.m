function Silhouette_scores

% Script recreates figure 6 from the manuscript. This compared the silhouette scores between parameter distributions recovered
% from applying the SOEA20, SOEA45,MOEA20 and MOEA45 methods.

FS1 = 7; % fontsize
subjects = 20;
simulations = 100;
% load simulation results
load('Total_Simulations_moea20.mat')
load('Total_Simulations_soea20.mat')
load('Total_Simulations_soea45.mat')
load('Total_Simulations_moea45.mat')


p_moga_e = Total_Simulations_moea20.population;
p_soga =  Total_Simulations_soea20.population;
p_soga_45 =  Total_Simulations_soea45.population;
p_moga_e45 =Total_Simulations_moea45.population;

for subject=1:subjects
% moea20
p_moga_e_temp = squeeze(p_moga_e(subject,1:simulations,1:23));
% soea20
p_soga_temp = squeeze(p_soga(subject,1:simulations,1:23));
% soea45
p_soga_45_temp = squeeze(p_soga_45(subject,1:simulations,1:23));
% moea45
p_moga_e45_temp = squeeze(p_moga_e45(subject,1:simulations,1:23));

total_params = [p_soga_temp;p_soga_45_temp;p_moga_e_temp;p_moga_e45_temp];
% normalise parameter matrix
Liley_params;
width = ub([1:22,25])-lb([1:22,25]);
total_params2 = (total_params-lb([1:22,25]))./width;

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
m1 = simulations;
% caluclate silhouette directly from known labels
% soga20 v soga45
X1 = [Y(1:m1,:);Y(m1+1:2*m1,:)];
clust1 = [ones(1,m1),2*ones(1,m1)];
% soga20 v moga20
X2 = [Y(1:m1,:);Y(2*m1+1:3*m1,:)];
clust2 = [ones(1,m1),2*ones(1,m1)];
% soga45 v moga20
X3 = [Y(m1+1:2*m1,:);Y(2*m1+1:3*m1,:)];
clust3 = [ones(1,m1),2*ones(1,m1)];
% moga20 v moga45
X4 = [Y(2*m1+1:3*m1,:);Y(3*m1+1:end,:)];
clust4 = [ones(1,m1),2*ones(1,m1)];


s1 = abs(mean(silhouette(X1,clust1)));
s2 = abs(mean(silhouette(X2,clust2)));
s3 = abs(mean(silhouette(X3,clust3)));
s4 = abs(mean(silhouette(X4,clust4)));


sil1(subject) = s1;
sil2(subject) = s2;
sil3(subject) = s3;
sil4(subject) = s4;
subject
end

%% plot results
h = figure1(19,8);
subplot = @(m,n,p) subtightplot (m, n, p, [0.12 0.03], [0.13 0.08], [0.075 0.02]);
sil_total = [sil1;sil2;sil3;sil4];

titles = {'SOEA20 v SOEA45','SOEA20 v MOEA20','SOEA45 v MOEA20','MOEA20 v MOEA45'};

av = mean(sil_total');

for k=1:4
subplot(2,2,k)
b1 = bar(sil_total(k,:));
b1(1).FaceColor = 'k';
ylim([0,0.7])
xticks(1:20)
hold on
yline(av(k),'--', 'color','k','LineWidth',2,'FontSize',FS1)
box off
set(gca,'TickDir','out');
title(titles{k})
if k==1||k==3
ylabel({'Silhouette'; 'value'})
end
set(gca,'fontsize', FS1)
legend('',['Mean = ' num2str(av(k))],'FontSize',FS1,'Location','North')

if k>2
xlabel('Subject Number')
end
xtickangle(0)
xlim([0.5,20.5])
end




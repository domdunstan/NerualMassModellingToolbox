function Eigenvalues

% Script recreates figure 8 from the manuscript. This compares the
% distribution of mean real part of the dominant eigenvalue for each subject
% across algoritms.

sims = 100;
subjects = 20;
FS1 = 7; % fontsize
% load eigenvalue results
load('Eigenvalues_domiant_real_part.mat')
moea20 = Eigenvalues_domiant_real_part.moea20;
moea45 = Eigenvalues_domiant_real_part.moea45;
soea20 = Eigenvalues_domiant_real_part.soea20;
soea45 = Eigenvalues_domiant_real_part.soea45;

% split into subjects
moea20_2 = reshape(moea20,[subjects,sims]);
moea45_2 = reshape(moea45,[subjects,sims]);
soea20_2 = reshape(soea20,[subjects,sims]);
soea45_2 = reshape(soea45,[subjects,sims]);

% caluclate mean
moga20_m = nanmean(moea20_2,2);
moga45_m = nanmean(moea45_2,2);
soga20_m = nanmean(soea20_2,2);
soga45_m = nanmean(soea45_2,2);

% plot
Colors = [[0.6350 0.0780 0.1840];[0.6, 0, 0.6];[0/255,0/255,153/255]; [51, 153, 255]/255];
h = figure1(9,10);
subplot = @(m,n,p) subtightplot (m, n, p, [0.02 0.02], [0.06 0.01], [0.15 0.01]);
subplot(1,1,1)
g = [zeros(1,subjects),ones(1,subjects),2*ones(1,subjects),3*ones(1,subjects)];
x1 = [soga20_m,soga45_m,moga20_m,moga45_m];
v1 = violinplot(x1,g);
ylabel({'Mean dominant'; 'real part of eigenvalues'})
box off
set(gca,'TickDir','out');
v1(1).ViolinColor = {Colors(4,:)};
v1(2).ViolinColor = {Colors(3,:)};
v1(3).ViolinColor = {Colors(2,:)};
v1(4).ViolinColor = {Colors(1,:)};
set(gca,'fontsize', 7)
xticks(1:4)
xticklabels({'SOEA20';'SOEA45';'MOEA20';'MOEA45'})

% caluclate significance values
p1 = ranksum(moga20_m,soga20_m);
p2 = ranksum(moga20_m,soga45_m);
p3 = ranksum(moga45_m,soga20_m);
p4 = ranksum(moga45_m,soga45_m);
p5 = ranksum(moga20_m,moga45_m);
p6 = ranksum(soga20_m,soga45_m);

ylim([-0.58,-0.26])

     H2=sigstar({ {'SOEA20','SOEA45'}},p6);
    set(H2,'color',[0.9290 0.6940 0.1250])

 H2=sigstar({{'SOEA45','MOEA20'}},p1);
    set(H2,'color',[0.9290 0.6940 0.1250])

     H2=sigstar({{'MOEA45','MOEA20'}},p5);
    set(H2,'color',[0.7350 0.480 0.1840])

     H2=sigstar({ {'SOEA20','MOEA45'}},p2);
    set(H2,'color',[0.9290 0.6940 0.1250])

     H2=sigstar({{'SOEA20','MOEA20'}},p3);
    set(H2,'color',[0.9290 0.6940 0.1250])

     H2=sigstar({{'SOEA45','MOEA45'}},p4);
    set(H2,'color',[0.9290 0.6940 0.1250])


set(gca,'fontsize', 7)
    text(1,-0.282,'p<0.001','color',[0.9290 0.6940 0.1250],'FontSize',7)
    text(1,-0.3,'p<0.01','color',[0.7350 0.480 0.1840],'FontSize',7)

yticks(-0.6:0.1:0)






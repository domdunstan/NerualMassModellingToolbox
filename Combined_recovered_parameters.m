function Combined_recovered_parameters


% Script recreates figure 7 from the manuscript. This compared parameter
% distributions recovered using each algorithm, across the 5 most
% identifibale parameters. 

subjects = 20; % number of subjects 
simulations = 100;
FS1 = 7; % fontsize
Liley_params;
% significant params
parameters = [9,10,17,3,21];
%% Load simulations

% moga
load('Total_Simulations_moea20.mat')

% moea20
p_temp = Total_Simulations_moea20.population;
p_moga_e = p_temp(1:subjects,1:simulations,:);


% soea20 
load('Total_Simulations_soea20.mat')
p_soga2 =  Total_Simulations_soea20.population;
p_soga2 = p_soga2(1:subjects,1:simulations,:);

% soea45
load('Total_Simulations_soea45.mat')
p_soga2_45 =  Total_Simulations_soea45.population;
p_soga2_45 = p_soga2_45(1:subjects,1:simulations,:);


% moea45
load('Total_Simulations_moea45.mat')
p_temp = Total_Simulations_moea45.population;
p_moga_e45 = p_temp(1:subjects,1:simulations,:);


Colors = [[51, 153, 255]/255; [0/255,0/255,153/255];[0.6, 0, 0.6];[0.6350 0.0780 0.1840]];



%% Plot results
h = figure1(19,16);
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.035], [0.07 0.04], [0.07 0.015]);
% soea20
p_soga2_t = reshape(p_soga2(:,:,1:22),[subjects*simulations,22]);
plot_histograms(p_soga2_t,6,5,1,Colors(1,:),{'Normalised';'Frequency'},parameters,subplot,FS1)

% soea45
p_soga2_45_t = reshape(p_soga2_45(:,:,1:22),[subjects*simulations,22]);
plot_histograms(p_soga2_45_t,6,5,2,Colors(2,:),{'Normalised';'Frequency'},parameters,subplot,FS1)

% moea20
p_moga_e2= reshape(p_moga_e,[subjects*simulations,23]);
plot_histograms(p_moga_e2,6,5,3,Colors(3,:),{'Normalised';'Frequency'},parameters,subplot,FS1)

% moea45
p_moga_e45_2= reshape(p_moga_e45,[subjects*simulations,23]);
plot_histograms(p_moga_e45_2,6,5,4,Colors(4,:),{'Normalised';'Frequency'},parameters,subplot,FS1)

paramnames= {
'h_{e}^{rest}' ,'h_{i}^{rest}','N_{ee}^{\beta}','N_{ei}^{\beta}','N_{ie}^{\beta}','N_{ii}^{\beta}','\Gamma_e',...
'\Gamma_i','\gamma_e','\gamma_i','\tau_{e}','\tau_i','S_{e}^{max}', 'S_{i}^{max}', '\mu_e',...
'\mu_i','\sigma_e','\sigma_i','h_{e}^{eq}' ,'h_{i}^{eq}', 'p_{ee}','p_{ei}'};



% calculate Jensen Shannon divergence across subjects
for mm=1:20
Z_s20(mm,:)=JSD2_combined(squeeze(p_soga2(mm,:,:)), parameters);
Z_s45(mm,:)=JSD2_combined(squeeze(p_soga2_45(mm,:,:)) , parameters);
Z_m20(mm,:)=JSD2_combined(squeeze(p_moga_e(mm,:,:)), parameters);
Z_m45(mm,:)=JSD2_combined(squeeze(p_moga_e45(mm,:,:)), parameters);
end



% Add JSD combined
Colors2 = [repmat(Colors(4,:),5,1);repmat(Colors(3,:),5,1);repmat(Colors(2,:),5,1);repmat(Colors(1,:),5,1)];
g = [zeros(1,subjects),ones(1,subjects),2*ones(1,subjects),3*ones(1,subjects)];
x1 = [Z_s20;Z_s45;Z_m20;Z_m45];

% plot
for m=1:5
    subplot(6,5,[20+m,25+m])
v1 = violinplot(x1(:,m),g);
v1(1).ViolinColor = {Colors(1,:)};
v1(2).ViolinColor = {Colors(2,:)};
v1(3).ViolinColor = {Colors(3,:)};
v1(4).ViolinColor = {Colors(4,:)};
ylim([0,max(x1(:,m))*1.05])

% caluclate significance values
p1 = 5*ranksum(Z_m20(:,m),Z_s20(:,m));
p2 = 5*ranksum(Z_m20(:,m),Z_s45(:,m));
p3 = 5*ranksum(Z_m20(:,m),Z_m45(:,m));
p4 = 5*ranksum(Z_s20(:,m),Z_s45(:,m));
p5 = 5*ranksum(Z_s20(:,m),Z_m45(:,m));
p6 = 5*ranksum(Z_s45(:,m),Z_m45(:,m));
if p1<0.05
 H1=sigstar({{'0','2'}},p1);
 if p1<0.001
 set(H1,'color',[0.9290 0.6940 0.1250])
 elseif p2<0.01
      set(H1,'color',[0.7350 0.480 0.1840])
 else
 set(H1,'color',[0.4660 0.6740 0.1880])
 end
end
if p2<0.05
 H2=sigstar({{'1','2'}},p2);
 if p2<0.001
 set(H2,'color',[0.9290 0.6940 0.1250])
 elseif p2<0.01
      set(H2,'color',[0.7350 0.480 0.1840])
 else
 set(H2,'color',[0.4660 0.6740 0.1880])
 end
end
 if p3<0.05
 H3=sigstar({{'2','3'}},p3);
 if p3<0.001
 set(H3,'color',[0.9290 0.6940 0.1250])
 elseif p3<0.01
      set(H3,'color',[0.7350 0.480 0.1840])
 else
 set(H3,'color',[0.4660 0.6740 0.1880])
 end
 end
 if p4<0.05
 H4=sigstar({{'0','1'}},p4);
 if p4<0.001
 set(H4,'color',[0.9290 0.6940 0.1250])
 elseif p3<0.01
      set(H4,'color',[0.7350 0.480 0.1840])
 else
 set(H4,'color',[0.4660 0.6740 0.1880])
 end
 end
 if p5<0.05
  H5=sigstar({{'0','3'}},p5);
 if p5<0.001
 set(H5,'color',[0.9290 0.6940 0.1250])
 elseif p5<0.01
      set(H5,'color',[0.7350 0.480 0.1840])
 else
 set(H5,'color',[0.4660 0.6740 0.1880])
 end
 end
 if p6<0.05
  H6=sigstar({{'1','3'}},p6);
 if p6<0.001
 set(H6,'color',[0.9290 0.6940 0.1250])
 elseif p6<0.01
      set(H6,'color',[0.7350 0.480 0.1840])
 else
 set(H6,'color',[0.4660 0.6740 0.1880])
 end 
 end
 set(gca,'fontsize', FS1)
xlabel(paramnames(parameters(m)))
box off
set(gca,'xtick',[])
set(gca,'TickDir','out');
if m==1; ylabel({'Jensen-Shannon'; 'Divergence'}); end
if m==3 xlabel({'\sigma_e';'Parameter'}); end

xlim([0.5,4.5])
YL = get(gca, 'YLim');
yl_max = round(YL(2),2);
if m==1
    yticks(0:0.1:yl_max)
elseif m==2
        yticks(0:0.1:yl_max)
elseif m==3
        yticks(0:0.05:yl_max)
        elseif m==4
        yticks(0:0.04:yl_max)
else
        yticks(0:0.02:yl_max)
end
    ylim([0,YL(2)])

if m==1
text(.65,0.5,'p<0.001','color',[0.9290 0.6940 0.1250],'FontSize',7)
end
if m==2
    text(.65,0.44,'p<0.01','color',[0.7350 0.480 0.1840],'FontSize',7)
text(.65,0.48,'p<0.001','color',[0.9290 0.6940 0.1250],'FontSize',7)
end
if m==3
text(.65,0.22,'p<0.001','color',[0.9290 0.6940 0.1250],'FontSize',7)
end
if m==4
text(.65,0.175,'p<0.001','color',[0.9290 0.6940 0.1250],'FontSize',7)
end
if m==5
text(.54,0.12,'p<0.05','color',[0.4660 0.6740 0.1880],'FontSize',7)
text(.54,0.13,'p<0.001','color',[0.9290 0.6940 0.1250],'FontSize',7)
end
end

% add for legend only
Z1=JSD2_combined(p_soga2_t, parameters);
Z2=JSD2_combined(p_soga2_45_t , parameters);
Z3=JSD2_combined(p_moga_e2, parameters);
Z4=JSD2_combined(p_moga_e45_2, parameters);
b=bar(5:9,[Z1',Z2',Z3',Z4']);
b(1).FaceColor = 'flat'; b(2).FaceColor = 'flat'; b(3).FaceColor = 'flat'; b(4).FaceColor = 'flat';
b(1).CData = Colors(1,:);
b(2).CData = Colors(2,:);
b(3).CData = Colors(3,:);
b(4).CData = Colors(4,:);
l1= legend('','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','SOEA20','SOEA45','MOEA20','MOEA45');
l1.NumColumns=4;

end
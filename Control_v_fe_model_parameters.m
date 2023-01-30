function Control_v_fe_model_parameters


% Script recreates figure 11 from the manuscript. This compares parameter
% values recovered from control and FE data, using the MOEA20 appaoch. The
% 4 parameters with the largest devation between the cohorts are shown.

% Load simulation results
sims = 100;
subjects=20;
FS1 = 7; % fontsize
pp = 4; % number of params difference to plot (in effect size order)
parameters = [1:22,25];

% load controls
load('Total_Simulations_moea20.mat')
pop_temp = Total_Simulations_moea20.population;
pop_temp = pop_temp(:,1:sims,:);
pop = reshape(pop_temp,[subjects*sims,23]);

% load fe
load('Total_Simulations_moea20_fe.mat')
pop_temp_fe = Total_Simulations_moea20_fe.population;
pop_temp_fe = pop_temp_fe(:,1:sims,:);
pop_fe = reshape(pop_temp_fe,[subjects*sims,23]);


% calculate p vals
for kk=1:length(parameters)
    [~,pval(kk)] = kstest2(pop(:,kk),pop_fe(:,kk));
end
pval2 = pval*23;
sig = pval2<0.05;


% caluclate and order by effect size
for j=1:length(parameters)
Effect_moga = meanEffectSize(pop(:,j),pop_fe(:,j),Effect="cohen");
[~,p1(j),ks2_moga(j)] = kstest2(pop(:,j),pop_fe(:,j));
cohend_moga(j) = abs(Effect_moga{1,1});
end
[cohend_moga2,idx] = sort(cohend_moga,'descend');
p_control2 = pop(:,idx(1:pp));
p_fe2 = pop_fe(:,idx(1:pp));



%5 calculate JSD between ctl and FE
for kk1=1:length(parameters)
    kk = parameters(kk1);
jsd1(kk1)=JSD_2_distirbutions(pop(:,kk1),pop_fe(:,kk1),kk);
end
[jsd2,idx2] = sort(jsd1,'descend');



%% Plot
% Define parameters
h = figure1(19,12);
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.08], [0.1 0.05], [0.05 0.02]);

paramstoest=1:22;
paramnames= {
'h_{e}^{rest}' ,'h_{i}^{rest}','N_{ee}^{\beta}','N_{ei}^{\beta}','N_{ie}^{\beta}','N_{ii}^{\beta}','\Gamma_e',...
'\Gamma_i','\gamma_e','\gamma_i','\tau_{e}','\tau_i','S_{e}^{max}', 'S_{i}^{max}', '\mu_e',...
'\mu_i','\sigma_e','\sigma_i','h_{e}^{eq}' ,'h_{i}^{eq}', 'p_{ee}','p_{ei}','p_{ie}','p_{ii}','ss'};

% loop over parmaters and plot probability density estimate
Liley_params;
for i=1:pp
subplot(3,2,i);
xlb = lb(paramstoest(idx(i)));
xub=ub(paramstoest(idx(i)));
edges = linspace(xlb,xub,40);
edges2 = linspace(xlb,xub,300);

g=histogram(p_control2(:,i)',edges,'FaceColor',[0 0.4470 0.7410]);
hold on
g2=histogram(p_fe2(:,i)',edges,'FaceColor',[0.8500 0.3250 0.0980]);
[kk,x]=ksdensity(p_control2(:,i),edges2,'Bandwidth',(xub-xlb)*0.015,'Support',[xlb,xub],'BoundaryCorrection','reflection');
[kk2,x2]=ksdensity(p_fe2(:,i),edges2,'Bandwidth',(xub-xlb)*0.015,'Support',[xlb,xub],'BoundaryCorrection','reflection');

ind = max(g.Values);
kk = kk/max(kk);
kk = kk*ind;
ind2 = max(g2.Values);
kk2 = kk2/max(kk2);
kk2 = kk2*ind2;
if max(kk)>max(kk2)
    kk2 = kk2/(sum(kk2)/sum(kk));
else
        kk = kk/(sum(kk)/sum(kk2));
end
h1 = plot(x,kk, 'color',[0 0.4470 0.7410],'Linewidth',2);
h2 = plot(x,kk2, 'color',[0.8500 0.3250 0.0980],'Linewidth',2);
height = max(max(kk,kk2));
xlim([xlb,xub])
ylim([0,height])
set(gca,'Yticklabels',[])
set(gca,'Ytick',[])
xticks([lb(paramstoest(idx(i))),ub(paramstoest(idx(i)))])
xlabel({paramnames{paramstoest(idx(i))}});
xh = get(gca,'xlabel');
p = get(xh,'position');
p(2) = p(2)/10 ;                    
set(xh,'position',p);
hYLabel = get(gca,'YLabel');
set(gca,'TickDir','out'); 
box off
set(gca,'fontsize', FS1)
ylabel({'Normalised';'frequency'})
% add inset to gamma_e and gamma_i
if i==2||i==4
if i==2
 % create smaller axes in top right, and plot on it
axes('Position',[.7 .75 .15 .15])
elseif i==4
 % create smaller axes in top right, and plot on it
axes('Position',[.7 .45 .15 .15])
set(gca,'fontsize', 7)
end
edges = linspace(xlb,xub,150);
g=histogram(p_control2(:,i)',edges,'FaceColor',[0 0.4470 0.7410]);%,'orientation','horizontal');
hold on
g2=histogram(p_fe2(:,i)',edges,'FaceColor',[0.8500 0.3250 0.0980]);%,'orientation','horizontal');
[kk,x]=ksdensity(p_control2(:,i),'Bandwidth',0.005*(xub-xlb));
[kk2,x2]=ksdensity(p_fe2(:,i),'Bandwidth',0.005*(xub-xlb));
ind = max(g.Values);
kk = kk/max(kk);
kk = kk*ind;
ind2 = max(g2.Values);
kk2 = kk2/max(kk2);
kk2 = kk2*ind2;
if max(kk)>max(kk2)
    kk2 = kk2/(sum(kk2)/sum(kk));
else
        kk = kk/(sum(kk)/sum(kk2));
end
h1 = plot(x,kk, 'color',[0 0.4470 0.7410],'Linewidth',2);
h2 = plot(x,kk2, 'color',[0.8500 0.3250 0.0980],'Linewidth',2);

height = max(max(kk,kk2));
xlim([xlb,xlb+(xub-xlb)*(1/3)])


ylim([0,height])
xticks([xlb,xlb+(xub-xlb)*0.2])
xlabel({paramnames{paramstoest(idx(i))}});
    xh = get(gca,'xlabel');
p = get(xh,'position');
p(2) = p(2)/10 ;                    
set(xh,'position',p);
    ylabel({'Normalised';'frequency'})

set(gca,'Ytick',[])
xlabel({paramnames{paramstoest(idx(i))}});
set(gca,'TickDir','out'); 
box off
set(gca,'fontsize', FS1)
end
set(gca,'fontsize', FS1)
end
l1 = legend('Controls','Focal Epilepsy');
l1.NumColumns=2;

subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.08], [0.1 0.05], [0.05 0.02]);

% add effect sizes
s5 = subplot(3,2,5);
b1 = bar(cohend_moga2(1:pp+1)');
b1(1).FaceColor = [0.3, 0.3, 0.3];
box off
set(gca,'TickDir','out');

row1 = [paramnames(idx(1:pp)),{'    Maximum of'}];
row2 = {'','','','', 'other parameters'};
labelArray = [row1; row2]; 
tickLabels = strtrim(sprintf('%s\\newline%s\n', labelArray{:}));
xticks(1:5)
xticklabels(tickLabels)

xlabel('Parameter')
ylabel(sprintf("Cohen's d"))
yline(0.2,'-',{'Small effect threshold'},'LineWidth',2,'color','k','fontsize',FS1)
xtickangle(0)
ylim([0,max(b1.YData)*1.1])
set(gca,'fontsize', FS1)
xlim([.5,5.5])
ylim([0,0.35])


% add JSD
subplot(3,2,6);
b1 = bar(jsd2(1:pp+1)');
b1(1).FaceColor = [0.3, 0.3, 0.3];
box off
set(gca,'TickDir','out');

row1 = [paramnames(idx(1:pp)),{'    Maximum of'}];
row2 = {'','','','', 'other parameters'};
labelArray = [row1; row2]; 
tickLabels = strtrim(sprintf('%s\\newline%s\n', labelArray{:}));
xticks(1:5)
xticklabels(tickLabels)

xlabel('Parameter')
ylabel({'Jensen-Shannon'; 'Divergence'})
xtickangle(0)
ylim([0,max(b1.YData)*1.1])
set(gca,'fontsize',FS1)

xlim([.5,5.5])
ylim([0,0.023])


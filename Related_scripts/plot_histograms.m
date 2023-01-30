function plot_histograms(parameter_set,subplot1,subplot2,row,color,Label,parameters_to_plot,subplot,FS1)

% This function plots hisotgrams of parameter locations

paramnames= {
'h_{e}^{rest}' ,'h_{i}^{rest}','N_{ee}^{\beta}','N_{ei}^{\beta}','N_{ie}^{\beta}','N_{ii}^{\beta}','\Gamma_e',...
'\Gamma_i','\gamma_e','\gamma_i','\tau_{e}','\tau_i','S_{e}^{max}', 'S_{i}^{max}', '\mu_e',...
'\mu_i','\sigma_e','\sigma_i','h_{e}^{eq}' ,'h_{i}^{eq}', 'p_{ee}','p_{ei}','p_{ie}','p_{ii}','\phi'};

Liley_params;
npars_est = length(parameters_to_plot);
for i=1:npars_est
parameter_temp = parameters_to_plot(i);
subplot(subplot1,subplot2,i+subplot2*(row-1))
xlb = lb(parameter_temp);
xub = ub(parameter_temp);
edges = linspace(xlb,xub,30);
edges2 = linspace(xlb,xub,200);
g=histogram(parameter_set(:,parameter_temp)',edges,'FaceColor',color);
hold on
[kk,x]=ksdensity(parameter_set(:,parameter_temp),edges2,'Bandwidth',(xub-xlb)*0.02,'Support',[xlb,xub],'BoundaryCorrection','reflection');
ind = max(g.Values);
kk = kk/max(kk);
kk = kk*ind;
h1 = plot(x,kk, 'color',color,'Linewidth',2);
hold off
xlim([xlb,xub])
ylim([0,ind])
set(gca,'Yticklabels',[])
set(gca,'fontsize', FS1)
xticks([lb(parameter_temp),ub(parameter_temp)])
xlabel(paramnames(parameter_temp))
set(gca,'ytick', [])
  xh = get(gca,'xlabel');
p = get(xh,'position');
p(2) = p(2)/10 ;                    
set(xh,'position',p);

if i==1
    ylabel(Label)
end
 set(gca,'fontsize', FS1)

set(gca,'TickDir','out'); 
box off
ylim([0,ind])
end


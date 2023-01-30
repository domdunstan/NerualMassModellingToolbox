function [Z,Z_mat]=plot_JSD2(Full_Parameters,Colors, parameters,subjects,simulations,plot)

% This function plots the JSD against the uniform distribution as grouped boxplots

paramnames= {
'h_{e}^{rest}' ,'h_{i}^{rest}','N_{ee}^{\beta}','N_{ei}^{\beta}','N_{ie}^{\beta}','N_{ii}^{\beta}','\Gamma_e',...
'\Gamma_i','\gamma_e','\gamma_i','\tau_{e}','\tau_i','S_{e}^{max}', 'S_{i}^{max}', '\mu_e',...
'\mu_i','\sigma_e','\sigma_i','h_{e}^{eq}' ,'h_{i}^{eq}', 'p_{ee}','p_{ei}'};

dim = length(Full_Parameters);
for idx=1:dim
    params_temp = squeeze(Full_Parameters{idx});
for h=1:subjects
    params=[];
    for kk=1:simulations
params=[params;squeeze(params_temp{h,kk})];
    end
parameter=params;
Liley_params;
for i=1:length(parameters)
    ii=parameters(i);
    range=[lb(ii) ub(ii)];
    pts=linspace(range(1),range(2),100);
[kk1(i,:),x1]=ksdensity(parameter(:,i),pts,'Bandwidth',(range(2)-range(1))*0.1);
x1(x1<range(1))=0; x1(x1>range(2))=0;
kk1_in=kk1(i,:); kk1_in(x1==0)=0;
kk1(i,:)=kk1_in;
kk1=kk1./sum(kk1,2);
% Caculate uniform dsitirbution
X=ones(22,100);
X=X./sum(X,2);
Z1(i,h) = JSDiv(kk1(i,:),X(1,:));
Z_mat(i,h,idx) = JSDiv(kk1(i,:),X(1,:));
kk1=[];
end
end

Z(idx) = {Z1'};
end

if plot==1
% plot as grouped boxplots
Colors = flip(Colors);
Colors2 = [repmat(Colors(1,:),[length(parameters),1]);repmat(Colors(2,:),[length(parameters),1]);...
    repmat(Colors(3,:),[length(parameters),1]);repmat(Colors(4,:),[length(parameters),1])];
hAx=gca;
boxplotGroup(Z,'OutlierSize',2, 'Symbol','.');  
h = findobj(gca,'Tag','Box');
for j=1:4*length(parameters)
    patch(get(h(j),'XData'),get(h(j),'YData'),Colors2(j,:),'FaceAlpha',.8);
end
ylabel({'Jensen - Shannon'; 'Divergence'})
xlabel('Parameter')
box off
xticks(3:5:length(parameters)*5)
xticklabels(paramnames(parameters))
hAx.XAxis.TickLabelInterpreter='tex';

set(gca,'TickDir','out');
end

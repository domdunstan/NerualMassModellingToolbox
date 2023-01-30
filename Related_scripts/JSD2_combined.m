function Z1=JSD2_combined(parameter, parameters)

% Function calculates the JSD from a given parameter set to a uniform
% distirbuiton

Liley_params;
for i=1:length(parameters)
    ii=parameters(i);
    range=[lb(ii) ub(ii)];
    pts=linspace(range(1),range(2),100);
[kk1(i,:),x1]=ksdensity(parameter(:,ii),pts,'Bandwidth',(range(2)-range(1))*0.02,'Support',[range(1),range(2)],'BoundaryCorrection','reflection');
x1(x1<range(1))=0; x1(x1>range(2))=0;
kk1_in=kk1(i,:); kk1_in(x1==0)=0;
kk1(i,:)=kk1_in;
kk1=kk1./sum(kk1,2);
% Caculate uniform dsitirbution
X=ones(22,100);
X=X./sum(X,2);
Z1(i) = JSDiv(kk1(i,:),X(1,:));

kk1=[];
end
end

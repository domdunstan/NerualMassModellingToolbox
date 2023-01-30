function jsd1=JSD_2_distirbutions(dist1,dist2,parameter)

% Function calculates the JSD between 2 distributions

Liley_params;
    ii=parameter;
    range=[lb(ii) ub(ii)];
    pts=linspace(range(1),range(2),100);
    % dist1
[kk1,x1]=ksdensity(dist1,pts,'Bandwidth',(range(2)-range(1))*0.02,'Support',[range(1),range(2)],'BoundaryCorrection','reflection');
x1(x1<range(1))=0; x1(x1>range(2))=0;
kk1_in=kk1; kk1_in(x1==0)=0;
kk1=kk1_in;
kk1=kk1./sum(kk1,2);
    % dist1
[kk2,x2]=ksdensity(dist2,pts,'Bandwidth',(range(2)-range(1))*0.02,'Support',[range(1),range(2)],'BoundaryCorrection','reflection');
x2(x2<range(1))=0; x2(x2>range(2))=0;
kk2_in=kk2; kk2_in(x2==0)=0;
kk2=kk2_in;
kk2=kk2./sum(kk2,2);
jsd1 = JSDiv(kk1,kk2);

end
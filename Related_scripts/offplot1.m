function h1=offplot1(time_series,diff,t1,color)

% function offplots a time series signal 

if size(time_series,1)>size(time_series,2)
    time_series=time_series';
end


for j=1:size(time_series,1)
    h1(j) = plot(t1,time_series(j,:)+diff*(j-1),'color',color(j,:),'LineWidth',1);
    hold on
end
hold off


end







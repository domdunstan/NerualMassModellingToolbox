function h=figure1(varargin)
% function loads a figure for plotting

h=figure;
set(gcf, 'units', 'centimeters')
    pos1=get(gcf, 'position');


if nargin==0
    width_=19;height_=8;
else 
    width_=varargin{1};
    height_=varargin{2};
end



pos2=[pos1(1) pos1(2)-10 width_ height_];
set(gcf, 'position', pos2)

function p1=lhsdesign_scale1(npop, npars_est, bounds)
% bounds 2xn matrix with first row lower bounds and second row upper bound.
convert=@(a,b)(a+(b-a)*lhsdesign(npop,1));
for j=1:npars_est
    p1(:,j)=convert(bounds(1,j),bounds(2,j));
end
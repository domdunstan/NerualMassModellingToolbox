function makeCoderEm(TDatend,tcut)
fhz1 = 19.965*4; % main timstep
T1=0:1/fhz1:TDatend+tcut;
Liley_params;
y0=zeros(1,10);
params1=[paramsvec, y0];
codegen em_Liley.m -args {T1, params1} -test forCoder
end

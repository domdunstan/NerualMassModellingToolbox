% test
Liley_params;
fhz1 = 19.965*4; % main timstep
tcut = 5000; % apply for transients
TDatend = 20000; % length of model simulation ms
T1=0:1/fhz1:TDatend+tcut;
params1 = [paramsvec, zeros(1, 10)];
y = em_Liley(T1, params1);

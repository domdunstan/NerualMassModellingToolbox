% defualt params and upper/lower bounds for the Liley model
param.he_rest = -70; 
param.hi_rest = -70;
param.Nee_beta = 4000;
param.Nei_beta = 3034;
param.Nie_beta = 536;
param.Nii_beta = 536;
param.Gamma_e = 0.4;
param.Gamma_i = 0.8;
param.gamma_e = 0.3;
param.gamma_i = 0.065;
param.Tau_e = 10;
param.Tau_i = 10;
param.Se_max = 0.5;
param.Si_max = 0.5;
param.mu_e = -50;
param.mu_i = -50;
param.sigma_e = 5;
param.sigma_i = 5;
param.he_eq = -2.5335;
param.hi_eq = -87.5723;
param.pee = 5;
param.pei = 5;
param.pie = 0;
param.pii = 0;
param.ss = 5;

% defualt params and upper/lower bounds for the Liley model
paramsvec = [param.he_rest param.hi_rest, param.Nee_beta, param.Nei_beta, param.Nie_beta,...
    param.Nii_beta, param.Gamma_e, param.Gamma_i, param.gamma_e, param.gamma_i, param.Tau_e,...
    param.Tau_i, param.Se_max, param.Si_max, param.mu_e, param.mu_i, param.sigma_e,...
    param.sigma_i, param.he_eq, param.hi_eq, param.pee, param.pei, param.pie, param.pii, param.ss];

ub=[-60,-60,5000,5000,1000,1000,2,2,1,0.5,150,150,0.5,0.5,-40,-40,7,7,10,-65,10,10,0.1,0.1,10];
lb=[-80,-80,2000,2000,100,100,0.1,0.1,0.1,0.01,5,5,0.05,0.05,-55,-55,2,2,-20,-90,0,0,0,0,0];

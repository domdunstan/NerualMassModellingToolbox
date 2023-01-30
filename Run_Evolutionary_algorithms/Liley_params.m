% defualt params and upper/lower bounds for the Liley model
param.he_rest = -69.6952; 
param.hi_rest = -74.4255;
param.Nee_beta = 2847.80;
param.Nei_beta = 4422.60;
param.Nie_beta = 744.01;
param.Nii_beta = 173.86;
param.Gamma_e = 1.9827;
param.Gamma_i = 0.4169;
param.gamma_e = 0.3030;
param.gamma_i = 0.0486;
param.Tau_e = 106.1237;
param.Tau_i = 69.5959;
param.Se_max = 0.2943;
param.Si_max = 0.0671;
param.mu_e = -40.0612;
param.mu_i = -52.8817;
param.sigma_e = 3.8213;
param.sigma_i = 2.4760;
param.he_eq = -2.5335;
param.hi_eq = -87.5723;
param.pee = 3.1560;
param.pei = 2.6976;
param.pie = 0;
param.pii = 0;
param.xi = 5;

% defualt params and upper/lower bounds for the Liley model
paramsvec = [param.he_rest param.hi_rest, param.Nee_beta, param.Nei_beta, param.Nie_beta,...
    param.Nii_beta, param.Gamma_e, param.Gamma_i, param.gamma_e, param.gamma_i, param.Tau_e,...
    param.Tau_i, param.Se_max, param.Si_max, param.mu_e, param.mu_i, param.sigma_e,...
    param.sigma_i, param.he_eq, param.hi_eq, param.pee, param.pei, param.pie, param.pii, param.xi];


test_params=[-69.6952,-74.4255,2847.80,4422.60,744.01,173.86,1.9827,0.4169,0.3030,0.0486,106.1237,69.5959,0.2943,0.0671,-40.0612,-52.8817,3.8213,2.4760,-2.5335,-87.5723,3.1560,2.6976,5];

% define bounds
ub=[-60,-60,5000,5000,1000,1000,2,2,1,0.5,150,150,0.5,0.5,-40,-40,7,7,10,-65,10,10,0.1,0.1,10];
lb=[-80,-80,2000,2000,100,100,0.1,0.1,0.1,0.01,5,5,0.05,0.05,-55,-55,2,2,-20,-90,0,0,0,0,0];

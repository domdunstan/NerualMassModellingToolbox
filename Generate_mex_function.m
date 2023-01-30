


%% Generates mex file of the model function

cd('Generate_mex')
mex_path = pwd;
addpath(mex_path)
tcut = 5000; % apply for transients
TDatend = 20000; % length of model simulation ms
makeCoderEm(TDatend,tcut);
cd ..







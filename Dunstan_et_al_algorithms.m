

%% %% %% %% %% %%  MASTER SCRIPT FOR RUNNING ALGORITHMS %% %% %% %% %% %% %%% %
%                                                                             %
%    GLOBAL NONLINEAR APPAOCH FOR MAPPING PARAMETERS OF NEURAL MASS MODELS    %
%                                                                             %           
% Dominic M. Dunstan*, Mark P. Richardson, Eugenio Abela, Ozgur E. Akman,     %             
% Marc Goodfellow                                                             %
%                                                                             %
%  doi: https://doi.org/10.1371/journal.pcbi.1010985                          %
%                                                                             %
% This software uses a number of external toolboxes. We are grateful to the   %
% authors of these toolboxes. In each case, the licenses are stated within    %
% the corresponding header.                                                   %
%                                                                             %
% University of Exeter 2023.                                                  %
% *d.dunstan@exeter.ac.uk                                                     %
% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% % % %

% Note, fitness function can be adjsted to simulate any mathematical (neural mass) model. Here we use the Liley model.

%% Generate mex function for model simulations
% The capability to build MEX functions from matlab needs to be enabled for this to be compatable
Generate_mex_function;


%% Example run of algorithms

% Note, for the model used in the manuscipt, these algorithms are time
% consuming. A single run of each of the SOEA20, SOEA45, MOEA20 and MOEA45
% is implemeneted below and the correposning output is saved in the current
% directory.

% add paths
path1 = pwd;
addpath('Run_Evolutionary_algorithms')

run_number = 1; % define run number
subject = 1; % define subject number
npop = 500; % population size

% applying the SOEA20 on an example subject
SOEA20_Liley(subject,run_number,npop)

% applying the SOEA45 on an example subject
SOEA45_Liley(subject,run_number,npop)

% applying the MOEA20 on an example subject
MOEA20_Liley(subject,run_number,npop)

% applying the MOEA45 on an example subject
MOEA45_Liley(subject,run_number,npop)







%% %% %% %% %% %%  MASTER SCRIPT FOR GENERATING FIGURES %% %% %% %% %% %% %%% %
%                                                                             %
%    GLOBAL NONLINEAR APPAOCH FOR MAPPING PARAMETERS OF NEURAL MASS MODELS    %
%                                                                             %           
% Dominic M. Dunstan*, Mark P. Richardson, Eugenio Abela, Ozgur E. Akman,     %             
% Marc Goodfellow                                                             %
%                                                                             %
%                                                                             %
% Execution of this script recreates all results figures in the above         %
% manuscipt. See the paper for details.                                       %
%                                                                             %
% This software uses a number of external toolboxes. We are grateful to the   %
% authors of these toolboxes. In each case, the licenses are stated within    %
% the corresponding header.                                                   %
%                                                                             %
% University of Exeter 2023.                                                  %
% *d.dunstan@exeter.ac.uk                                                     %
% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% % % %





%% Generate mex function for model simulations
% The capability to build MEX functions from matlab needs to be enabled for this to be compatable
Generate_mex_function;



%% Simulate and plot figures

path1 = pwd;
addpath('Simulation_data')
addpath('Related_scripts')

% Plot Figure 2
Example_dynamics;

% Plot Figure 3
Investigating_model_simulation_waveforms;

% Plot Figure 4 
Normalised_objective_scores;

% Plot Figure 5 
Example_recovered_parameters;

% Plot Figure 6 
Silhouette_scores;

% Plot Figure 7 
Combined_recovered_parameters;

% Plot Figure 8 
Eigenvalues;

% Plot Figure 10 
Total_control_and_fe_simulations;

% Plot Figure 11 
Control_v_fe_model_parameters;

% Plot Figure 12 
Spike_wave_discharge;












function [VG] = fast_HVG(signal_var,coords_var,weight)

% Code edited from the following: https://www.mathworks.com/matlabcentral/fileexchange/72889-fast-horizontal-visibility-graph-hvg-for-matlab
%
% Implementation of horizontal visibility graph based on:
% Luque, B., Lacasa, L., Ballesteros, F., & Luque, J. (2009). 
% Horizontal visibility graphs: Exact results for random time series. 
% Physical Review E, 80(4), 046103.
% ===============================================================
% Code by: Giovanni Iacobello, Politecnico di Torino (Italy)
% giovanni.iacobello@polito.it
% ===============================================================
% INPUTS:
% signal_var: time series (must be a vector)
% coords_var: time vector (same length od signal_var)
% shiftvalue: scalar real value. Default: shiftvalue=0; 
%             Nodes i and j are linked if
%             (signal_var(k)+shiftvalue)<min[signal_var(i),signal_var(j)], for any i<k<j
%
% OUTPUTS:
% VG: sparse adjacency matrix (symmetrical)
%
%%  PRE-PROCESSING CONTROLS
    VG=[];
    if isvector(signal_var)==0 || isvector(coords_var)==0
        disp('Error size: series and times must be vectors')
        return;
    end
    if length(signal_var)~=length(coords_var)
        disp('Error size: series and times must have the same length')
        return;
    end
    if iscolumn(signal_var)==0
        signal_var=signal_var';
    end
    if iscolumn(coords_var)==0
        coords_var=coords_var';
    end
    if exist('shiftvalue','var')==0
        shiftvalue=0; %no shifting -> classical HVG
    elseif isscalar(shiftvalue)==0
        disp('Error shiftvalue: insert a scalar value')
        return;
    end    
    
%% RUNNING
    weight=find(ismember({'u','w'},weight)); %weight=1 or 2
    N=size(signal_var,1);
    B=cell(N,weight);
    B=HVG_alg2(signal_var,1,N,B,coords_var,weight);
    
%% CONVERTING INTO SPARSE MATRIX

    Adj_tmp=cell(N,1);
    for ii=1:N
        Adj_tmp{ii}=ones(length(B{ii,1}),1)*ii;
    end
    target=vertcat(Adj_tmp{:});
    clear A_tmp
    source=vertcat(B{:,1});
    
    if weight==1
        weight_input=ones(size(target));
    elseif weight==2
        weight_input=cell(N,1);
        for ii=1:N
            if isempty(B{ii,1})==0
                weight_input{ii}=B{ii,2};
            end
        end
        weight_input=vertcat(weight_input{:});
    end
    
    if ~isa(source,'double')
        source=double(source); %"sparse" function requires doubles
    end
    VG=sparse(source,target,weight_input,N,N);
    VG=VG+VG'; %makes adjcency matrix simmetrical

end


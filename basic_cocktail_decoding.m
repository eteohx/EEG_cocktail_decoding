%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Cocktail party: Decoding attentional selection               %
%                     using stimulus reconstruction                %
%                     (akin to O'Sullivan et al., 2015)            %
%    (Author: ETeoh, 2019)                                         %
%                                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% add TRF to path and define working directory
addpath(genpath('path\to\mTRF_1.5'));
wd = 'path\to\Basic_Cocktail_Decoding\';

% TRF parameters
fs = 128;
start = 0;
fin =  250;
lambda = 2.^(-2:30); %if taking too long, try [1e1 1e2 1e3 1e4 1e5 1e6 1e7 1e8];

%load stimulus representations
load([wd 'F_allstim.mat'])
stim1F = stim1; 
load([wd 'M_allstim.mat'])
stim1M = stim1; 

% trials for the competing speaker were shuffled... load the order here
load([wd 'competing_speaker_order.mat'])

% Loop across subjects
for subidx = 1
    subj = ['Subject' num2str(subidx)];
    disp(subj)
    data_dir = [wd 'Pre-processed_Data\' subj '\'];
    tic
    % SET UP
    % put stimulus representations and EEG responses into cell matrices for
    % TRF
    att_stim = {}; unatt_stim = {}; resp = {};
    for block = 1:2
        for trialidx = 1:20
            load([data_dir num2str(block) '_' num2str(trialidx) '.mat']);
            resp = [resp, zscore(eeg)];
            if block == 1
                stim_att = zscore(stim1F{trialidx});
                stim_unatt = zscore(stim1M{blk1_M_Order(trialidx)});
            elseif block == 2
                stim_att = zscore(stim1M{trialidx});
                stim_unatt = zscore(stim1F{blk2_F_Order(trialidx)});
            else
                disp('Warning - error')
            end
            att_stim = [att_stim, stim_att];
            unatt_stim = [unatt_stim, stim_unatt];
        end
    end
    
    % DECODING
    % Train attended decoders, perform stimulus reconstruction, and compute correlations with
    % the attended stimulus representation
    [rho_att, ~,~, pred, ~] = mTRFcrossval(att_stim,resp,fs,-1,start,fin,lambda);
    
    % Compute correlation of reconstructions with the unattended stimulus representation
    for i = 1:numel(att_stim)
        for l = 1:numel(lambda)
            rho_unatt(i,l) = corr(pred{i}(l,:)',unatt_stim{i});
        end
    end
    
    % Save results
    save([subj '.mat'],'rho_att','rho_unatt')
    disp('Done!')
    toc
end

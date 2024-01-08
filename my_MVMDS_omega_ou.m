function[signal,mode]=my_MVMDS_omega_ou(ewhnone,maxnum,penaly_factor,ds_flag,omega_ou_max)
%%
%  This function is dedicated to decompose the input 2-d matrix
%  input: 
%  ewhnone:         input 2-d matrix
%  maxnum:          K     (6 in our paper for GRACE noise)
%  penaly_factor:   \alpha (500 in our paper for GRACE noise)
%  ds_flag:         0/1  -> ds=cos(co-latitude) /   ds=1; a weight for each
%  omega_ou_max:    w_max (0.1 in our paper for GRACE noise)
% 
%   signal:   the filtered result;
%   mode:     res+each mode; ranging along 3-d; 
%               the first one is residual, 
%               the second one to the finnal one is IMF1, IMF2~~~;IMF_k; respectively.
%  
%-------------------------------------------------------
% Editor: 		Guangyu Jian
% Contact: 	gyjian@mail2.gdut.edu.cn 
% please let me know if you confuse about our code
% it is a code for filtering north-south stripe noise
% 
% Date: 2023 10 25
% Reference: 
% Multivariate variational mode decomposition to extract 
% the stripe noise in GRACE harmonic coefficients
% under review (geophysical journal international)
%---------------------------------------------------------------------------
% To avoid copyright issues, please download the algorithm of MVMD at
%“ https://ww2.mathworks.cn/login/mwa-sso?uri=https%3A%2F%2Fww2.
% mathworks.cn%2Fmatlabcentral%2Ffileexchange%
% 2F72814-multivariate-variational-mode-decomposition-mvmd%
% 3Fs_tid%3DFX_rc1_behav&tx_id=PuXiCix2OKlPxP2f4mF4”

%% checking row

if size(ewhnone,1)>180
    error( ...
        'row>180');
end
%% decomposition

[mode,omega_ou]=my_MVMDS_component(ewhnone,maxnum,penaly_factor,ds_flag);


%% checking_residual
rms_res=rms(mode(:,:,1),'all');
rms_ori=rms(ewhnone(:,:,1),'all');
if rms_res>rms_ori/100
lc2=1;
error('too much redisual>1%');
end
%% collection


res=mode(:,:,1);
mode(:,:,1)=[]; %res does not have corresponding omega

%
lc1=find(omega_ou<omega_ou_max);
signal=sum(mode(:,:,lc1),3);
signal=res+signal;

mode(:,:,2:maxnum+1)=mode;
mode(:,:,1)=res;


end

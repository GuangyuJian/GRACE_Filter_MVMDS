function [temp,omega_ou]=my_MVMDS_component(ewhnone,maxnum,penaly_factor,ds_flag)
%%
%  [temp,omega_ou]=my_MVMDS_component(ewhnone,maxnum,penaly_factor,ds_flag)
%  This function is dedicated to decompose the input 2-d matrix
%  input: ewhnone
%  maxnum:          K
%  penaly_factor:   \alpha 
%  ds_flag:         0/1  -> ds=cos(co-latitude) /   ds=1; a weight for each
%  channel accross the latitudes
% 
%   temp:       res+each mode; ranging along 3-d; 
%               the first one is residual, 
%               components from the second one to the finnal one respectively is IMF1, IMF2~~~;IMF_k; .
%  
%   omega_ou:   the center frequency of each IMF;
%               the frst one to the finnal one corresponding to 
%               IMF1; IMF2~~~;IMF_k; respectively.
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
if ds_flag==1
    ds=1;
else
    ds=get_ds(size(ewhnone,1),size(ewhnone,2));
end
rr=size(ewhnone,1);
cc=size(ewhnone,2);

if size(ewhnone,3)>1
    error('wrong input "3d!!"; check your input');
end

%% decomposition using MVMD
[u,  ~, omega] = MVMD_new(ewhnone.*ds, penaly_factor, 0.2*5, maxnum, 1, 1, 1*10-12);

%% reconstruct the vector
temp=sum(u,1);
temp=flipud(rot90(reshape(temp,cc,rr)))./ds;
res=ewhnone-temp;


temp(:,:,1)=res;
for k=1:size(u,1)
    temp1=sum(u([k],:,:),1);
    temp(:,:,k+1)=flipud(rot90(reshape(temp1,cc,rr)))./ds;
end
%% collect omega in the final iteration
omega_ou=omega(end,:);

end

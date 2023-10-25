function[temp]=my_MVMDT_component(shc,maxnum,penaly_factor)
%%
% 相比于第一版本
% 该版本没有ds;


if size(shc,3)>1
    error('不建议超过三维');
end

[u, ~, ~] = MVMD_new(shc, penaly_factor, 0, maxnum, 1, 0, 1*10-12);

temp=sum(u,1);
rr=size(shc,1);
cc=size(shc,2);
temp=flipud(rot90(reshape(temp,cc,rr)));
res=shc-temp;

% lc=[1 6];
temp(:,:,1)=res;
for k=1:size(u,1)
temp1=sum(u([k],:,:),1);
temp(:,:,k+1)=flipud(rot90(reshape(temp1,cc,rr)));

end


end
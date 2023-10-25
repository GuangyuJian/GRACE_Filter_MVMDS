function ds=get_ds(r,c)


% clc;
% r=180;
% c=360;

d=180/r;
ceta=90-d/2:-d:-90+d/2;

f=0;
for ce=90-ceta
    f=f+1;
    sum1=0;
    for k=0:r/2-1
        sum1=sum1+sind((2*k+1)*ce)/(2*k+1);
    end
    ds(f,1:c)=4*pi/(r^2)*sind(ce)*sum1;
end

end
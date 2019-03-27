x = thresh;
F_s = 360;

%RR intervals
R_t = zeros(1,length(ecg_sig)); %this vector will contain RR intervals
t_R = find(x); %t_R contains indices where x is non zero i.e. location R points
for i = 1:length(t_R)-1
    R_t(t_R(i)) = (t_R(i+1)-t_R(i))/F_s; %calculation of RR intervals
end
threshold2 = max(R_t)/2;
for i = 1:length(R_t)
    if R_t(i)<threshold2
        R_t(i) = 0;
    end
end

%interpolation
hrvn = zeros(1,length(R_t));
Dt = 1/F_s;
sigpos = R_t;
b = [1 -1];
hrv1 = filter(b,1,sigpos);
for t = 0:Dt:sigpos(length(sigpos))
    if t<sigpos(1)
        vmin=1;
    else
        v1=find(sigpos<=t);
        vmin=v1(length(v1));
    end
    v1 = find(sigpos>t);
    vmax = v1(1);
    k=round(t/Dt)+1;
    if vmin==vmax
        hrvn(k)=hrv1(vmin);
    else
        hrvn(k)=(hrv1(vmax)*(t-sigpos(vmin))+hrv1(vmin)*(sigpos(vmax)-t))/(sigpos(vmax)-sigpos(vmin));
    end
end

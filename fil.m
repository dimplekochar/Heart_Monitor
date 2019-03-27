x=ecg_sig -mean(ecg_sig); 
%LPF 15Hz %y(n)= 2*y(n-1)-y(n-2)+x(n)-2*x(n-6)+x(n-12);
y(1)=x(1);
y(2)= 2*y(1)+x(2);
for n=3:6
    y(n)= 2*y(n-1)-y(n-2)+x(n);
end
for n=7:12
    y(n)= 2*y(n-1)-y(n-2)+x(n)-2*x(n-6);
end
for n=13:length(ecg_sig)
    y(n)= 2*y(n-1)-y(n-2)+x(n)-2*x(n-6)+x(n-12);
end

xorig=x; %original unfiltered signal
x=y/20; %x is now scaled and Low Pass filtered
x_lpf = y/20;
y=0;

%HPF 5Hz %y(n)= 32*x(n-16)-y(n-1)-x(n)+x(n-32);

y(1)=-x(1);
y(2)= -y(1)-x(2);
for n=2:16
    y(n)= -y(n-1)-x(n);
end
for n=17:32
    y(n)= -y(n-1)-x(n)+32*x(n-16);
end
for n=33:length(ecg_sig)
    y(n)=-y(n-1)-x(n)+32*x(n-16)+x(n-32);
end;
%y=y/580; %scale the gain

xfilt=y/20; %scaled and BPF signal
x=y/20;
y=0;

%Differentiation %y(n)= (1/8)*(-x(n-2)-2*x(n-1)+2*x(n+1)+x(n+2));

y(1)= (1/8)*(2*x(2)+x(3));
y(2)= (1/8)*(2*x(3)+x(4)-2*x(1));
for n=3:length(ecg_sig)-2
    y(n)= (1/8)*(-x(n-2)-2*x(n-1)+2*x(n+1)+x(n+2));
end;
y(length(ecg_sig)-1)=(1/8)*(-x(length(ecg_sig)-1-2)-2*x(length(ecg_sig)-1-1)+2*x(length(ecg_sig)-1));
y(length(ecg_sig))= (1/8)*(-x(length(ecg_sig)-2)-2*x(length(ecg_sig)-1));

xdiff=y;
x=y;
y=0;

%squaring
for n=1:length(ecg_sig)
    y(n)= (x(n))^2;
end

x = y; %x now contains filtered and squared signal
x_sq = y;
y = zeros(1,3600);

%MWI
N = 28;
for n = 1:length(ecg_sig)
    for i = 0:(N-1)
        if n-i>=1 % => assign value zero for negative indices in moving window
            y(n) = y(n) + x(n-i)/N;
        end
    end
end

x = y; %x is now the integrated signal
x_MWI = y;
y = 0;


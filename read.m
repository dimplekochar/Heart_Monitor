[filename, pathname] = uigetfile('*.dat', 'Open file .dat');% only image Bitmap

fid=fopen(filename,'r');

time=10;
f=fread(fid,2*360*time,'ubit12'); %since sample at 360 samples per second
ecg_sig=f(1:2:length(f));
t=linspace(0, time, length(f)/2);
%plot(t,ecg_sig);
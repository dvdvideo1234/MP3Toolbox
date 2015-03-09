% Testing DFT functions
clc
clear all

f = 150;
N = 512;
fs = 4*f;
df = 0:fs/N:fs-1;
t = 0:1/fs:50;
sig = 10*sin(2*pi*f*t);
sig = sig(1:N);

% The functions
[F1]   = myfft1(sig);
[F2,c] = myfft2(sig);  
[F3]   = myfft3(sig);  
[F4]   = fft(sig);  


figure('Name','Comparision')
hold on, grid on
title('FFT-Compare')
plot(df,abs(F1),'b')
plot(df,abs(F2),'r')
plot(df,abs(F3),'k')
plot(df,abs(F4),'m')
legend('Vec-Matrix','Non-Rec','Recurse','Build-in')
hold off
%end

% Not enough df
clc
clear all
close all

f = 333;
N = 512;
fs = 700;
df = 0:fs/N:fs;
df = df(1:N);
window = blackman(N);
t = 0:1/fs:50;
sig = sin(2*pi*f*t);
sig = sig(1:N).*window';
[F4] = fft(sig); 
figure(1)
plot(df,abs(F4),'m'), grid
figure(2)
plot(df,phase(F4),'m'),grid
figure(3)
plot(F4),grid






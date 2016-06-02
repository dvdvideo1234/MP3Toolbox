function [] = fftest()
  % Tests the DFT functions
  f1 = 150;
  f2 = 800;
  f3 = 3120;

  N  = 1024;
  fs = 12000;
  win = blackman(N);
  df = 0:fs/N:fs-1;
  t  = 0:1/fs:1;
  t  = t(1:N);
  sig = sin(2*pi*f1*t) + sin(2*pi*f2*t)+ sin(2*pi*f3*t);
  sig = sig(1:N);
  sig = sig'.* win;
  
  % The functions
  [F1]   = fftRecurs(sig);
  [F2,c] = fftRadix(sig);  
  [F3]   = fftVector(sig);  
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
end

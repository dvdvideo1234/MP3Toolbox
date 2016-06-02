function F = doRecurseFFT(f)
  % The function calcolates DFT 
  % using recursive algorithm on
  % N-doted signal. This is the
  % recursive part for calcolating the DFT
  % It will work as F = doRecurseFFT(f)
  % where in f the signal array
  % and F is the DFT result 
  % Note that doRecurseFFT is part of fftRecurs !
  % Recommanded is colling the fftRecurs !
  n = length(f);  
  if (n == 1)
    F = f;
  else   
    fe = f(1:2:n);
    fo = f(2:2:n);
    X1 = doRecurseFFT(fe);
    X2 = doRecurseFFT(fo).*getVectorW(n);
    F1 = X1 + X2;
    F2 = X1 - X2;
    F = [F1 F2];
  end
end

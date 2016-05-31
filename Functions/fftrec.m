function F = fftrec(f)
  % The function calcolates DFT 
  % using recursive algorithm on
  % N-doted signal. This is the
  % recursive part for calcolating the DFT
  % It will work as F = fftrec(f)
  % where in f the signal array
  % and F is the DFT result 
  % Note that fftrec is part of myfft3 !
  % Recommanded is colling the myfft3 !
  n = length(f);  
  if (n == 1)
    F = f;
  else   
    fe = f(1:2:n);
    fo = f(2:2:n);
    X1 = fftrec(fe);
    X2 = fftrec(fo).*Wn(n);
    F1 = X1 + X2;
    F2 = X1 - X2;
    F = [F1 F2];
  end
end

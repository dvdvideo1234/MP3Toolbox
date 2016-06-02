function F = fftVector(f)
  % The function explodes
  % N-doted DFT to 2 N/2 doted
  % each iteration
  % Call it like F = fftVector(f)
  % where input is the signal array
  % and F is the DFT result
  % Example:
  % F = fftVector([1 2 3 4]')
  % 
  % F =
  %    10.0000 +  0.0000i
  %    -2.0000 +  2.0000i
  %    -2.0000 -  0.0000i
  %    -2.0000 -  2.0000i
  sz = size(f);
  if(sz(1) > sz(2))
    f = f';, ft = 1;
  else
    ft = 0;
  end
  r  = log2(max(sz));
  p  = ceil(r); 
  F  = addZeros(f); 
  N  = 2^p;
  N2 = N/2; 
  YY = -pi*sqrt(-1)/N2; 
  WW = exp(YY);  
  JJ = 0 : N2-1;  
  W  = WW.^JJ;
  for k = 1 : p-1
    u  = F(:,1:N2);
    v  = F(:,N2+1:N);
    t  = u+v;
    S  = W.*(u-v);
    F  = [t ; S];
    U  = W(:,1:2:N2);
    W  = [U ;U];
    N  = N2;
    N2 = N2/2;
  end;
  u = F(:,1);
  v = F(:,2);
  T = [u+v;u-v];
  if(ft)
     F = T;
  else
     F = T';
  end
end

function F = fftRecurs(f)
  % The function calculates DFT 
  % using recursive algorithm on
  % N-doted signal, however this is 
  % non-recursive part - the initialization.
  % The recursive part is calculating where
  % Example:
  % F = fftRecurs(f)
  %
  % F =
  %  10.0000     
  %  -2.0000 - 2.0000i
  %  -2.0000     
  %  -2.0000 + 2.0000i
  %  
  % s =
  %   1   1   2   0   1
  %   1   2   1   0  -1
  %   1   3   4   0   1
  %   1   4   3   0  -1
  %   2   1   3   0   1
  %   2   2   4   1   1
  %   2   3   1   0  -1
  %   2   4   2   1  -1
  sz = size(f);
  if(sz(1) > sz(2))
    f = f';, tf = 1;
  else
    tf = 0;
  end
   n = length(f);
   f = addZeros(f);
   F = doRecurseFFT(f);
   T = F(1:n);
   if(tf)
     F = T';
  else
     F = T;
  end
end

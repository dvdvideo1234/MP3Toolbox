function X = myfft3(f)
  % The function calculates DFT 
  % using recursive algorithm on
  % N-doted signal, however this is 
  % non-recursive part - the initialization.
  % The recursive part is calculating the DFT
  % Call it like X = myfft3(f)
  % where in f the signal array
  % and X is the DFT result 
  sz=size(f);
  if(sz(1) > sz(2))
      f = f';
      Tflag = 1;
  else
      Tflag = 0;
  end
   n = length(f);
   f = zerofil(f);
   X = fftrec(f);
   T = X(1:n);
   if(Tflag)
     X = T';
  else
     X = T;
  end
end

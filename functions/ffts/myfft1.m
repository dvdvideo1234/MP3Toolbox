function Y=myfft1(input)
  % The function explodes
  % N-doted DFT to 2 N/2 doted
  % each iteration
  % Call it like Y = myfft1(input)
  % where input is the signal array
  % and Y is the DFT result
  %  Example:
  %  myfft1([1 2 3 4])
  % 
  % ans =
  % 
  %   Columns 1 through 2
  % 
  %   10.0000            -2.0000 - 2.0000i
  % 
  %   Columns 3 through 4
  % 
  %   -2.0000            -2.0000 + 2.0000i
  sz=size(input);
  if(sz(1) > sz(2))
      input = input';
      Tflag = 1;
  else
      Tflag = 0;
  end
  r=log2(max(sz));
  p=ceil(r); 
  Y=zerofil(input); 
  N = 2^p;
  N2=N/2; 
  YY = -pi*sqrt(-1)/N2; 
  WW = exp(YY);  
  JJ = 0 : N2-1;  
  W=WW.^JJ;
  for k = 1 : p-1
    u=Y(:,1:N2);
    v=Y(:,N2+1:N);
    t=u+v;
    S=W.*(u-v);
    Y=[t ; S];
    U=W(:,1:2:N2);
    W=[U ;U];
    N=N2;
    N2=N2/2;
  end;
  u=Y(:,1);
  v=Y(:,2);
  T=[u+v;u-v];
  if(Tflag)
     Y = T;
  else
     Y = T';
  end
end

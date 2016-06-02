function [out,s] = myfft2(in) 
  % Returns same dimension as it gets
  % The function calculates DFT 
  % using well known Cooley-Turkey 
  % algorithm on N-doted signal
  % Call it like [out,s] = myfft2(in)
  % where in is the signal array, s is the
  % function grouping state
  % and out is the DFT result 
  %     Example:
  %     [y,s] = myfft2([1 2 3 4]')
  % 
  % y =
  % 
  %  10.0000     
  %  -2.0000 - 2.0000i
  %  -2.0000     
  %  -2.0000 + 2.0000i
  % 
  % 
  % s =
  % 
  %   1   1   2   0   1
  %   1   2   1   0  -1
  %   1   3   4   0   1
  %   1   4   3   0  -1
  %   2   1   3   0   1
  %   2   2   4   1   1
  %   2   3   1   0  -1
  %   2   4   2   1  -1
  sz=size(in);
  if(sz(1) > sz(2))
    in = in';
    Tflag = 1;
  else
    Tflag = 0;
  end
  s  = [];
  in = zerofil(in);
  N  = length(in);  % Points count
  N2 = floor(N/2);  % Butterflies per phase
  A  = zeros(1,N);  % Empty array to store the butterflies
  T  = zeros(1,N);  % Empty array to store the butterflies
  W  = zeros(1,N2); % Array for powers of W
  % Number of bits to apply mirnum for
  rev = getbit2(N-1); 
  for k = 1:N
    A(k) = in(mirnum(k-1,rev)+1);
  end
  % Calculates all W-s
  for k = 1:1:N2
    W(k) = exp(-pi*sqrt(-1)*(k-1)/N2);
  end
  % m - Current phase
  % k - Index in reversed array A
  % l - Index of the other butterfly wing
  % f - Index of W values
  m = 1;
  for m = 1:N2
    for k = 1:N 
      % Generation of A in phase m
      f = bitand(k-1,m-1)+1;
      if(bitand(m,k-1))
        l = k-m;
        T(k)= A(l)-W(f)*A(k);
        c = -1;
      else
        l = k+m;
        T(k)= A(k)+W(f)*A(l);
        c = 1;
      end
      s=[s;[m k l f-1 c]];
    end 
    A = T;
    m = bitshift(m,1); 
  end
  if(Tflag)
    out = A';
  else
    out = A;
  end
end

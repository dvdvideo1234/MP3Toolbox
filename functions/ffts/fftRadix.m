function [F,s] = fftRadix(f) 
  % Returns same dimension as it gets
  % The function calculates DFT 
  % using well known Cooley-Turkey 
  % algorithm on N-doted signal where:
  % f - Input signal in row ot column
  % F - DFT complex array output row ot column
  % s - The status when calcolating the butterflies
  %
  % Example: [F,s] = fftRadix(f) 
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
  f = addZeros(f); % Fill the extra zeros if not long enough
  N  = length(f);  % Points count
  N2 = floor(N/2);  % Butterflies per phase
  A  = zeros(1,N);  % Rearranged array to store the butterflies
  T  = zeros(1,N);  % Temporary array to store the butterflies
  W  = zeros(1,N2); % Array for powers of W
  % Rearrangements of the input
  rev = getBitCount(N-1); 
  for k = 1:N
    A(k) = f(mirnum(k-1,rev)+1);
  end
  % p - Current phase
  % k - Index in reversed array A
  % l - Index of the other butterfly wing
  % f - Index of W values
  m = 1 ; % Bitmask for the current phase
  s = []; % Debug status matrix 
  for p = 1:rev
    for k = 1:N 
      % Generation of T in phase p
      f = bitand(k-1,m-1);
      if(bitand(m,k-1))
        l = k - m;
        T(k)= A(l)-getW(f,2^p)*A(k);
        c = -1;
      else
        l = k + m;
        T(k)= A(k)+getW(f,2^p)*A(l);
        c = 1;
      end
      s = [s;[p m k l f c]];
    end 
    A = T;
    m = bitshift(m,1); 
  end
  if(tf)
    F = A';
  else
    F = A;
  end
end

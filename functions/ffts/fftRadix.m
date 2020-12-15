function [F, s] = fftRadix(f, b) 
  % Returns same dimension as it gets
  % The function calculates DFT 
  % using well known Cooley-Turkey 
  % algorithm on N-doted signal where:
  % f - Input signal in row or column
  % F - DFT complex array output row ot column
  % s - The status when creating the butterflies
  % b - Enable status calculation ( disabed by default )
  % Example:
  % F = fftVector([1 2 3 4]', 1)
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
    f = f'; tf = 1;
  else % Output row/column when input is row/column
    tf = 0;
  end
  if(nargin < 2)
    b = 0; % The status caculation is disabled by default
  end
  Z = addZeros(f); % Fill the extra zeros if not long enough
  N = length(Z);  % Points count on a matter of power two
  A = zeros(1,N);  % Rearranged array to store the butterflies
  T = zeros(1,N);  % Temporary array to store the butterflies
  R = getBitCount(N - 1); % Rearrangements of the input
  for k = 1:N
    A(k) = Z(mirrorBits(k - 1, R) + 1);
  end
  % r - Current phase for the data length
  % v - Index in reversed array A
  % u - Index of the other butterfly wing
  % f - Index of W values
  m = 1; % Bitmask for the current phase
  s = []; % Debug status matrix 
  for r = 1:R
    for v = 1:N 
      % Generation of T in phase p
      f = bitand(v-1, m-1);
      if(bitand(m, v-1))
        c = -1; u = v + c * m;
        T(v)= A(u) + c * getW(f, 2^r) * A(v);
      else
        c =  1; u = v + c * m;
        T(v)= A(v) + c * getW(f, 2^r) * A(u);
      end
      if(b)
        s = [s; [r m v u f c]];
      end
    end 
    A = T;
    m = bitshift(m, 1); 
  end
  if(tf)
    F = A';
  else % Output row/column when input is row/column
    F = A;
  end
end

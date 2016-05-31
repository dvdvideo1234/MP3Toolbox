function [fpow]=getfpow(ind,valbit)
  % Calcolates index in an array for Wn prime factor
  % with bitwise ops
  % Example:
  % getfpow(5,4)
  % 
  % ans =
  % 
  %   2
  if(valbit == 1), fpow = 1; 
  else
    fpow = bitand(ind,valbit-1)+1;
  end
end

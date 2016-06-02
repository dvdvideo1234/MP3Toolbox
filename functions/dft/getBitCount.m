function [out] = getBitCount(num)
  % Calcs how many bits are needed to 
  % present a number in 2-digit notation
  % Example 1:
  %   getbit2(4)
  %   ans = 3
  % Example 2:
  %   getbitcnt(11)
  %   ans = 4
  if(num <= 0)
    out = 1; 
  else
    out = floor(log2(num))+1;
  end
  return;
end

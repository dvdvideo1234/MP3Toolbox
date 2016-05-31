function out = getW(n,N2)
  % Calcolates Wn prime factor first arg is power
  % n secon one is number of dots N2.
  % Example:
  % > getW(3,8)
  % 
  % ans =
  % 
  %  0.3827 - 0.9239i
  out = exp((-sqrt(-1)*pi*n)/N2);
end

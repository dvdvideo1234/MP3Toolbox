function out = getW(k,n)
  % Calcolates Wn prime factor where:
  % k - The power of the prime factor 
  % n - The number of dots per phase
  % Example: out = getW(k,n)
  % > getW(3,8)
  % 
  % ans =
  % 
  %  -0.70711 - 0.70711i
  out = exp((-2*pi*sqrt(-1)*k)/n);
  return;
end

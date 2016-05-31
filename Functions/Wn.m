function W = Wn(n)
  % Calcolates Wn in vector-row-array
  % Example:
  % n = 4;
  % W = Wn(n)
  % W = [1 -i];
  n2 = n/2;
  W = exp(-2*pi*j.*[0:1:n2-1]/n);
end

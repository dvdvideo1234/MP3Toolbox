function out = addZeros(in)
  % Fills an array with needed number of zeros, so
  % that lenght(Array) = power of 2
  % Example:
  % in = [1 2 3 4 5];
  % out = addZeros(in);
  % out = [1 2 3 4 5 0 0 0];
  l = length(in);
  if(bitand(l-1,l) == 0), out = in; return; end
  pwr = floor(log2(l))+1;
  adl = 2^pwr-l;
  out = [in zeros(1,adl)];
  return;
end

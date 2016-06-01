function out = zerofil(in)
  % Fills an array with needed number of zeros, so
  % that lenght(Array) = power of 2
  % Example:
  % in = [1 2 3 4 5];
  % out = zerofil(in);
  % out = [1 2 3 4 5 0 0 0];
  l = length(in);
  if(bitand(l-1,l) == 0), out = in; return; end
  pw = floor(log2(l))+1;
  adl=2^pw-l;
  out = [in zeros(1,adl)];
end

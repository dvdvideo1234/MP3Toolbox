function out = bits2int(arr)
  % Conwerts from 2 digit notation to 10 digit
  % Example:
  % bits2int([1 1 0])
  % 
  % ans =
  % 
  % 6
  sz=size(arr);
  tmp=[0];
    for i=sz(2):-1:1
      tmp = tmp + arr(i)*2^(sz(2)-i); 
    end
  out = tmp;
end

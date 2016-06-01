function bitlen = GetBitLen(num)
  % Calcolates how to present a number in 2-digit notation
  % Example:
  % GetBitLen(5)
  % 
  % ans =
  % 
  %   1   0   1
  % 
  % GetBitLen(10)
  % 
  % ans =
  % 
  %   1   0   1   0
  rest = num;
  bitlen = [];
  while(rest > 0.5)
    bitlen = [bitlen, mod(rest,2)];
    rest = floor(rest/2);
  end
  bitlen = swaparr(bitlen,1);
end

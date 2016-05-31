function [out] = mirrornum(in,l)
  % Mirrorizes a number in "l" bits
  % [1 1 0] --> [0 1 1]
  % [1 0 1] --> [1 0 1]
  % [0 0 1] --> [1 0 0]
  % Example:
  % mirrornum(3,3)
  % ans = 6 ( 3 --> [0 1 1] <> [1 1 0] --> 6 )
  if(in == 0) 
    out = 0; 
  else 
  bits=int2bits(in,l);
  bits=swaparr(bits,1);
  out=bits2int(bits);
  end
end

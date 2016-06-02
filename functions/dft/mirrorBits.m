function [out] = mirrorBits(num,b)
  % Mirrorizes a number in "b" bits, 
  % using bitwise operations
  % [1 1 0] --> [0 1 1]
  % [1 0 1] --> [1 0 1]
  % [0 0 1] --> [1 0 0]
  % Example:
  % mirnum2(3,3)
  % ans = 6 ( 3 --> [0 1 1] <> [1 1 0] --> 6 )
  if(num == 0) 
    out = 0;
    return;
  else 
    t = 0;
    n = num;
    for k = 1:b
      t = bitshift(t,1);
      t = bitor(t,bitand(n,1));
      n = bitshift(n,-1);
    end
    out = t;
  end
  return;
end

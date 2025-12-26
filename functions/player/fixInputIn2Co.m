function [in] = fixInputIn2Co(in)
  % Fixes matrix to "n x 2"
  % n is the length of in
  sz = size(in);
  if(sz(1) < sz(2))
    in = in';
  end
  if(min(sz) == 1)
    in = [in,in];
  elseif(min(sz) > 2)
    in = in(:,1:2);
  end
  return;
end

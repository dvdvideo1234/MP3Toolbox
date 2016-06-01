function out = add1arr(in) 
  %Add 1 to a number in 2-bit notation presented by an array
  %If there is a carry increments the nimber of bits
  % Example:
  % >> add1arr([1 0 0])
  % 
  % ans =
  % 
  %   1   0   1
  % >> add1arr([1 1 1])
  % 
  % ans =
  % 
  %   1   0   0   0
  sz=size(in);
  tmp=in;
  ind=sz(2);
  if(sum(in) == length(in))
    tmp = zeros(1,sz(2)+1);
    tmp(1)=1;
    out=tmp;
  else
    for i=sz(2):-1:1
      if((in(i) == 0) && (i == sz(2)))
        tmp(i)=1;
        break;
      elseif((in(i) == 0) && (in(i+1) == 1))
        ind =i;
        break;
      end
    end
    if(ind ~= 1)
      tmp(ind)=1;
      for i=(ind+1):1:sz(2)
        tmp(i) = 0;
      end
    end
  end
  out = tmp;
end


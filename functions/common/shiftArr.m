function Out = shiftArr(In,How)
  % Right + by rows
  % Left - by rows
  % Shifts s column left-right
  % Example 1: 
  % shiftArr([1 2;3 4],-1)
  % 
  % ans =
  %   2   0
  %   4   0
  %
  % Example 2:
  % shiftArr([1 2;3 4],1)
  % 
  % ans =
  %   0   1
  %   0   3
  ab = abs(How);
  sz = size(In);
  for k = 1:1:sz(1) % row
    if (How < 0) 
      for i=1:1:sz(2) % col
        if(i<(sz(2)-ab+1))
          g=i+ab;
          Out(k,i)=In(k,g);
        else
          Out(k,i)=0;
        end
      end 
    else
      for i=sz(2):-1:1 % col
        if(i>ab)
          g=i-ab;
          Out(k,i)=In(k,g);
        else
          Out(k,i)=0;
        end
      end
    end
  end
end

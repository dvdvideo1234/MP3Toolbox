function arr = int2bits(in,l)
% Converst a number in a 2 state
% notation 
% Example:
% >> int2bits(6,3)
% ( number 6 in 3 bits )
% ans =
% 
%      1     1     0
     in2=in;
     len = floor(log2(abs(in2)))+1;
     tmp=zeros(1,l);
     if(in>0)
         for x=1:1:len
             in2=in2/2;
             rest = in2-floor(in2);
             if(rest ~= 0)
                tmp(len-x+1)=1;
             else
                tmp(len-x+1)=0;
             end
             in2 = floor(in2);
         end
     elseif(in<0)
         in2=abs(in2);
         for x=1:1:len
             in2=in2/2;
             rest = in2-floor(in2);
             if(rest ~= 0)
                tmp(len-x+1)=1;
             else
                tmp(len-x+1)=0;
             end
             in2 = floor(in2);
         end   
         tmp=xor(tmp,1);
         tmp = add1arr(tmp);
     else
         tmp=zeros(1,l);
     end
     arr = shiftArr(tmp,l-len);
end











function [mant,step,time] = myfact(in)
  % Calcolates Factoriel of a number
  % Example: 
  % [m,s,t]=myfact(10)
  % 
  % m =
  % 
  %   3.6288
  % 
  % s =
  % 
  %   0   0   0   0   0   0   0   6
  % 
  % t =
  % 
  %   0.0312  320.5108
  max=1e+290;
  time=[0 0];
  step = [0 0 0 0 0 0 0 0];
  num=1;
  mant = 0; 
  t=cputime;
    for i=1:1:in  
      if(num>max)
        lognum=log10(num);
        mant=mant+lognum;
        lognum=floor(mant);
        mant= mant-lognum;  
        step(8) = step(8)+lognum;
        for k=8:-1:1
          if(step(k)>999)
            step(k)=step(k)-1000;
            step(k-1)=step(k-1)+1;
            if(step(k-1)<=999) break;
            end
          end
        end
        num=1;
      end
      num=num*i;
    end
  if(num~=1)
    lognum=log10(num);
    mant=mant+lognum;
    lognum=floor(mant);
    mant= mant-lognum;  
    step(8) = step(8)+lognum;
    for k=8:-1:1
      if(step(k)>999)
        step(k)=step(k)-1000;
        step(k-1)=step(k-1)+1;
        if(step(k-1)<=999) break;
        end
      end
    end
    num=1;
  end
  mant=10^mant;
  time(1) = (cputime -t);
  if(time(1)~=0) time(2) = in/time(1); end
end

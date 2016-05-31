function [arg I] = Findarg(fname,Tar,Low,Hig,de)
  I = 60;
  Dir = feval(fname,Low) - feval(fname,Hig);
  if(Dir >= 0)
    while(I)  
    Mid = (Hig + Low)/2;
    Err = Tar - feval(fname,Mid);
    if(abs(Err) < de), break; end
    if(Err > 0)
      Hig = Mid;
    else
      Low = Mid;
    end
    I = I - 1;
    end
  else
    while(I)  
      Mid = (Hig + Low)/2;
      Err = Tar - feval(fname,Mid);
      if(abs(Err) < de), break; end
      if(Err < 0)      
        Hig = Mid;
      else
        Low = Mid;
      end
      I = I - 1;
    end
  end
  arg = (Hig + Low)/2;
end

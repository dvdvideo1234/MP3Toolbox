function [out] = toLenofN(in,way,len)
  % 57 len per row
  % Max len 'G:\MP3\test\Katy Perry - 2010 - Teenage Dream\08 E.T..mp3 sth.'
  %         
  % way =0+ '..test\Katy Perry - 2010 - Teenage Dream\08 E.T..mp3 sth.'
  % way =-  'G:\MP3\test\Katy Perry - 2010 - Teenage Dream\08 E.T..m..'
  out = '..';
  m = length(in);
  r = m-len;
  lo = length(out);
  if(r <= -length(out))
    out = in;
    return;
  end
  if(way >= 0)
    out = strcat(out,in((r+lo+1):m));
  elseif(way < 0)
    out = strcat(in(1:(m-lo-r)),out);
  end
  return;
end

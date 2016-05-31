function out = slashstringn(path,len)
  % Len > 0 -> Get "len" to max symbols of path after slash
  % Len = 0 -> Slash location
  % Len < 0 -> Gets file directory
  slash = length(path); 
  while(path(slash) ~= '\')
    slash = slash-1;
    if(slash == 0) break; end
  end
  lp = length(path);
  if(len > 0)
    if(lp-slash < len) out = path(slash+1:lp);
    else out = path(slash+1:slash+len);
    end return;
  elseif(len == 0)
    out = slash; return;
  elseif(len < 0)
    out = path(1:slash); return;
  end
end

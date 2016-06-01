function [out] = getNextValidID(pl,id,mod)
  % Gets the id of the next valid file in the playlist 
  st = 0; % Step for the 
  cr = 0; % The curren item id selected
  fl = 10; % Maxtimum number of loops no a missing file
  sz = size(pl);
  ln = length(pl);
  % Apply selection mode
  if(strcmp(mod,'seq'))
    st = 1;
  elseif(strcmp(mod,'rnd'))
    st = floor((rand(1,1) * ln));
  else
    display('Item id selection mode invalid !!!');
    out = 1;
    return;
  end
  % Find the next item
  cr = id + st;
  % If it is outside of the playlist
  if(cr > ln)
    cr = cr - ln;
  end
  % Getting a valid file
  while(~exist(pl{cr},'file') && (fl > 0))
    cr = cr + st;
    if(cr > ln)
      cr = cr - ln;
      fl = fl - 1;
    end
    display(strcat('Skipping [',num2str(item),']:',pl{item}));
  end
  out = cr;
end

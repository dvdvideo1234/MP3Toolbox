function [id] = selectAlgorithm(algSel)
  % Selects and borders the alogorithm to be used
  % for a given cell array
  lenalg = length(algSel.Alg);
  lentop = length(num2str(algSel.Siz));
  display(strcat('Select an algorithm for [',algSel.Inf,']:'));
  for i = 1:lenalg
    padi = num2str(i);
    for k = 1:(lentop - length(padi))
      padi = sprintf('%s%s', ' ', padi);
    end
    display(sprintf('[%s] > %s', padi, algSel.Alg{i}{2}));
  end
  sid = input(sprintf('Method ID:[%s] [%s] >> ', num2str(algSel.Cur), algSel.Alg{algSel.Cur}{2}),'s');
  sid = strtrim(sid);
  nid = str2double(sid);
  if(isnan(nid))
    if(length(sid) > 0)
      display(strcat('ID [',sid,'] is invalid'));
    end
    id = algSel.Cur;
  elseif((nid < 1) || (nid > lenalg))
    display(strcat('ID [',sid,'] not in bounds [1..',num2str(lenalg),']'));
    id = algSel.Cur;
  else
    nid = floor(nid);
    id = nid;
  end
  return;
end

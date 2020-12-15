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
  user = input(sprintf('Method ID:[%s] [%s] >> ', num2str(algSel.Cur), algSel.Alg{algSel.Cur}{2}),'s');
  user = str2double(user);
  if(isnan(user))
    display(strcat('ID [',num2str(user),'] is invalid'));
    id = algSel.Cur;
    return;
  elseif((user < 1) || (user > lenalg))
    display(strcat('ID [',num2str(user),'] not in bounds [1..',num2str(lenalg),']'));
    id = algSel.Cur;
    return;
  else
    user = floor(user);
    id = user;
  end
  return;
end

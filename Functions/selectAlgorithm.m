function [aid] = selectAlgorithm(algSelector)
  % Selects and borders the alogorithm to be used
  % for a given cell array
  lenalg = length(algSelector.Alg);
  display(strcat('Select an algorithm for [',algSelector.Inf,']:'));
  for i = 1:lenalg
    display(strcat('ID [',num2str(i),'] : ',algSelector.Alg{i}{2}));
  end
  user = input('Method ID:','s');
  user = floor(str2double(user));
  if(isnan(user) || (user < 1) || (user > lenalg))
    display(strcat('ID [',num2str(user),'] is invalid'));
  else
    aid = user;
  end
end

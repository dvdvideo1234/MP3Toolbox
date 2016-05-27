function fig = getNextFigure()
% Returns the top free figure handle to be opened
  if(isempty(get(0,'CurrentFigure')))
    fig = 1;
  else
    fig = max(get(0,'Children')) + 1;
  end
end
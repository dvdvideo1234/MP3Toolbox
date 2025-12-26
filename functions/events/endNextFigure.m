function endNextFigure(fig)
  % Closes the top figure opened
  if(sum(fig*ones(size(get(0,'Children'))) == get(0,'Children'))), close(fig), end
end

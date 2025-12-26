function keyPressEscapeClose(fig, event)
  if isequal(event.Key, 'escape')
    close(fig);
  end
end
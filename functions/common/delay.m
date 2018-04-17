function out = delay(len)
  % Cycles a number of times as the value in the len parameter
  % Example:
  % delay(100)
  % 
  % ans =
  % 
  % -1
  while(len)
    len = len - 1;
  end
  out = len
end

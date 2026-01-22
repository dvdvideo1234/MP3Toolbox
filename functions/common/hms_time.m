function [h, m, s] = hms_time(sec)
  % Extract hour, minute, seconds from seconds count
  %
  %  [h, m, s] = hms_time(sec)
  %  
  h = floor(sec / 3600);
  m = floor(mod(sec, 3600) / 60);
  s = mod(sec, 60);
end

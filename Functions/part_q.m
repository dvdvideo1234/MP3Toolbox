function [part] = part_q(percent,number)
  % Calcolates a percent of a number and returns 
  % the numberlike so
  % Example:
  % part_q(60,120)
  % 
  % ans =
  % 
  %     72
  part=(percent/100)*number;
end

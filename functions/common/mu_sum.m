function [sum] = mu_sum(arr,n,num)
  % Calcs the sum of an array based on a number
  % Example:
  % mu_sum([1 2 3],2,5)
  % 
  % ans =
  % 
  %      7
  sum=0;
   for i=1:n
     sum=(sum*(num))+arr(i);
   end
end

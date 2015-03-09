function ind = find_infl(arr,order)
% Finds an index of an inflex or max/min-s
% in a function presented by an array
% Returns the array of indexes
% Example 1:
% arr=[0 1 2 3 2 1 0 -1 -2 -3 -2 -1 0];
% find_infl(arr,1)
% 
% ans =
% 
%      4    10
% Example 2:
% arr=[0 1 2 3 2 1 0 -1 -2 -3 -2 -1 0];
% find_infl(arr,2)
% 
% ans =
% 
%      4     5    10    11
dif=diff(arr,order);
ind=[];
k=1;
for i=2:1:length(dif)
    if(sign(dif(i)) ~= sign(dif(i-1)))
        if((abs(dif(i)) > abs(dif(i-1))) && ((dif(1)-dif(i-1)<0)))
            ind(k)=i;
        else
            ind(k)=i+order-1;
        end
        k = k+1;
    else
        continue;
    end 
    
    
end
if(length(ind) == 0)
    ind(1)=1;
end


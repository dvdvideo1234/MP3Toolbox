function [sind] = lastslash(string) 
% Finds index on the right of the last
% slash in an array
% Example:
% lastslash('as\gh')
% 
% ans =
% 
%      4
    l=numel(string);
    for i=l:-1:1
        if(string(i) == '\')
            sind=i+1;
            break;
        end
    end  
end
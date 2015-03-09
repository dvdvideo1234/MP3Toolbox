function [Out] = getbit2(Num)
% Calcs how many bits are needed to 
% present a number in 2-digit notation
% Example 1:
% getbit2(4)
% 
% ans =
% 
%      3
% Example 2:
% getbit2(11)
% 
% ans =
% 
%      4
    if(Num <= 0)
        Out = 1; 
    else
        Out = floor(log2(Num))+1;
    end
end
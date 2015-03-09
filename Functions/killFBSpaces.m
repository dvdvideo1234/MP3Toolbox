function [out] = killFBSpaces(in)
% Kills leading and tailing spaces in a string
% Example:
%         killFBSpaces('     D:\Matlab\toolbox\mp3toolbox     ')
% ans = 
%         'D:\Matlab\toolbox\mp3toolbox'
b = length(in);
f = 1;
while(1)
    if(in(f) == ' ')
        f = f + 1;
    end
    if(in(b) == ' ')
        b = b - 1;
    end
    if((in(f) ~= ' ') && (in(b) ~= ' '))
        break;
    end
end
out = in(f:b);
end
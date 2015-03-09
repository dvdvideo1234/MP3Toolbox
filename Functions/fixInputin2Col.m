function [in] = fixInputin2Col(in)
% Fixes matrix to "n x 2"
% n is the length of in
    sz = size(in);
    if(min(sz) == 1)
        in = [in,in];
        return;
    elseif(min(sz) > 2)
        in = in(:,1:2);
        return
    end
end
function out = swaparr(in,mode)
% For cols mode = 2
% For rows mode = 1

sz=size(in);
    if(mode == 1)
        for i=1:1:sz(1)     % rows mode 
            for k=1:1:sz(2) % cols mode
                out(i,k)=in(i,sz(2)-k+1);
            end
        end
    elseif(mode == 2)
        for i=1:1:sz(2)     % rows mode
            for k=1:1:sz(1) % cols mode
                out(k,i)=in(sz(1)-k+1,i);
            end
        end
    end
end
function [flag] = isMp3Format(path)
% Walidates an MP3 file
    plen = length(path);
    if(~strcmp(path((plen-3):plen),'.mp3'))
        path = strcat(path,'.mp3');
    end
    if(strcmp(slashstringn(path,100),path))
        path = strcat(cd,'\',path);
    end
    if(exist(path,'file'))
        % If extension is *.mp3
        try
        y = mp3read(path);
        catch err;
            if(~isempty(err.message))
                flag = 0;
                return;
            end
        end
        clear y;
        flag = 1;
        return;
    else
        % If extension is not *.mp3
        flag = 0;
        return;
    end
end
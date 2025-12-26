function [out] = fullPathMP3(in)
  % Normalizes the path to be used ferther
  % For the example the current dir is "D:\test"
  % "test"                --> D:\test\test.mp3
  % "F:\samples\test"     --> F:\samples\test.mp3
  % "F:\samples\test.mp3" --> F:\samples\test.mp3
  path = in;
  lenp = length(path);
  % Add ".mp3 if not present"
  if(~strcmp(path((lenp-3):lenp),'.mp3'))
    path = strcat(path,'.mp3');
  end
  stat = exist(strcat(cd,'\',path), 'file');
  if(stat == 2) % Is it a workspace path
    out = strcat(cd,'\',path);
  else % It is a full path
    stat = exist(path, 'file');
    if(stat == 2) % Full path
      out = path;
    else
      out = '';
    end
  end
end

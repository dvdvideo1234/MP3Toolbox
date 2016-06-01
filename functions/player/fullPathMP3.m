function [out] = fullPathMP3(in)
  % Normalizes the path to be used ferther
  % For the example the current dis is "D:\test"
  % "test"                --> D:\test\test.mp3
  % "F:\samples\test"     --> F:\samples\test.mp3
  % "F:\samples\test.mp3" --> F:\samples\test.mp3
  path = in;
  lenp = length(path)
  % Add ".mp3 if not present"
  if(~strcmp(path((lenp-3):lenp),'.mp3'))
    path = strcat(path,'.mp3');
    lenp = lenp + 4;
  end
  % Add "cd" to the "file.mp3"
  if(strcmp(slashstringn(path,lenp),path))
    path = strcat(cd,'\',path);
  end
  out = path;
end

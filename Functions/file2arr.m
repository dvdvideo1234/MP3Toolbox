function arr = file2arr(FILE) 
%     Convert a file to an array
%     Sintax: arr = file2arr(FILE)
  fid = fopen(FILE); 
  arr = fread(fid,Inf,'*uint8'); % Read in byte stream of MP3 file 
  fclose(fid);
end
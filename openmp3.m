function [] = openmp3(path_mp3)
  %Just type in the Matlab command line "openmp3("HERE STAyS PATH TO THE FILE")"
  %Prototype in c++ :
  %                     void openmp3(char *file_path_including_name)
  %
  % Works also with Drag-Drop file to the ML command window and duble click
  % in the current directory on the *.mp3  file.
  % 
  % Example: 
  % These calls are the same, where "path_mp3" is "D:/music/test/test.mp3"
  %
  %  1: openmp3('D:/music/test/test.mp3') reg. "path_mp3" value target item
  %  2: openmp3('test.mp3'), note that "test.mp3" is in the current folder
  %  3: openmp3('test')    , note that "test.mp3" is in the current folder
  %  and *.mp3 extension is added at the end automatically
  %
  % This function uses "mp3raead()" I didn't make "mp3raead()", it was made
  % by Alfredo Fernandez.  I only made the player itself, so you can open
  % *.mp3 files for listening them
  %   This code has a menu for
  %   1) "seek"      - Seek the file in percents
  %   2) "rate"      - Changing sampling rate of the audio player
  %   3) "p","r","s" - Pause Resume and Stop the processing
  %   4) "o"         - Open another file
  %   5) "v"         - Open viewing options
  %    "p" - Plot the signal and DFT
  %    "m" - Mesh the signal and DFT  
  %    "s" - Surf the signal and DFT
  %    "w" - Waterfall the signal and DFT
  %   6) "info"  - Audioplayer information
  %   7) "clc"   - Clear screen
  %   8) "dir"   - View current workspace directory
  %   9) "plist" - Playlist
  %    "add" - Adds a file for processing
  %    "rem" - Removes a file from playlist
  %    "sel" - Selects a file for processing
  %  10) "help" - Displays ferther command help
  % PLAyER made by dvd_video
  clc
  %Kill spaces
  path_mp3 = killFBSpaces(path_mp3);
  % Add ".mp3 if not present"
  if(~strcmp(path_mp3((length(path_mp3)-3):length(path_mp3)),'.mp3'))
    path_mp3 = strcat(path_mp3,'.mp3');
  end
  % Add current dir prefix to the "file.mp3" in current dir
  if(strcmp(slashstringn(path_mp3,100),path_mp3))
    path_mp3 = strcat(cd,'\',path_mp3);
  end
  if(isMp3Format(path_mp3))
    playlist{1} = path_mp3;
    [y,fs,nbits,opts] = mp3read(playlist{1});
    y = fixInputin2Col(y);
  else
    disp('Atleast first open file should be valid !!!')
    return;
  end
  dev = audiodevinfo;
  devnum=length(dev.output);
  DevID = zeros(devnum,1);
  for i =1:devnum
    fprintf('\nDeviceID %s : "%s" ver %s',num2str(dev.output(i).ID),dev.output(i).Name,num2str...
    (dev.output(i).DriverVersion));
    DevID(i,1) = dev.output(i).ID;
  end
  disp(' ');
  while(1)
    tempch=input('Device ID? >>','s');
    tempch = fix(str2double(tempch));
    if(ValuePersistInArray(tempch,DevID)) 
         DevID = (tempch == DevID)'*DevID;
    end
    if(length(DevID) == 1), break; end
    if(strcmp(tempch,'q')), return; end
  end

  def_fs = fs;
  nplay = slashstringn(path_mp3,100);
  clc   
  mp3 = audioplayer(y,fs,nbits,DevID);
  stop(mp3)
  if(length(nplay) >= 19) mp3.tag = nplay(1:19);
  else mp3.tag = nplay; end
  dispMp3Info(opts,mp3);

  keep('mp3','tempch','y','fs','def_fs','path_mp3','playlist','DevID','opts') 
  play(mp3);

  while(1)
  keep('mp3','tempch','y','fs','def_fs','path_mp3','playlist','DevID','opts')

  if(mp3.CurrentSample > (mp3.TotalSamples - fs))
    stop(mp3);
    clc
    sz = size(playlist);
    % Next item
    for items = 1:1:sz(1)
      if(strcmp(playlist{items},path_mp3))
        items = items + 1;
        break;
      end
    end
    % Playlist end
    if(strcmp(playlist{length(playlist)},path_mp3))
      item = 1;
    end
    %Getting valid file
    while(~exist(playlist{item},'file'))
      item = item + 1;
      if(item > length(playlist)) item = 1; end
    end
    path_mp3 = playlist{item};
          
    %Load data
    [y,fs,nbits,opts] = mp3read(path_mp3);
    y = fixInputin2Col(y);
    def_fs = fs;
    nplay = slashstringn(path_mp3,100);
    clc   
    mp3 = audioplayer(y,fs,nbits,DevID);
    mp3.tag = nplay;
    dispMp3Info(opts,mp3);
    play(mp3);
    continue;
  else
    % Needs waiting for a key
    % Ako tragna da pi6a da 4aka ima4e da produlgi ...
    tempch=input('Command >>','s');
    switch tempch
    case 'p', pause(mp3);
    case 'rate', ch_fs  = num2str(mp3.SampleRate);
                 ch_fs  = strcat('Command >> Rate = ',ch_fs,' >>');
                 tempch = input(ch_fs,'s');
      switch tempch 
        case 'd', pause(mp3); mp3.SampleRate=def_fs; resume(mp3);   
        case 'b', continue;
        otherwise
          if(str2double(tempch) ~= 0)
            tempch=str2double(tempch);
            if(((tempch > 0) && (mp3.SampleRate+tempch < 1000000))...
              || ((tempch < 0) && (mp3.SampleRate+tempch > 0)))
              mp3rate(mp3,tempch)
            end  
          end   
       end
     case 'seek'
       seek = percent_q(mp3.CurrentSample,mp3.TotalSamples);
       ch_fs=num2str(seek);
       ch_fs=strcat('Command >> Seek >',ch_fs,'%<',' >>');
       tempch=input(ch_fs,'s');
       sk = part_q(str2double(tempch),mp3.TotalSamples); 
       switch tempch
         case 'b', continue; 
         case 'first',
           stop(mp3);
           play(mp3,[2 mp3.TotalSamples]);
         case 'last',
           stop(mp3);
           play(mp3,[mp3.TotalSamples mp3.TotalSamples]);
         otherwise
           if(isnan(str2double(tempch))),continue; end
           stop(mp3);
           play(mp3,[uint64(sk) mp3.TotalSamples]);
       end
    case 'v', tempch=input('Command >> View >>','s');
      switch tempch
        case 'p', drawCurveDFT  (@plot     , mp3, y, 40, 2048, 'DFT graph')
        case 'w', drawSurfaceDFT(@waterfall, mp3, y, 40, 128 , 6 , 'DFT Waterfall graph');
        case 'm', drawSurfaceDFT(@mesh     , mp3, y, 40, 128 , 10, 'DFT Mesh graph');
        case 's', drawSurfaceDFT(@surf     , mp3, y, 40, 512 , 15, 'DFT Surface graph');
        case 'b', continue;
        case 'cmd', display({
                'b - Back';...
                'p - Plot signal and DFT';...
                'w - Plot the signal and waterfall the DFT';...
                'm - Plot the signal and mesh the DFT';
                's - Plot the signal and surface the DFT'});
        otherwise , disp('Wrong command');
      end
    case 's'   , stop(mp3);
    case 'clc' , clc;
    case 'info', disp(mp3);
    case 'dir' , dir(path_mp3(1:slashstringn(path_mp3,0)));
    case 'r'   , resume(mp3);
    case 'help', display({'p - Pause';'r - Resume';'s - Stop';'q - Quit';'o - Open a file';'seek - Seek(Put a percent)';'clc - Clear screen';...
         'info - Display object';'dir - View directory';'plist - Paylist';'add,rem(ove),sel(ect),info';...
         'v - view the signal';'p(lot),w(aterfall),s(urf),m(esh)';'help - Displays this info'});
    case 'plist', tempch=input('Command >> PlayList >>','s');
      switch tempch
        case 'add', tempch=input('Command >> PlayList >> Add >>','s');
          % Kill the spaces
          tempch = killFBSpaces(tempch);
          % Add ".mp3 if not present"
          if(~strcmp(tempch((length(tempch)-3):length(tempch)),'.mp3'))
               tempch = strcat(tempch,'.mp3');
           end
          % Add "path_mp3" prefix directory to the "file.mp3"
          if(strcmp(slashstringn(tempch,100),tempch))
            tempch = strcat(slashstringn(path_mp3,-1),tempch);
          end
          % add to playlist if Valid
          % 1-st path_mp3
          % 2-nd cd
          
          if(isMp3Format(tempch)) 
            playlist = {playlist{:,1},tempch}'; 
          else
            tempch = strcat(cd,'\',slashstringn(tempch,100));
            if(isMp3Format(tempch)) 
              playlist = {playlist{:,1},tempch}'; 
            else
              disp('This is not in the current path directory !!!')
            end   
          end
        case 'rem', tempch=input('Command >> PlayList >> Rem >>','s');
          % setdiff
          item = floor(str2double(tempch));
          if(~(isnan(item) || (item < 1) ||...
            (item > length(playlist)) || strcmp(playlist(item),path_mp3)))
            % Delete the last element
            playlist(item) = [];
          end   
        case 'sel', tempch=input('Command >> PlayList >> Sel >>','s');
          item = floor(str2double(tempch));
          % Valid item number in the playlist
          if(~(isnan(item) || (item < 1) || (item > length(playlist))))
            % Skip to the closest Valid file ...
            % Getting valid file
            while(~exist(playlist{item},'file'))
              item = item + 1;
              if(item > length(playlist)) item = 1; end
            end
            stop(mp3);
            path_mp3 = playlist{item};
            [y,fs,nbits,opts] = mp3read(path_mp3);
            y = fixInputin2Col(y);
            mp3 = audioplayer(y,fs,nbits,DevID);
            mp3.tag = slashstringn(path_mp3,40);
            clc
            dispMp3Info(opts,mp3);
            play(mp3);
          end
        case 'info', clc, 
          for i = 1:length(playlist)
              fprintf('\n%s:  %s',strcat(num2str(i)),toLenofN(playlist{i},1,80));
          end
          disp(' ');
       end
    case 'o',
      pause(mp3);   
      tempch=input('Command >> OpenFile >>','s');
      if(tempch == 'b')
        resume(mp3);
        continue;
      elseif(~isempty(tempch))
        % Add ".mp3 if not present"
        if(~strcmp(tempch((length(tempch)-3):length(tempch)),'.mp3'))
          tempch = strcat(tempch,'.mp3');
        end
        % Add "cd" to the "file.mp3"
        if(strcmp(slashstringn(tempch,100),tempch))
          tempch = strcat(cd,'\',tempch);
        end
        % add to playlist if Valid
        if(exist(tempch,'file')) 
          stop(mp3);
          keep('tempch','path_mp3')
          openmp3(tempch); 
          break;
        end
        if(~exist(tempch,'file'))
          display('File not Found');
          resume(mp3);
          continue;
        end
      end
    case 'q',
      stop(mp3);
      clear all
      break; 
    end    
  end
end

  


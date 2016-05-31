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
  % *.mp3 files for listening them and experimenting with different DFT
  % algorithms and plotters in real time
  %   This code has a menu for
  %   1) "seek"      - Seek the file in percents
  %   2) "rate"      - Changing sampling rate of the audio player
  %   3) "p","r","s" - Pause Resume and Stop the processing
  %   4) "o"         - Open another file
  %   5) "v" - Open viewing options
  %      "c" - Plot the signal and DFT with the 2D graph selected
  %      "s" - Mesh the signal and DFT with the 3D graph selected
  %      "dft" - Selects a different DFT algorithm to be used
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
  % Load DFT algorithms
  DFT.Calc.Cur = 1;
  DFT.Calc.Inf = 'DFT calculator';
  DFT.Calc.Alg = {
    { @fft   , 'Default integrated'              }
    { @myfft1, 'Vector-Matrix iterative'        }
    { @myfft2, 'Coukey-Turkey from the textbook' }
    { @myfft3, 'Recursive using odd and even'    }
  };
  % Load 3D plots ( Size of the window, Points count, Memorized DFT count, Label )
  DFT.Plot3D.Cur = 1; % The current selected plotter
  DFT.Plot3D.Inf = '3D plotter';
  DFT.Plot3D.Alg =  {
    { @surf     , 'Surface graph'  , 40, 512 , 15 }
    { @mesh     , 'Mesh graph'     , 40, 128 , 10 }
    { @waterfall, 'Waterfall graph', 40, 128 , 6  }
  };
  % Load 2D plots ( Size of the window, Points count, Label )
  DFT.Plot2D.Cur = 1; % The current selected plotter
  DFT.Plot2D.Inf = '2D plotter';
  DFT.Plot2D.Alg = {
    { @plot, 'Plot graph', 40, 2048 }
  };
  DFT.Object = 0;
  DFT.Path = path_mp3;
  DFT.SampleRate = 0;
  DFT.SampleRateDefault = 0;
  DFT.Signal = [];
  DFT.SampleBits = 0;
  DFT.UserInput = '';
  DFT.Devices = audiodevinfo;
  DFT.DeviceID = 0;
  DFT.PlayList = {};
  DFT.Format = {};

  %Kill spaces
  DFT.Path = killFBSpaces(DFT.Path);
  % Add ".mp3 if not present"
  if(~strcmp(DFT.Path((length(DFT.Path)-3):length(DFT.Path)),'.mp3'))
    DFT.Path = strcat(DFT.Path,'.mp3');
  end
  % Add current dir prefix to the "file.mp3" in current dir
  if(strcmp(slashstringn(DFT.Path,100),DFT.Path))
    DFT.Path = strcat(cd,'\',DFT.Path);
  end
  if(isMp3Format(DFT.Path))
    DFT.PlayList{1} = DFT.Path;
    [DFT.Signal,DFT.SampleRate,DFT.SampleBits,DFT.Format] = mp3read(DFT.PlayList{1});
    DFT.Signal = fixInputin2Col(DFT.Signal);
  else
    display('Atleast first open file should be valid !!!')
    return;
  end
  DFT.Devices = audiodevinfo;
  devnum = length(DFT.Devices.output);
  DFT.DeviceID = zeros(devnum,1);
  for i = 1:devnum
    display(strcat('DeviceID[',num2str(DFT.Devices.output(i).ID),']: "',DFT.Devices.output(i).Name,...
                   '" ver ',num2str(DFT.Devices.output(i).DriverVersion)))
    DFT.DeviceID(i,1) = DFT.Devices.output(i).ID;
  end
  display(' ');
  while(1)
    DFT.UserInput=input('Device ID? >>','s');
    DFT.UserInput = fix(str2double(DFT.UserInput));
    if(ValuePersistInArray(DFT.UserInput,DFT.DeviceID))
         DFT.DeviceID = (DFT.UserInput == DFT.DeviceID)'*DFT.DeviceID;
    end
    if(length(DFT.DeviceID) == 1), break; end
    if(strcmp(DFT.UserInput,'q')), return; end
  end
  clc
  % Create the audio player and start doing the thing
  DFT.SampleRateDefault = DFT.SampleRate;
  DFT.Object = audioplayer(DFT.Signal,DFT.SampleRate,DFT.SampleBits,DFT.DeviceID);
  DFT.Object.tag = slashstringn(DFT.Path,19);
  stop(DFT.Object)
  dispMp3Info(DFT.Format,DFT.Object);
  play(DFT.Object);
  while(1)
    keep('DFT'); % Only the DFT is needed to be kept
    if(DFT.Object.CurrentSample > (DFT.Object.TotalSamples - DFT.SampleRate))
      stop(DFT.Object);
      clc
      sz = size(DFT.PlayList);
      % Next item
      for id = 1:1:sz(1)
        if(strcmp(DFT.PlayList{id},DFT.Path))
          item = id + 1;
          break;
        end
      end
      % Playlist end
      if(strcmp(DFT.PlayList{length(DFT.PlayList)},DFT.Path))
        item = 1;
      end
      %Getting valid file
      while(~exist(DFT.PlayList{item},'file'))
        item = item + 1;
        if(item > length(DFT.PlayList))
          item = 1;
        end
        display(strcat('Skipping [',num2str(item),']: ',DFT.PlayList{item}));
      end
      DFT.Path = DFT.PlayList{item};
      %Load data
      [DFT.Signal,DFT.SampleRate,DFT.SampleBits,DFT.Format] = mp3read(DFT.Path);
      DFT.Signal = fixInputin2Col(DFT.Signal);
      DFT.SampleRateDefault = DFT.SampleRate;
      clc
      DFT.Object = audioplayer(DFT.Signal,DFT.SampleRate,DFT.SampleBits,DFT.DeviceID);
      DFT.Object.tag = slashstringn(DFT.Path,19);
      dispMp3Info(DFT.Format,DFT.Object);
      play(DFT.Object);
      continue;
    else
      % Needs waiting for a key
      DFT.UserInput=input('Command >>','s');
      switch DFT.UserInput
      case 'p', pause(DFT.Object);
      case 'rate', rat  = num2str(DFT.Object.SampleRate);
                   rat  = strcat('Command >> Rate = ',rat,' >>');
                   DFT.UserInput = input(rat,'s');
        switch DFT.UserInput
          case 'd', pause(DFT.Object); DFT.Object.SampleRate=DFT.SampleRateDefault; resume(DFT.Object);
          case 'b', continue;
          otherwise
            if(str2double(DFT.UserInput) ~= 0)
              DFT.UserInput=str2double(DFT.UserInput);
              if(((DFT.UserInput > 0) && (DFT.Object.SampleRate+DFT.UserInput < 1000000))...
                || ((DFT.UserInput < 0) && (DFT.Object.SampleRate+DFT.UserInput > 0)))
                mp3rate(DFT.Object,DFT.UserInput)
              end
            end
         end
       case 'seek'
         seek = percent_q(DFT.Object.CurrentSample,DFT.Object.TotalSamples);
         chfs = num2str(seek);
         chfs = strcat('Command >> Seek >',chfs,'%<',' >>');
         DFT.UserInput=input(chfs,'s');
         sk = part_q(str2double(DFT.UserInput),DFT.Object.TotalSamples);
         switch DFT.UserInput
           case 'b', continue;
           case 'first',
             stop(DFT.Object);
             play(DFT.Object,[2 DFT.Object.TotalSamples]);
           case 'last',
             stop(DFT.Object);
             play(DFT.Object,[DFT.Object.TotalSamples DFT.Object.TotalSamples]);
           otherwise
             if(isnan(str2double(DFT.UserInput)))
              continue;
             end
             stop(DFT.Object);
             play(DFT.Object,[uint64(sk) DFT.Object.TotalSamples]);
         end
      case 'v', DFT.UserInput=input('Command >> View >>','s');
        switch DFT.UserInput
          case 'dft', DFT.Calc.Cur = selectAlgorithm(DFT.Calc);
          case 'c',
            DFT.Plot2D.Cur = selectAlgorithm(DFT.Plot2D);
            drawArgs = DFT.Plot2D.Alg{DFT.Plot2D.Cur};
            drawCurvDFT(DFT.Calc.Alg{DFT.Calc.Cur}{1}, DFT.Object, DFT.Signal, drawArgs{1}, drawArgs{2}, drawArgs{3}, drawArgs{4});
          case 's',
            DFT.Plot3D.Cur = selectAlgorithm(DFT.Plot3D);
            drawArgs = DFT.Plot3D.Alg{DFT.Plot3D.Cur};
            drawSurfDFT(DFT.Calc.Alg{DFT.Calc.Cur}{1}, DFT.Object, DFT.Signal, drawArgs{1}, drawArgs{2}, drawArgs{3}, drawArgs{4}, drawArgs{5});
          case 'b', continue;
          case 'cmd', display({
                  'b - Back';...
                  'acl - Select DFT algorithm to be used';...
                  'c - Plot the signal and DFT in 2D mode';...
                  's - Plot the signal and DFT in 3D mode';...
                  'cmd - Displays this info';
                  's - Plot the signal and surface the DFT'});
          otherwise , display('Wrong command');
        end
      case 's'   , stop(DFT.Object);
      case 'clc' , clc;
      case 'info', display(DFT.Object);
      case 'dir' , dir(DFT.Path(1:slashstringn(DFT.Path,0)));
      case 'r'   , resume(DFT.Object);
      case 'help', display({'p - Pause';'r - Resume';'s - Stop';'q - Quit';'o - Open a file';'seek - Seek(Put a percent)';'clc - Clear screen';...
           'info - Display object';'dir - View directory';'plist - Paylist';'add,rem(ove),sel(ect),info';...
           'v - Draw signal (v)iew >> c - Curve 2D plot, s - Surface 3D plot, dft - DFT calcolator select';'help - Displays this info'});
      case 'plist', DFT.UserInput = input('Command >> PlayList >>','s');
        switch DFT.UserInput
          case 'add', DFT.UserInput = input('Command >> PlayList >> Add >>','s');
            % Kill the spaces
            DFT.UserInput = killFBSpaces(DFT.UserInput);
            % Add ".mp3 if not present"
            if(~strcmp(DFT.UserInput((length(DFT.UserInput)-3):length(DFT.UserInput)),'.mp3'))
                 DFT.UserInput = strcat(DFT.UserInput,'.mp3');
             end
            % Add file path prefix directory to the "file.mp3"
            if(strcmp(slashstringn(DFT.UserInput,100),DFT.UserInput))
              DFT.UserInput = strcat(slashstringn(DFT.Path,-1),DFT.UserInput);
            end
            % Add to the playlist if Valid
            % 1-st Current file
            % 2-nd Current directory
            if(isMp3Format(DFT.UserInput))
              DFT.PlayList = {DFT.PlayList{:,1},DFT.UserInput}';
            else
              DFT.UserInput = strcat(cd,'\',slashstringn(DFT.UserInput,100));
              if(isMp3Format(DFT.UserInput))
                DFT.PlayList = {DFT.PlayList{:,1},DFT.UserInput}';
              else
                display('This is not in the current path directory !!!')
              end
            end
          case 'rem', DFT.UserInput = input('Command >> PlayList >> Rem >>','s');
            % Set difference
            item = floor(str2double(DFT.UserInput));
            if(~(isnan(item) || (item < 1) ||...
              (item > length(DFT.PlayList)) || strcmp(DFT.PlayList(item),DFT.Path)))
              % Delete the last element
              DFT.PlayList(item) = [];
            end
          case 'sel', DFT.UserInput=input('Command >> PlayList >> Sel >>','s');
            item = floor(str2double(DFT.UserInput));
            % Valid item number in the playlist
            if(~(isnan(item) || (item < 1) || (item > length(DFT.PlayList))))
              % Skip to the closest valid file ...
              while(~exist(DFT.PlayList{item},'file'))
                item = item + 1;
                if(item > length(DFT.PlayList))
                  item = 1;
                end
              end
              stop(DFT.Object);
              DFT.Path = DFT.PlayList{item};
              [DFT.Signal,DFT.SampleRate,DFT.SampleBits,DFT.Format] = mp3read(DFT.Path);
              DFT.Signal = fixInputin2Col(DFT.Signal);
              DFT.Object = audioplayer(DFT.Signal,DFT.SampleRate,DFT.SampleBits,DFT.DeviceID);
              DFT.Object.tag = slashstringn(DFT.Path,40);
              clc
              dispMp3Info(DFT.Format,DFT.Object);
              play(DFT.Object);
            end
          case 'info', clc,
            for i = 1:length(DFT.PlayList)
              display(strcat('[',num2str(i),']  ',toLenofN(DFT.PlayList{i},1,80)));
            end
            display(' ');
         end
      case 'o',
        pause(DFT.Object);
        DFT.UserInput=input('Command >> OpenFile >>','s');
        if(DFT.UserInput == 'b')
          resume(DFT.Object);
          continue;
        elseif(~isempty(DFT.UserInput))
          % Add ".mp3 if not present"
          if(~strcmp(DFT.UserInput((length(DFT.UserInput)-3):length(DFT.UserInput)),'.mp3'))
            DFT.UserInput = strcat(DFT.UserInput,'.mp3');
          end
          % Add "cd" to the "file.mp3"
          if(strcmp(slashstringn(DFT.UserInput,100),DFT.UserInput))
            DFT.UserInput = strcat(cd,'\',DFT.UserInput);
          end
          % Add to playlist if Valid
          if(exist(DFT.UserInput,'file'))
            stop(DFT.Object);
            openmp3(DFT.UserInput);
            break;
          else
            display('File not Found');
            resume(DFT.Object);
            continue;
          end
        end
      case 'q',
        stop(DFT.Object);
        clear all
        break;
      end
    end
  end
end

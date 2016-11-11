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
  % This function uses "mp3read()" I didn't make it. It was made
  % by Alfredo Fernandez. I only made the player itself, so you can open
  % *.mp3 files for listening them and experimenting with different DFT
  % algorithms, windows and plotters in real time
  %   This code has a menu for
  %   1) "seek"      - Seek the file in percents
  %   2) "rate"      - Changing sampling rate of the audio player
  %   3) "p","r","s" - Pause Resume and Stop the processing
  %   4) "o"         - Open another file
  %   5) "v" - Open viewing options
  %      "c" - Plot the signal and DFT with the 2D graph selected
  %      "s" - Mesh the signal and DFT with the 3D graph selected
  %      "dft" - Selects a different DFT algorithm to be used
  %      "win" - Selects a window to weighten the samples
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
  DFT.Devices  = audiodevinfo;
  DFT.Calc.Cur = 1;
  DFT.Calc.Inf = 'DFT calculator';
  DFT.Calc.Alg = {
    { @fft      , 'Default integrated'              }
    { @fftVector, 'Vector-Matrix iterative'         }
    { @fftRadix , 'Coukey-Turkey from the textbook' }
    { @fftRecurs, 'Recursive using odd and even'    }
  };
  % Plots help: http://www.mathworks.com/help/matlab/creating_plots/types-of-matlab-plots.html
  % Load 3D plots ( Size of the window, Points count, Memorized DFT count, Label )
  DFT.Plot3D.Cur = 1; % The current selected plotter
  DFT.Plot3D.Inf = '3D data plotter';
  DFT.Plot3D.Alg =  {
    { @surf     , 'Surface graph'         , 40, 512 , 15 }
    { @surfc    , 'Surface contour graph' , 40, 512 , 15 }
    { @surfl    , 'Surface colormap graph', 40, 512 , 15 }
    { @surfnorm , 'Surface normals graph' , 40, 512 , 15 }
    { @mesh     , 'Mesh graph'            , 40, 128 , 10 }
    { @meshc    , 'Mesh contour graph'    , 40, 128 , 10 }
    { @meshz    , 'Mesh curtain graph'    , 40, 128 , 10 }
    { @waterfall, 'Waterfall graph'       , 40, 128 , 6  }
    { @ribbon   , 'Ribbon graph'          , 40, 128 , 6  }
    { @contour3 , 'Contour 3D graph'      , 40, 128 , 6  }
    { @contour  , 'Contour graph'         , 40, 128 , 6  }
    { @bar3     , 'Bar graph'             , 40, 128 , 6  }
    { @stem3    , 'Stem 3D graph'         , 40, 128 , 6  }
  };
  % Load 2D plots ( Size of the window, Points count, Label )
  DFT.Plot2D.Cur = 1; % The current selected plotter
  DFT.Plot2D.Inf = '2D data plotter';
  DFT.Plot2D.Alg = {
    { @plot     , 'Plot graph'          , 40, 2048 }
    { @stairs   , 'Stairs graph'        , 40, 2048 }
    { @loglog   , 'Logarithmic XY graph', 40, 2048 }
    { @semilogx , 'Logarithmic X graph' , 40, 2048 }
    { @semilogy , 'Logarithmic Y graph' , 40, 2048 }
    { @area     , 'Area graph'          , 40, 2048 }
    { @pie      , 'Pie 2D graph'        , 40, 2048 }
    { @pie3     , 'Pie 3D graph'        , 40, 2048 }
    { @bar      , 'Bar graph'           , 40, 2048 }
    { @stem     , 'Stem graph'          , 40, 2048 }
    { @histogram, 'Histogram graph'     , 40, 2048 }
  };
  % Load a list of windows
  DFT.Wind.Cur = 1; % The current selected plotter
  DFT.Wind.Inf = 'Signal window';
  DFT.Wind.Alg = {
    { @barthannwin   , 'Barthann'      }
    { @bartlett      , 'Bartlett'      }
    { @blackman      , 'Blackman'      }
    { @blackmanharris, 'Blackmanharris'}
    { @bohmanwin     , 'Bohman'        }
    { @chebwin       , 'Chebishev'     }
    { @flattopwin    , 'Flattop'       }
    { @gausswin      , 'Gaussian'      }
    { @hamming       , 'Hamming '      }
    { @hann          , 'Hann'          }
    { @kaiser        , 'Kaiser'        }
    { @nuttallwin    , 'Nuttall'       }
    { @parzenwin     , 'Parzen'        }
    { @rectwin       , 'Rectangle'     }
    { @taylorwin     , 'Taylor'        }
    { @triang        , 'Triangular'    }
    { @tukeywin      , 'Tukeywin'      }
  };
  DFT.Dummy             = 0;
  DFT.Object            = 0;
  DFT.Path              = path_mp3;
  DFT.SampleRate        = 0;
  DFT.SampleRateDefault = 0;
  DFT.Signal            = [];
  DFT.SampleBits        = 0;
  DFT.UserInput         = '';
  DFT.Devices           = audiodevinfo;
  DFT.DeviceID          = 0;
  DFT.Play.Lst          = {};
  DFT.Play.Cur          = 1;
  DFT.Play.Mod          = 'seq';
  DFT.Format            = {};
  %Kill spaces
  DFT.Path = killFBSpaces(DFT.Path);
  % Normalize the pat to always be full
  DFT.Path = fullPathMP3(DFT.Path);
  try
    [DFT.Signal,DFT.SampleRate,DFT.SampleBits,DFT.Format] = mp3read(DFT.Path);
  catch err;
    if(~isempty(err.message))
      display(strcat('File invalid:',DFT.Path))
      display(strcat('Error:',err.message))
      display('Atleast first open file should be valid !!!')
      return;
    end
  end
  DFT.Play.Lst{1} = DFT.Path;
  DFT.Signal      = fixInputin2Col(DFT.Signal);
  DFT.Dummy       = length(DFT.Devices.output);
  DFT.DeviceID    = zeros(DFT.Dummy,1);
  for i = 1:DFT.Dummy
    display(strcat('DeviceID[',num2str(DFT.Devices.output(i).ID),']: "',DFT.Devices.output(i).Name,...
                   '" v.',num2str(DFT.Devices.output(i).DriverVersion)))
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
  DFT.Object     = audioplayer(DFT.Signal,DFT.SampleRate,DFT.SampleBits,DFT.DeviceID);
  DFT.Object.tag = slashstringn(DFT.Path,length(DFT.Path));
  stop(DFT.Object)
  dispMp3Info(DFT.Format,DFT.Object);
  play(DFT.Object);
  while(1)
    if(DFT.Object.CurrentSample > (DFT.Object.TotalSamples - DFT.SampleRate))
      stop(DFT.Object);
      DFT.Play.Cur   = getNextValidID(DFT.Play.Lst,DFT.Play.Cur,DFT.Play.Mod);
      DFT.Path       = DFT.Play.Lst{DFT.Play.Cur};
      % Load the next file as it it prevoiusly validated on adding
      [DFT.Signal,DFT.SampleRate,DFT.SampleBits,DFT.Format] = mp3read(DFT.Path);
      DFT.Signal     = fixInputin2Col(DFT.Signal);
      DFT.SampleRateDefault = DFT.SampleRate;
      DFT.Object     = audioplayer(DFT.Signal,DFT.SampleRate,DFT.SampleBits,DFT.DeviceID);
      DFT.Object.tag = slashstringn(DFT.Path,length(DFT.Path));
      clc;
      dispMp3Info(DFT.Format,DFT.Object);
      play(DFT.Object);
      continue;
    else
      % Needs waiting for a key
      DFT.UserInput=input('Command >>','s');
      switch DFT.UserInput
      case 'save' display('Store selections in a file.');
      case 'p', pause(DFT.Object);
      case 'rate', DFT.Dummy     = num2str(DFT.Object.SampleRate);
                   DFT.Dummy     = strcat('Command >> Rate = <',DFT.Dummy ,'> >>');
                   DFT.UserInput = input(DFT.Dummy ,'s');
        switch DFT.UserInput
          case 'd', pause(DFT.Object); DFT.Object.SampleRate=DFT.SampleRateDefault; resume(DFT.Object);
          case 'b', continue;
          otherwise
            if(str2double(DFT.UserInput) ~= 0)
              DFT.UserInput=str2double(DFT.UserInput);
              if(((DFT.UserInput > 0) && (DFT.Object.SampleRate+DFT.UserInput < 1000000))...
                || ((DFT.UserInput < 0) && (DFT.Object.SampleRate+DFT.UserInput > 0)))
                pause(DFT.Object);
                DFT.Object.SampleRate = DFT.Object.SampleRate + DFT.UserInput
                resume(mp3);
              end
            end
          end
       case 'seek'
         DFT.Dummy = percent_q(DFT.Object.CurrentSample,DFT.Object.TotalSamples)
         DFT.Dummy = num2str(DFT.Dummy);
         DFT.Dummy = strcat('Command >> Seek >',DFT.Dummy,'%< >>');
         DFT.UserInput = input(DFT.Dummy,'s');
         switch DFT.UserInput
           case 'b', continue;
           case 'f',
             stop(DFT.Object);
             play(DFT.Object,[2 DFT.Object.TotalSamples]);
           case 'l',
             stop(DFT.Object);
             play(DFT.Object,[DFT.Object.TotalSamples DFT.Object.TotalSamples]);
           otherwise
             DFT.Dummy = str2double(DFT.UserInput);
             if(isnan(DFT.Dummy))
               continue;
             end
             DFT.Dummy = part_q(DFT.Dummy,DFT.Object.TotalSamples)
             DFT.Dummy = floor(DFT.Dummy);
             stop(DFT.Object);
             play(DFT.Object,[DFT.Dummy DFT.Object.TotalSamples]);
         end
      case 'v', DFT.UserInput = input('Command >> View >>','s');
        switch DFT.UserInput
          case 'win', DFT.Wind.Cur = selectAlgorithm(DFT.Wind);
          case 'dft', DFT.Calc.Cur = selectAlgorithm(DFT.Calc);
          case 'c',
            DFT.Plot2D.Cur = selectAlgorithm(DFT.Plot2D);
            DFT.Dummy      = DFT.Plot2D.Alg{DFT.Plot2D.Cur};
            drawCurvDFT(DFT.Calc.Alg{DFT.Calc.Cur}{1}, DFT.Wind{DFT.Wind.Cur}{1}, DFT.Object, DFT.Signal, DFT.Dummy{1}, DFT.Dummy{2}, DFT.Dummy{3}, DFT.Dummy{4});
          case 's',
            DFT.Plot3D.Cur = selectAlgorithm(DFT.Plot3D);
            DFT.Dummy      = DFT.Plot3D.Alg{DFT.Plot3D.Cur};
            drawSurfDFT(DFT.Calc.Alg{DFT.Calc.Cur}{1}, DFT.Wind{DFT.Wind.Cur}{1}, DFT.Object, DFT.Signal, DFT.Dummy{1}, DFT.Dummy{2}, DFT.Dummy{3}, DFT.Dummy{4}, DFT.Dummy{5});
          case 'b', continue;
          case 'cmd', display({
                  'b   - Back';...
                  'c   - Plot the signal and DFT in 2D mode';...
                  's   - Plot the signal and DFT in 3D mode';...
                  'dft - Select DFT algorithm to be used';...
                  'win - Select window to be used';...
                  'cmd - Displays this info'});
          otherwise , display('Command invalid !!!');
        end
      case 's'   , stop(DFT.Object);
      case 'clc' , clc;
      case 'inf' , display(DFT.Object);
      case 'dir' , dir(DFT.Path(1:slashstringn(DFT.Path,0)));
      case 'r'   , resume(DFT.Object);
      case 'h'   , display({'p - Pause';'r - Resume';'s - Stop';'q - Quit';'o - Open a file';'seek - Seek(Put a percent)';'clc - Clear screen';...
           'inf - Display object';'dir - View directory';'pl - Paylist';'add,rem(ove),sel(ect),inf(ormation)';...
           'v(iew) - Draw signal';'(c)urve - 2D, s(urface) - 3D, dft - DFT calcolator, win - Window selction';'h - Displays this info'});
      case 'pl', DFT.UserInput = input('Command >> Playlist >>','s');
        switch DFT.UserInput
          case 'add', DFT.UserInput = input('Command >> Playlist >> Add >>','s');
            % Kill the spaces
            DFT.UserInput = killFBSpaces(DFT.UserInput);
            % Normalize the path to be alwayhs full"
            DFT.UserInput = fullPathMP3(DFT.UserInput);
            % Add to the playlist if Valid
            % 1-st Current file
            % 2-nd Current directory
            try
              DFT.Dummy = mp3read(DFT.UserInput);
            catch err;
              if(~isempty(err.message))
                display(strcat('File invalid:',DFT.UserInput))
                display(strcat('Error:',err.message))
                display('This path cannot be added to the playlist !!!')
              end
            end
            DFT.Play.Lst = {DFT.Play.Lst{:,1},DFT.UserInput}';
          case 'rem', DFT.UserInput = input('Command >> Playlist >> Rem >>','s');
            % Set difference
            DFT.Dummy = floor(str2double(DFT.UserInput));
            if(~(isnan(DFT.Dummy) || (DFT.Dummy < 1) ||...
              (DFT.Dummy > length(DFT.Play.Lst)) || strcmp(DFT.Play.Lst(DFT.Dummy),DFT.Path)))
              % Delete the last element
              DFT.Play.Lst(DFT.Dummy) = [];
            end
          case 'sel', DFT.UserInput=input('Command >> Playlist >> Sel >>','s');
            DFT.Dummy = floor(str2double(DFT.UserInput));
            % Valid item number in the playlist
            if(~(isnan(DFT.Dummy) || (DFT.Dummy < 1) || (DFT.Dummy > length(DFT.Play.Lst))))
              stop(DFT.Object);
              DFT.Play.Cur   = getNextValidID(DFT.Play.Lst,DFT.Play.Cur,DFT.Play.Mod);
              DFT.Path       = DFT.Play.Lst{DFT.Play.Cur};
              [DFT.Signal,DFT.SampleRate,DFT.SampleBits,DFT.Format] = mp3read(DFT.Path);
              DFT.Signal     = fixInputin2Col(DFT.Signal);
              DFT.Object     = audioplayer(DFT.Signal,DFT.SampleRate,DFT.SampleBits,DFT.DeviceID);
              DFT.Object.tag = slashstringn(DFT.Path,length(DFT.Path));
              clc
              dispMp3Info(DFT.Format,DFT.Object);
              play(DFT.Object);
            end
          case 'inf', clc,
            DFT.Dummy = 1;
            while(DFT.Dummy <= length(DFT.Play.Lst))
              display(strcat('[',num2str(DFT.Dummy),']',toLenofN(DFT.Play.Lst{DFT.Dummy},1,100)));
              DFT.Dummy = DFT.Dummy + 1;
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
          % Normalize full file path
          DFT.UserInput = fullPathMP3(DFT.UserInput);
          if(exist(DFT.UserInput,'file'))
            stop(DFT.Object);
            openmp3(DFT.UserInput);
            break; % Kill the session
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

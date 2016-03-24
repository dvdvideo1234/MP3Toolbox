function [] = openmp3(path_mp3)

%Just type in the Matlab command line " openmp3("HERE STAyS PATH TO THE FILE") "
%Prototype in c++ :
%                     void openmp3(char *file_path_including_name)
%
% Works also with Drag-Drop file to the ML command window and duble click
% in the current directory on the *.mp3  file.
% 
% Example: 
% These calls are the same, where "path_mp3" is "D:/music/test/test.mp3"
%
%  1: openmp3('D:/music/test/test.mp3') reg. "path_mp3" value target song
%  2: openmp3('test.mp3'), note that "test.mp3" is in the current folder
%  3: openmp3('test')    , note that "test.mp3" is in the current folder
%  and *.mp3 extension is added at the end automatically
%
% This function uses "mp3raead()" I didn't make "mp3raead()", it was made
% by Alfredo Fernandez.  I only made the player itself, so you can open 
% *.mp3 files for listening them
%   This code has a menu for 
%   1 Seek in percents                                         >> seek
%   2 Changing sampling rate                                >> rate
%   3 Pause Resume and Stop                             >> p , r , s
%   4 Open another file                                         >> o
%   5 Plot the signal and Fourier transform              >> v
%        Options:   Plot   Mesh   Surf   Waterfall
%   6 File info                                                      >> info
%   7 Clear screen                                               >> clc
%   8 Look root                                                    >> dir
%   9 Playlist                                                       >> plist
%        Options:   Add   Remove  Select
%  10 Help                                                          >> help

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
if(length(nplay) >= 19)
    mp3.tag = nplay(1:19);
else
    mp3.tag = nplay;
end
dispMp3Info(opts,mp3);


keep('mp3','tempch','y','fs','def_fs','path_mp3','playlist','DevID','opts') 
play(mp3);


while(1)
keep('mp3','tempch','y','fs','def_fs','path_mp3','playlist','DevID','opts')

if(mp3.CurrentSample > (mp3.TotalSamples - fs))
    stop(mp3);
    clc
    sz = size(playlist);
    % Next song
        for songs = 1:1:sz(1)
            if(strcmp(playlist{songs},path_mp3))
                song = songs + 1;
                break;
            end
        end
      % Playlist end
        if(strcmp(playlist{length(playlist)},path_mp3))
            song = 1;
        end
        %Getting valid file
        while(~exist(playlist{song},'file'))
            song = song + 1;
            if(song > length(playlist)) 
                song = 1;
            end
        end
        path_mp3 = playlist{song};
        
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
   case 'rate', ch_fs=num2str(mp3.SampleRate);
                 ch_fs=strcat('Command >> Rate = ',ch_fs,' >>');
                 tempch=input(ch_fs,'s');
        switch tempch 
            case 'd' , pause(mp3); mp3.SampleRate=def_fs; resume(mp3);   
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
           case 'p',
                     n=2048;                    
                     b = floor(n/2);
                     window = blackman(n);
                     df = mp3.SampleRate/n;
                     n2 = mp3.SampleRate/2;
                     freq = (1:1:n) * df;
                     freq = freq(1:b);
                     if(isempty(get(0,'CurrentFigure')))
                         fig = 1;
                     else
                         fig = max(get(0,'Children')) + 1;
                     end
                     while((mp3.CurrentSample < mp3.TotalSamples)...
                             && (mp3.CurrentSample ~= 1))
                              figure(fig)
                              if(~ishandle(fig))
                                 break;
                              elseif(mp3.CurrentSample > n)
                                 left = y(mp3.CurrentSample-n:mp3.CurrentSample,1);
                                 righ = y(mp3.CurrentSample-n:mp3.CurrentSample,2);
                                 ft(:,1)=myfft1(left(1:n).*window);
                                 ft(:,2)=myfft1(righ(1:n).*window);
                                 ftt = matsat(abs(ft(1:b,:)),[0 25]); %ftt = ftt(1:b,:);                    
                                 subplot(2,2,1), plot(left), title('Sampled Signal'), xlabel('Sample'),
                                 ylabel('Value'), xlim([0 n]), ylim([-1 1]), grid
                                 subplot(2,2,2), plot(righ), title('Sampled Signal'), xlabel('Sample'),
                                 ylabel('Value'), xlim([0 n]), ylim([-1 1]), grid
                                 subplot(2,2,3), plot(freq,ftt(:,1)), title('DFT'),xlim([0 n2]),ylim([0 25]),
                                 xlabel('Frequency'), ylabel('|X(n)|'), grid
                                 subplot(2,2,4), plot(freq,ftt(:,2)),title('DFT'),xlim([0 n2]),ylim([0 25]),
                                 xlabel('Frequency'), ylabel('|X(n)|'), grid
                             end
                     end
                     if(sum(fig*ones(size(get(0,'Children'))) == get(0,'Children'))), close(fig), end
           case 'w',
                     n=128;          
                     falls = 6;
                     
                     b = floor(n/2);
                     window = blackman(n);
                     ftl = zeros(b,falls);
                     ftr = zeros(b,falls);
                     df = strcat(num2str(floor(mp3.SampleRate/n)),'n','[Hz]');
                     if(isempty(get(0,'CurrentFigure')))
                         fig = 1;
                     else
                         fig = max(get(0,'Children')) + 1;
                     end
                     while((mp3.CurrentSample < mp3.TotalSamples)...
                             && (mp3.CurrentSample ~= 1))
                                 figure(fig)
                                 if(~ishandle(fig))
                                     break;
                                 elseif(mp3.CurrentSample > n)
                                     left = y(mp3.CurrentSample-n:mp3.CurrentSample,1);
                                     righ = y(mp3.CurrentSample-n:mp3.CurrentSample,2);
                                     left = left(1:n);
                                     righ = righ(1:n);
                                     fl = abs(myfft1(left.*window));
                                     fr = abs(myfft1(righ.*window));
                                     ftl = shiftArr(ftl,1);
                                     ftr = shiftArr(ftr,1);
                                     ftl(:,1) = matsat(fl(1:b),[0,20]); %swaparr(fl(1:b),2);
                                     ftr(:,1) = matsat(fr(1:b),[0,20]); %swaparr(fr(1:b),2);
                                     subplot(2,2,1), plot(left), title('Sampled Signal'),xlabel('Sample'), ylabel('Value'),
                                     xlim([1 n]), ylim([-1 1]), grid
                                     subplot(2,2,2), plot(righ), title('Sampled Signal'),xlabel('Sample'), ylabel('Value'),
                                     xlim([1 n]), ylim([-1 1]), grid
                                     subplot(2,2,3), waterfall(ftl), title('DFT Waterfall graph'), xlabel('SampleTime'),...
                                     ylabel(df), zlabel('|X(n)|'), ylim([0 b]), xlim([1 falls]), zlim([0 20]), view([-130 20]), grid
                                     subplot(2,2,4), waterfall(ftr), title('DFT Waterfall graph'), xlabel('SampleTime'),...
                                     ylabel(df), zlabel('|X(n)|'), ylim([0 b]), xlim([1 falls]), zlim([0 20]), view([-130 20]), grid
                                 end
                     end
                     if(sum(fig*ones(size(get(0,'Children'))) == get(0,'Children'))), close(fig), end
           case 'm'   
                     n=128;          
                     falls = 10;
                     
                     b = floor(n/2);
                     window = blackman(n);
                     ftl = zeros(b,falls);
                     ftr = zeros(b,falls);
                     df = strcat(num2str(floor(mp3.SampleRate/n)),'n','[Hz]');
                     if(isempty(get(0,'CurrentFigure')))
                         fig = 1;
                     else
                         fig = max(get(0,'Children')) + 1;
                     end
                     while((mp3.CurrentSample < mp3.TotalSamples)...
                             && (mp3.CurrentSample ~= 1))
                                 figure(fig)
                                 if(~ishandle(fig))
                                     break;
                                 elseif(mp3.CurrentSample > n)
                                     left = y(mp3.CurrentSample-n:mp3.CurrentSample,1);
                                     righ = y(mp3.CurrentSample-n:mp3.CurrentSample,2);
                                     left = left(1:n);
                                     righ = righ(1:n);
                                     fl = abs(myfft1(left.*window));
                                     fr = abs(myfft1(righ.*window));
                                     ftl = shiftArr(ftl,1);
                                     ftr = shiftArr(ftr,1);
                                     ftl(:,1) = matsat(fl(1:b),[0,20]); %swaparr(fl(1:b),2);
                                     ftr(:,1) = matsat(fr(1:b),[0,20]); %swaparr(fr(1:b),2);
                                     subplot(2,2,1), plot(left), title('Sampled Signal'),xlabel('Sample'), ylabel('Value'),
                                     xlim([1 n]), ylim([-1 1]), grid
                                     subplot(2,2,2), plot(righ), title('Sampled Signal'),xlabel('Sample'), ylabel('Value'),
                                     xlim([1 n]), ylim([-1 1]), grid
                                     subplot(2,2,3), mesh(ftl), title('DFT Mesh graph'), xlabel('SampleTime'),...
                                     ylabel(df), zlabel('|X(n)|'), ylim([0 b]), xlim([1 falls]), zlim([0 20]), view([-130 20]), grid
                                     subplot(2,2,4), mesh(ftr), title('DFT Mesh graph'), xlabel('SampleTime'),...
                                     ylabel(df), zlabel('|X(n)|'), ylim([0 b]), xlim([1 falls]), zlim([0 20]), view([-130 20]), grid
                                 end
                     end
                     if(sum(fig*ones(size(get(0,'Children'))) == get(0,'Children'))), close(fig), end
           case 's'   
                     n=512;          
                     falls = 15;
                     
                     b = floor(n/2);
                     window = blackman(n);
                     ftl = zeros(b,falls);
                     ftr = zeros(b,falls);
                     df = strcat(num2str(floor(mp3.SampleRate/n)),'n','[Hz]');
                     if(isempty(get(0,'CurrentFigure')))
                         fig = 1;
                     else
                         fig = max(get(0,'Children')) + 1;
                     end
                     while((mp3.CurrentSample < mp3.TotalSamples)...
                             && (mp3.CurrentSample ~= 1))
                                 figure(fig)
                                 if(~ishandle(fig))
                                     break;
                                 elseif(mp3.CurrentSample > n)
                                     left = y(mp3.CurrentSample-n:mp3.CurrentSample,1);
                                     righ = y(mp3.CurrentSample-n:mp3.CurrentSample,2);
                                     left = left(1:n);
                                     righ = righ(1:n);
                                     fl = abs(myfft1(left.*window));
                                     fr = abs(myfft1(righ.*window));
                                     ftl = shiftArr(ftl,1);
                                     ftr = shiftArr(ftr,1);
                                     ftl(:,1) = matsat(fl(1:b),[0,20]); %swaparr(fl(1:b),2);
                                     ftr(:,1) = matsat(fr(1:b),[0,20]); %swaparr(fr(1:b),2);
                                     subplot(2,2,1), plot(left), title('Sampled Signal'),xlabel('Sample'), ylabel('Value'),
                                     xlim([1 n]), ylim([-1 1]), grid
                                     subplot(2,2,2), plot(righ), title('Sampled Signal'),xlabel('Sample'), ylabel('Value'),
                                     xlim([1 n]), ylim([-1 1]), grid
                                     subplot(2,2,3), surf(ftl), title('DFT Surface graph'), xlabel('SampleTime'),...
                                     ylabel(df), zlabel('|X(n)|'), ylim([0 b]), xlim([1 falls]), zlim([0 20]), view([-130 20]), grid
                                     subplot(2,2,4), surf(ftr), title('DFT Surface graph'), xlabel('SampleTime'),...
                                     ylabel(df), zlabel('|X(n)|'), ylim([0 b]), xlim([1 falls]), zlim([0 20]), view([-130 20]), grid
                                 end
                     end
                     if(sum(fig*ones(size(get(0,'Children'))) == get(0,'Children'))), close(fig), end
           case 'b', 
              continue;
           case 'cmd' 
              display({'b - Back';'p - Plot signal and FFT';...
                   'w - Plot the signal and waterfall the FFT'});
           otherwise , disp('Wrong command');
       end
   case 's', 
       stop(mp3);
   case 'clc', clc;
   case 'info', disp(mp3);
   case 'dir', dir(path_mp3(1:slashstringn(path_mp3,0)));
   case 'r', 
       resume(mp3);
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
                song = floor(str2double(tempch));
                if(~(isnan(song) || (song < 1) ||...
                 (song > length(playlist)) || strcmp(playlist(song),path_mp3)))
                   % Delete the last element
                   playlist(song) = [];
                end   
           case 'sel', tempch=input('Command >> PlayList >> Sel >>','s');
               song = floor(str2double(tempch));
               % Valid song number in the playlist
               if(~(isnan(song) || (song < 1) || (song > length(playlist))))
                   
                   % skip to the closest Valid file ...
                   
                    %Getting valid file
                   while(~exist(playlist{song},'file'))
                       song = song + 1;
                       if(song > length(playlist)) 
                           song = 1;
                       end
                   end
                   stop(mp3);
                   path_mp3 = playlist{song};
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

  


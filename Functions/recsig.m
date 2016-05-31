function [t,y] = recsig(h,m,s)
  % Records signal while it's running
  % Gets hours, minutes, seconds
  % Returns time, sampled valuses in [-1 1]
  % Call: [time,sampled_signal] = recsig(hours,minutes,seconds) 
  
  siglen = 3600*h + 60*m + s;
  if(siglen < 40)
    dec = siglen;
  else
    dec = 1;
  end
  fs = 44100;
  nbits = 16;
  chans = 2;
  dev = audiodevinfo;
  devnum=length(dev.input);
  DevID = zeros(devnum,1);  
  for i =1:devnum
    disp(strcat('Dev >',dev.input(i).Name,'< Ver>',num2str...
    (dev.input(i).DriverVersion),'< ID >',num2str(dev.input(i).ID)));
    DevID(i,1) = dev.input(i).ID;
  end
  while(1)
    tempch=input('Device ID? >>','s');
    tempch = fix(str2double(tempch));
    DevID = (tempch == DevID)'*DevID;
    if(DevID > 0), break; end
  end
  rec = audiorecorder(fs,nbits,chans,DevID);
  rec.Tag = 'Sampled signal';
  rec.UserData = siglen;
  keep('rec','siglen','dec')
  y = [];
  while(rec.UserData > 0)
    recordblocking(rec,dec);
    y = [y; getaudiodata(rec,'double')];
    clc
    disp(strcat(num2str(floor...
    (100-percent_q(rec.UserData,siglen)))...
    ,'% Complete'))
    rec.UserData = rec.UserData - dec;
    if(rec.UserData < dec)
      dec = rec.UserData;
    end
  end
  t = (1:length(y))'*(siglen/length(y));
  y = double(y);
  y=y/ max(max(abs(y)));
  clc
  disp('100% Complete')
end

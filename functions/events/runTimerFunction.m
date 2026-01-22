function runTimerFunction(obj, event)
  global DFT;
  global AP;
  if(isplaying(obj))
    if(obj.CurrentSample > (obj.TotalSamples - obj.SampleRate))
      if(isempty(DFT) || ~isstruct(DFT))
        warning('Main structure is empty!');
        return;
      end
      stop(obj);
      DFT.Play.Cur   = getNextValidID(DFT.Play.Lst,DFT.Play.Cur,DFT.Play.Mod);
      DFT.Path       = DFT.Play.Lst{DFT.Play.Cur};
      % Load the next file as it it prevoiusly validated on adding
      [DFT.Signal,DFT.SampleRate,DFT.SampleBits,DFT.Format] = mp3read(DFT.Path);
      DFT.Signal     = fixInputIn2Co(DFT.Signal);
      DFT.SampleRateDefault = DFT.SampleRate;
      AP = audioplayer(DFT.Signal,DFT.SampleRate,DFT.SampleBits,DFT.DeviceID);
      AP.Tag = slashstringn(DFT.Path,length(DFT.Path));
      dispMp3Info(DFT.Format, AP);
      play(AP);
      set(AP, 'TimerPeriod', 0.1);
      set(AP, 'TimerFcn', @runTimerFunction);
    end
  end
end
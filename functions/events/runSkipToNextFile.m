function runSkipToNextFile(obj, event)
  if(isplaying(obj))
    if(obj.CurrentSample > (obj.TotalSamples - obj.SampleRate))
      DFT = get(obj, 'UserData');
      stop(obj);
      DFT.Play.Cur   = getNextValidID(DFT.Play.Lst,DFT.Play.Cur,DFT.Play.Mod);
      DFT.Path       = DFT.Play.Lst{DFT.Play.Cur};
      % Load the next file as it it prevoiusly validated on adding
      [DFT.Signal,DFT.SampleRate,DFT.SampleBits,DFT.Format] = mp3read(DFT.Path);
      DFT.Signal     = fixInputIn2Co(DFT.Signal);
      DFT.SampleRateDefault = DFT.SampleRate;
      obj     = audioplayer(DFT.Signal,DFT.SampleRate,DFT.SampleBits,DFT.DeviceID);
      obj.Tag = slashstringn(DFT.Path,length(DFT.Path));
      dispMp3Info(DFT.Format,obj);
      play(obj);
      set(obj, 'TimerPeriod', 0.1);
      set(obj, 'TimerFcn', @runSkipToNextFile);
      set(obj, 'UserData', DFT);
      set(obj, 'UserData', DFT);
    end
  end
end
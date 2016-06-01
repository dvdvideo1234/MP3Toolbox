function [] = mp3rate(mp3,rate)
  % Changes the sampling rate of an audioplayer object
  % Takes the object and the rate difference
  % Call "[] = mp3rate(mp3,rate)"
  pause(mp3); mp3.SampleRate=mp3.SampleRate+rate; resume(mp3);
end
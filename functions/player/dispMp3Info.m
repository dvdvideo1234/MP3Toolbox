function dispMp3Info(opts,mp3)
  % Displays info about aoudiplayer and audiodata
  clc;
  s = ((opts.fmt.mpgNFrames*opts.fmt.mpgSampsPerFrame)/(opts.fmt.nSamplesPerSec));
  [h, m, s] = hms_time(s);
  fprintf('Now playing: %s\n', mp3.Tag);
  fprintf('  MPEG    : %d\n', opts.fmt.mpgVersion);
  fprintf('  Layer   : %s\n', opts.fmt.mpgLayer);
  fprintf('  BitRate : %d kb/s\n', (opts.fmt.mpgBitrate/1000));
  fprintf('  Channels: %d (%s)\n', opts.fmt.nChannels, opts.fmt.mpgChanmode);
  fprintf('  BitsSamp: %d\n', opts.fmt.nBitsPerSample);
  fprintf('  Sampling: %d Hz\n', opts.fmt.nSamplesPerSec);
  if(h > 0)
    fprintf('  Duration: %dh %dm %ds\n', h, m, s);
  elseif(m > 0)
    fprintf('  Duration: %dm %ds\n', m, s);
  else
    fprintf('  Duration: %ds\n', s);
  end  
  disp(' ');
end

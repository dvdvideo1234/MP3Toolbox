function dispMp3Info(opts,mp3)
  % Displays info about aoudiplayer and audiodata
  clc;
  fprintf('Now playing: %s\n', mp3.Tag);
  fprintf('  MPEG    : %d\n', opts.fmt.mpgVersion);
  fprintf('  Layer   : %s\n', opts.fmt.mpgLayer);
  fprintf('  BitRate : %d kb/s\n', (opts.fmt.mpgBitrate/1000));
  fprintf('  Channels: %d (%s)\n', opts.fmt.nChannels, opts.fmt.mpgChanmode);
  fprintf('  BitsSamp: %d\n', opts.fmt.nBitsPerSample);
  fprintf('  Sampling: %d Hz\n', opts.fmt.nSamplesPerSec);
  fprintf('  Duration: %f min\n', ((opts.fmt.mpgNFrames*opts.fmt.mpgSampsPerFrame)/(60*opts.fmt.nSamplesPerSec)));
  disp(' ');
end

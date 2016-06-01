function dispMp3Info(opts,mp3)
  % Displays info about aoudiplayer and audiodata
  fprintf('Now playing >> %s',mp3.Tag);
  fprintf('\nMpeg version %s layer %s bitrate %s kb/s of %s %s',num2str(opts.fmt.mpgVersion),...
      opts.fmt.mpgLayer,num2str(opts.fmt.mpgBitrate/1000),opts.fmt.mpgChanmode,opts.fmt.mpgPad);
  fprintf('\nStream %s channels %s bits per sample %s Khz %s minutes',num2str(opts.fmt.nChannels),...
      num2str(opts.fmt.nBitsPerSample),num2str(opts.fmt.nSamplesPerSec/1000),...
      num2str((opts.fmt.mpgNFrames*opts.fmt.mpgSampsPerFrame)/(60*opts.fmt.nSamplesPerSec)));
  disp(' ');
end

function [] = setup_mp3_toolbox()
  base = strrep(pwd(),'\octave','');
  %----------------------------------------%
  addpath(strcat(base,'\octave'));
  addpath(strcat(base,'\functions\common'));
  addpath(strcat(base,'\functions\dft'));
  addpath(strcat(base,'\functions\ffts'));
  addpath(strcat(base,'\functions\player'));
  addpath(strcat(base,'\functions\mp3readwrite'));
end
  
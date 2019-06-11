function [] = octave_addpath()
  base = strrep(pwd(),'\octave','');
  %----------------------------------------%
  addpath(strcat(base,'\octave'));
  addpath(strcat(base,'\functions\common'));
  addpath(strcat(base,'\functions\dft'));
  addpath(strcat(base,'\functions\ffts'));
  addpath(strcat(base,'\functions\player'));
  addpath(strcat(base,'\mp3_toolbox'));
  addpath(strcat(base,'\mp3_toolbox\mp3write'));
  addpath(strcat(base,'\mp3_toolbox\mp3reader'));
end
  
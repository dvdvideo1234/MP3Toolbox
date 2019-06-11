function []=addpath(sPth)
  sBas = strrep(pwd(),'\octave','');
  %----------------------------------------%
  addpath(strcat(sBas,'\octave'));
  addpath(strcat(sBas,'\functions\common'));
  addpath(strcat(sBas,'\functions\dft'));
  addpath(strcat(sBas,'\functions\ffts'));
  addpath(strcat(sBas,'\functions\player'));
  addpath(strcat(sBas,'\mp3_toolbox'));
  addpath(strcat(sBas,'\mp3_toolbox\mp3write'));
  addpath(strcat(sBas,'\mp3_toolbox\mp3reader'));
end
  
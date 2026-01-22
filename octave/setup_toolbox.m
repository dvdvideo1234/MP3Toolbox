function [] = setup_toolbox()
  base = fileparts(pwd());
  %----------------------------------------%
  addpath(fullfile(base, 'octave'));
  addpath(fullfile(base, 'functions', 'dft'));
  addpath(fullfile(base, 'functions', 'ffts'));
  addpath(fullfile(base, 'functions', 'common'));
  addpath(fullfile(base, 'functions', 'player'));
  addpath(fullfile(base, 'functions', 'events'));
  addpath(fullfile(base, 'functions', 'mp3readwrite'));
end

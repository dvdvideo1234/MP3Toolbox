function [] = setup_toolbox()
  % Read the base folder
  base = fileparts(pwd());

  % Setup toolbox active folders
  addpath(fullfile(base, 'octave'));
  addpath(fullfile(base, 'functions', 'dft'));
  addpath(fullfile(base, 'functions', 'ffts'));
  addpath(fullfile(base, 'functions', 'common'));
  addpath(fullfile(base, 'functions', 'player'));
  addpath(fullfile(base, 'functions', 'events'));
  addpath(fullfile(base, 'functions', 'mp3readwrite'));

  % Install dependencies
  deps = {'signal'};
  pkg_list = pkg("list"); % Get list of all installed packages
  fprintf('Installing dependencies...\n');
  for z = 1:length(deps)
    % Initialize
    pkg_name = deps{z};
    pkg_info = pkg('describe', '-verbose', pkg_name);
    % Initialize
    pkg_info = pkg_info{1};
    pkg_size = size(pkg_info);
    if(pkg_size(1) == 1 && pkg_size(2) == 1)
      % Check forge
      is_forged = false;
      id_forged = 0;
      forge_pkgs = pkg("list", "-forge");
      for i = 1:length(forge_pkgs)
        pkg_item = forge_pkgs{i};
        if strcmp(pkg_item, pkg_name)
          is_forged = true;
          id_forged = i;
          break;
        end
      end
      % Check load
      id_loaded = 0;
      is_loaded = false;
      for i = 1:length(pkg_list)
        pkg_item = pkg_list{i};
        if strcmp(pkg_item.name, pkg_name)
          is_loaded = pkg_item.loaded;
          id_loaded = i;
          break;
        end
      end
      % Prepare status
      s_forged = ifelse(is_forged, 'V', 'X');
      s_loaded = ifelse(is_loaded, 'V', 'X');
      % Show status forge
      fprintf('  Process [%d][%s][%s]: %s\n', z, s_forged, s_loaded, pkg_name);
      % Show status
      if(strcmp(s_forged, 'X'))
        fprintf('    Forging: [%d] %s (%s) : %s\n', z, pkg_info.name, pkg_info.version, pkg_info.description);
        fprintf('      (%d) [%s]: %s \n', id_forged, pkg_info.date, pkg_info.url);
        pkg("install", "-forge", pkg_name);
      else
        fprintf('    Present: [%d] %s (%s) : %s\n', z, pkg_info.name, pkg_info.version, pkg_info.description);
        fprintf('      (%d) [%s]: %s \n', id_forged, pkg_info.date, pkg_info.url);
      end
      % Show status load
      pkg_info = pkg_list{i};
      if(strcmp(s_loaded, 'X'))
        fprintf('    Loading: [%d] %s (%s) : %s\n', z, pkg_info.name, pkg_info.version, pkg_info.title);
        fprintf('      (%d) [%s]: %s \n', id_loaded, pkg_info.date, pkg_info.dir);
        pkg("load", pkg_name);
      else
        fprintf('    Present: [%d] %s (%s) : %s\n', z, pkg_info.name, pkg_info.version, pkg_info.title);
        fprintf('      (%d) [%s]: %s \n', id_loaded, pkg_info.date, pkg_info.dir);
      end
    else
      fprintf('  Missing [%d] : %s\n', z, pkg_name);
    end
  end
end

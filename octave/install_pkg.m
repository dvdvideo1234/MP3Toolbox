% https://octave.sourceforge.io/packages.php

function install_pkg()
  deps = {'signal'};
  pkg_list = pkg("list"); % Get list of all installed packages
  fprintf('Installing dependencies...\n');
  for i = 1:length(deps)
    % Initialize
    pkg_name = deps{i};
    pkg_info = pkg('describe', '-verbose', pkg_name);
    pkg_size = size(pkg_info);
    if(pkg_size(1) == pkg_size(2))
      % Initialize
      pkg_info = pkg_info{1};
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
      fprintf('  Process [%s][%s]: %s\n', s_forged, s_loaded, pkg_name);
      % Show status
      if(strcmp(s_forged, 'X'))
        fprintf('    Forging: %s (%s) : %s\n', pkg_info.name, pkg_info.version, pkg_info.description);
        fprintf('      (%d) [%s]: %s \n', id_forged, pkg_info.date, pkg_info.url);
        pkg("install", "-forge", pkg_name);
      else
        fprintf('    Present: %s (%s) : %s\n', pkg_info.name, pkg_info.version, pkg_info.description);
        fprintf('      (%d) [%s]: %s \n', id_forged, pkg_info.date, pkg_info.url);
      end
      % Show status load
      pkg_info = pkg_list{i};
      if(strcmp(s_loaded, 'X'))
        fprintf('    Loading: %s (%s) : %s\n', pkg_info.name, pkg_info.version, pkg_info.title);
        fprintf('      (%d) [%s]: %s \n', id_loaded, pkg_info.date, pkg_info.dir);
        pkg("load", pkg_name);
      else
        fprintf('    Present: %s (%s) : %s\n', pkg_info.name, pkg_info.version, pkg_info.title);
        fprintf('      (%d) [%s]: %s \n', id_loaded, pkg_info.date, pkg_info.dir);
      end
    end
  end
end
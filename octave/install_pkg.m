% https://octave.sourceforge.io/packages.php

function install_pkg()
  deps = {'signal'};
  pkg_list = pkg("list"); % Get list of all installed packages
  fprintf('Installing dependencies...\n');
  for i = 1:length(deps)
    % Initialize
    pkg_name = deps{i};
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
    if(strcmp(s_forged, 'X'))
      fprintf('    Forging: %s\n', pkg_name);
      pkg("install", "-forge", pkg_name);
    end
    % Show status load
    if(strcmp(s_loaded, 'X'))
      fprintf('    Loading: %s\n', pkg_name);
      pkg("load", pkg_name);
    else
      pkg_item = pkg_list{i};
      fprintf('    Present: %s (%s): %s\n', pkg_name, pkg_item.version, pkg_item.title);
    end
    %pkg("install", "-forge", deps{i});
    %pkg("install", "-forge", deps{i});
    
    
    %pkg install -forge ;
    %pkg load deps{i};
  end
end
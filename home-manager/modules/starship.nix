{ config, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      command_timeout = 500;

      format = "[$git_branch$git_commit$git_status$git_state$git_metrics\\[$username@nixos:$directory\\]\\$ ](bold fg:green)";

      right_format = "";
      scan_timeout = 30;

      directory = {
        disabled = false;
        fish_style_pwd_dir_length = 0; # show full path
        format = "$path$read_only";
        home_symbol = "~";
        truncate_to_repo = false;
        use_logical_path = true;
        use_os_path_sep = true;
      };

      username = { format = "$user"; show_always = true; disabled = false; };
      hostname = { format = "$hostname"; disabled = false; };

      git_branch = { format = " $branch "; };
      git_commit = { commit_hash_length = 7; format = "$hash;"; only_detached = true; };
      git_metrics = { format = "($added +$added$deleted -$deleted) "; only_nonzero_diffs = true; };
      git_status = { ahead = "$count ahead;"; behind = "$count behind;"; modified = "modified;"; staged = "staged;"; };
      git_state = { format = "$state"; };
    };
  };
}


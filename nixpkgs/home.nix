{ config, pkgs, lib, ... }:
let
  kubectx = pkgs.callPackage ./pkgs/kubectx {  };
  kubens = pkgs.callPackage ./pkgs/kubens {  };
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "hawjia";
  home.homeDirectory = "/home/hawjia";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  home.packages = [
    pkgs.htop
    pkgs.ripgrep
    pkgs.fd
    pkgs.jq
    pkgs.yq
    pkgs.docker
    pkgs.kubectl
    (pkgs.python3.withPackages (p: with p; [
      ipython
      pylint
      requests
      pip
      python-lsp-server
      autopep8
      pyyaml
    ]))
    pkgs.gopls
    pkgs.tree-sitter
    kubectx
    kubens
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.tmux = {
    enable = true;
    terminal = "alacritty";
    extraConfig = lib.strings.fileContents ./tmux.conf;
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    initExtra = ''
      if [ -e /home/hawjia/.nix-profile/etc/profile.d/nix.sh ]; then
        . /home/hawjia/.nix-profile/etc/profile.d/nix.sh
      fi

      set -o vi
      bindkey '^y' autosuggest-accept

      KUBECONFIG_DIR="$HOME/.kubeconfigs"
      mkdir -p "$KUBECONFIG_DIR"
      OIFS="$IFS"
      IFS=$'\n'
      for kubeconfigFile in `find "$KUBECONFIG_DIR" -type f -name "*.yml" -o -name "*.yaml"`
      do
          export KUBECONFIG="$kubeconfigFile:$KUBECONFIG"
      done
      IFS="$OIFS"
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "kubectl"
        "golang"
        "docker"
      ];
    };


    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = builtins.toString ./.;
        file = "p10k-config.zsh";
      }
    ];

    shellAliases = {
      goversion = "TZ=UTC git --no-pager show --quiet --abbrev=12 --date='format-local:%Y%m%d%H%M%S' --format=\"%cd-%h\"";
      kc = "kubectx";
      kns = "kubens";
    };
  };

  programs.fzf = {
   enable = true;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    withNodeJs = true;
    withPython3 = true;

    plugins = with pkgs.vimPlugins; [
      packer-nvim
    ];
    extraConfig = ''
      lua <<EOF
      ${lib.strings.fileContents ./nvim/basics.lua}
      ${lib.strings.fileContents ./nvim/keybindings.lua}
      ${lib.strings.fileContents ./nvim/filetypes.lua}
      ${lib.strings.fileContents ./nvim/plugins.lua}
    EOF
    '';
  };

  programs.gpg = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = "limhawjia";
    userEmail = "hawjiaadev@gmail.com";
    aliases = {
      tree = "log --all --decorate --oneline --graph";
      dtree = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(revim.opt. - %C(bold green)(%ar)%C(revim.opt. %C(white)%s%C(revim.opt. %C(dim white)- %an%C(revim.opt.%C(bold yellow)%d%C(revim.opt.' --all";
    };
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      pull.ff = "only";
    };
  };

  programs.bat = {
    enable = true;
  };
}

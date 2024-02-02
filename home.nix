{ config, pkgs, lib, ... }:
let
  dotfilesFolder = (baseDir:
    let
      makePath = (breadcrumbs: baseDir + "/${lib.strings.concatStringsSep "/" breadcrumbs}");
      fileImport = (breadcrumbs:
        {"${lib.strings.concatStringsSep "/" (lib.lists.drop 1 breadcrumbs)}".source = makePath breadcrumbs; });
      firstIterDir = (breadcrumbs: let
          fileSet = builtins.readDir (makePath breadcrumbs);
          processItem = (location: type: let
              breadcrumbs' = breadcrumbs ++ [location];
            in
              if
                type == "directory" && location != ".git"
              then
                iterDir breadcrumbs'
              else
                []
          );
        in
          lib.attrsets.mapAttrsToList processItem fileSet
      );
      iterDir = (breadcrumbs: let
          fileSet = builtins.readDir (makePath breadcrumbs);
          processItem = (location: type: let
              breadcrumbs' = breadcrumbs ++ [location];
            in
              if
                type == "regular"
              then
                [ (fileImport breadcrumbs') ]
              else if
                type == "directory"
              then
                iterDir breadcrumbs'
              else
                []
          );
        in
          lib.attrsets.mapAttrsToList processItem fileSet
      );
    in
      lib.attrsets.mergeAttrsList (lib.lists.flatten (firstIterDir []))
  );
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "renault";
  home.homeDirectory = "/home/renault";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    pkgs.neovim
    pkgs.nerdfonts
    (pkgs.python311.withPackages (p: with p; [
      apsw
    ]))

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];


  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = dotfilesFolder ".";
#  home.file = {
#    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
#    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
#    # # symlink to the Nix store copy.
#    tmux = { source = dotfiles/tmux; target = "./"; recursive = true; };
#    # git = { source = dotfiles/git; target = "./"; recursive = true; };
#    #"t".source = ./dotfiles/git;
#    #"t".recursive = true;
#    # ".screenrc".source = dotfiles/screenrc;
#
#    # # You can also set the file content immediately.
#    # ".gradle/gradle.properties".text = ''
#    #   org.gradle.console=verbose
#    #   org.gradle.daemon.idletimeout=3600000
#    # '';
#  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/renault/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    TEST_VVV = "test";
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  systemd.user.services.rnproxy = {
    Unit = {
      Description = "rnproxy";
      Documentation = "https://confluence.dt.renault.com/display/IRN69529/Configure+Renault+internet+proxy+on+ubuntu";
    };

    Install.WantedBy = [ "multi-user.target" ];
    Service = {
      Type = "simple";
      ExecStart = " rnproxy --addr 127.0.0.1:911 -v";
      Restart = "always";
    };
  };

}

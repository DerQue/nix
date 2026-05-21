{
  pkgs,
  config,
  lib,
  ...
}:

{
  environment.systemPackages = [
    pkgs.starship
    pkgs.fish
  ];

  programs.fish.enable = true;

  users.users.${config.userConfig.name} = {
    shell = pkgs.fish;
  };

  home-manager.users.${config.userConfig.name} = {
    programs.alacritty = {
      enable = true;

      settings = {
        terminal.shell = {
          program = "${pkgs.fish}/bin/fish";
          args = [ "--login" ];
        };

        window = {
          padding = {
            x = 10;
            y = 10;
          };
          decorations = "transparent";
          dynamic_padding = true;
        };

        font = {
          offset = {
            y = 2; # fix pill spacing
          };
        };

        keyboard.bindings = [
          {
            key = "C";
            mods = "Command";
            action = "Copy";
          }
          {
            key = "V";
            mods = "Command";
            action = "Paste";
          }
        ];
      };
    };

    programs.fish = {
      enable = true;

      shellAliases = {
        ll = "ls -la";
        update = "darwin-rebuild switch --flake ~/.nix#macbook";
      };

      interactiveShellInit = ''
        set -g fish_greeting ""
      '';
    };

    programs.starship = {
      enable = true;
      enableFishIntegration = true;

      presets = [ "nerd-font-symbols" ];

      settings =
        (lib.genAttrs
          [
            "c"
            "cmake"
            "cobol"
            "daml"
            "dart"
            "deno"
            "dotnet"
            "elixir"
            "elm"
            "erlang"
            "fennel"
            "fortran"
            "gleam"
            "golang"
            "guix_shell"
            "haskell"
            "haxe"
            "helm"
            "java"
            "julia"
            "kotlin"
            "gradle"
            "lua"
            "nim"
            "nodejs"
            "ocaml"
            "opa"
            "perl"
            "php"
            "pulumi"
            "purescript"
            "python"
            "quarto"
            "raku"
            "rlang"
            "red"
            "ruby"
            "rust"
            "scala"
            "solidity"
            "swift"
            "terraform"
            "typst"
            "vlang"
            "vagrant"
            "zig"
          ]
          (lang: {
            format = "[](#${config.lib.stylix.colors.base02})[ $symbol($version )](bg:#${config.lib.stylix.colors.base02} fg:$style)[](#${config.lib.stylix.colors.base02}) ";
          })
        )
        // {

          add_newline = true;

          format = lib.concatStrings [
            " $os $username "
            "[](#${config.lib.stylix.colors.base02})[$directory$git_branch$git_status](bg:#${config.lib.stylix.colors.base02})[](#${config.lib.stylix.colors.base02}) "
            "$c$cmake$cobol$daml$dart$deno$dotnet$elixir$elm$erlang$fennel$fortran$gleam$golang$guix_shell$haskell$haxe$helm$java$julia$kotlin$gradle$lua$nim$nodejs$ocaml$opa$perl$php$pulumi$purescript$python$quarto$raku$rlang$red$ruby$rust$scala$solidity$swift$terraform$typst$vlang$vagrant$zig"
            "\n "
          ];

          os = {
            disabled = false;
            style = "#${config.lib.stylix.colors.base07}";
          };

          directory = {
            format = "[$path]($style)[$read_only]($read_only_style)";
            style = "bg:#${config.lib.stylix.colors.base02} fg:#${config.lib.stylix.colors.base07}";
            read_only_style = "bg:#${config.lib.stylix.colors.base02} fg:#${config.lib.stylix.colors.base08}";

            truncate_to_repo = false;
            before_repo_root_style = "bg:#${config.lib.stylix.colors.base02} fg:#${config.lib.stylix.colors.base07}";
            repo_root_style = "#${config.lib.stylix.colors.base07}";
            repo_root_format = "[$before_root_path$repo_root]($before_repo_root_style)[$read_only]($read_only_style)[](#${config.lib.stylix.colors.base02})[ ](bg:#${config.lib.stylix.colors.base00})[](#${config.lib.stylix.colors.base02})[$path/]($style) ";
          };

          git_branch = {
            format = "[on](bg:#${config.lib.stylix.colors.base02} fg:#${config.lib.stylix.colors.base04}) [$symbol$branch(:$remote_branch)]($style) ";
            style = "bg:#${config.lib.stylix.colors.base02} fg:#${config.lib.stylix.colors.base07}";
          };

          git_status = {
            style = "bg:#${config.lib.stylix.colors.base02} fg:#${config.lib.stylix.colors.base04}";
            format = "([\\($all_status$ahead_behind\\)]($style))";
          };

          username = {
            style_root = "#${config.lib.stylix.colors.base08}";
            style_user = "#${config.lib.stylix.colors.base0B}";
            format = "[]($style)[$user](bg:$style fg:#${config.lib.stylix.colors.base00})[]($style)";
            show_always = true;
          };
        };
    };

    programs.tmux = {
      enable = true;
    };
  };

}

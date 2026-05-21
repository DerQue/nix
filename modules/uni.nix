{ pkgs, config, ... }:
{
  environment.systemPackages = [
    pkgs.tinymist
    pkgs.typst
    pkgs.ghc
  ];

  home-manager.users.${config.userConfig.name} = {
    programs.nixvim = {
      plugins = {
        lsp.servers = {
          tinymist = {
            enable = true;
            extraOptions.offset_encoding = "utf-8";
            settings.exportPdf = "never";
          };

          hls = {
            enable = true;
          };
        };

        typst-preview = {
          enable = true;
          settings = {
            debug = true;
            extra_args = [
              "--font-path"
              "./template/base/fonts"
            ];
          };
        };
      };

      keymaps = [
        {
          mode = "n";
          key = "<leader>tp";
          action = "<cmd>TypstPreview<CR>";
          options.desc = "Typst Live Preview starten";
        }
      ];
    };
  };
}

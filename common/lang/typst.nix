{ pkgs, user, ... }:
{
  environment.systemPackages = [
    pkgs.tinymist
    pkgs.typst
  ];

  home-manager.users.${user} = {
    programs.nixvim = {
      plugins = {
        lsp.servers.tinymist = {
          enable = true;
          extraOptions.offset_encoding = "utf-8";
          settings.exportPdf = "never";
        };

        typst-preview = {
          enable = true;
          settings = {
            debug = false;
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
          options.desc = "Typst Live Preview";
        }
      ];
    };
  };
}

{ config, pkgs, ... }:
{
  environment.systemPackages = [ pkgs.ripgrep ];

  home-manager.users.${config.userConfig.name} = {

    programs.nixvim = {
      enable = true;

      opts = {
        foldlevel = 99;
        foldlevelstart = 99;

        tabstop = 2;
        shiftwidth = 2;
        softtabstop = 2;

        expandtab = true;

        smartindent = true;

        number = true;
        relativenumber = true;
        signcolumn = "yes";
      };

      globals.mapleader = " ";

      diagnostics = {
        virtual_text = true;

        signs = true;

        underline = true;

        severity_sort = true;
      };

      plugins = {
        treesitter = {
          enable = true;
          highlight.enable = true;
          indent.enable = true;
          folding.enable = true;
        };

        lsp = {
          enable = true;

          inlayHints = true;

          servers = {
            lua_ls.enable = true;
            bashls.enable = true;
            nixd.enable = true;
          };
        };

        conform-nvim = {
          enable = true;
          settings = {
            format_on_save = {
              lsp_fallback = true;
              timeout_ms = 500;
            };
            formatters_by_ft = {
              nix = [ "nixfmt" ];
              "_" = [ "trim_whitespace" ];
            };
          };
        };

        telescope = {
          enable = true;

          keymaps = {
            "<leader>ff" = "find_files";
            "<leader>fg" = "live_grep";
            "<leader>fb" = "buffers";
            "<leader>fh" = "help_tags";
          };
        };

        nvim-autopairs = {
          enable = true;
          settings = {
            check_ts = true;
            disable_filetype = [ "TelescopePrompt" ];
          };
        };

        cmp = {
          enable = true;
          settings = {
            sources = [
              { name = "nvim_lsp"; }
              { name = "path"; }
              { name = "buffer"; }
            ];

            mapping = {
              "<C-Space>" = "cmp.mapping.complete()";
              "<CR>" = "cmp.mapping.confirm({ select = true })";
              "<Tab>" = "cmp.mapping.select_next_item()";
              "<S-Tab>" = "cmp.mapping.select_prev_item()";
            };
          };
        };

        cmp-nvim-lsp.enable = true;
        cmp-path.enable = true;
        cmp-buffer.enable = true;
      };

      extraConfigLua = ''
        local cmp = require('cmp')
        local handlers = require('nvim-autopairs.completion.cmp')
        cmp.event:on('confirm_done', handlers.on_confirm_done())
      '';
    };
  };
}

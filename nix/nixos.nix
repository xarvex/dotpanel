{ self, ... }:
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.dotpanel;

  tomlFormat = pkgs.formats.toml { };
in
{
  options.programs.dotpanel = {
    enable = lib.mkEnableOption "dotpanel";
    package = lib.mkPackageOption self.packages.${pkgs.system} "dotpanel" {
      default = "dotpanel";
    };
    settings = lib.mkOption {
      inherit (tomlFormat) type;
      default = { };
      example = lib.literalExpression ''
        {
          foo = {
            bar = true;
            foobar = 10;
          };
        };
      '';
      description = "Configuration used for dotpanel.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = with cfg; [ package ];
      etc."dotpanel/config.toml".source = lib.mkIf (cfg.settings != { }) (
        tomlFormat.generate "dotpanel-settings" cfg.settings
      );
    };
  };
}

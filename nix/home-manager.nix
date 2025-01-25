{ self }:
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.dotpanel;
in
{
  options.programs.dotpanel = {
    enable = lib.mkEnableOption "dotpanel";
    package = lib.mkPackageOption self.packages.${pkgs.system} "dotpanel" { };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with cfg; [ package ];

    systemd.user.services.dotpanel = {
      Unit = {
        Description = "dotpanel";
        After = [ config.wayland.systemd.target ];
        PartOf = [ config.wayland.systemd.target ];
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };

      Service = {
        ExecStart = "${lib.getExe cfg.package} --daemon";
        Restart = "on-failure";
      };

      Install.WantedBy = [ config.wayland.systemd.target ];
    };
  };
}

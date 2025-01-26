public class Dotpanel.HostBarModule : Dotpanel.BarModule {
    construct {
        var icon = new Gtk.Image();

        icon.halign = Gtk.Align.CENTER;
        icon.valign = Gtk.Align.CENTER;

        icon.icon_name = "linux-nixos-symbolic";

        append(icon);
    }
}

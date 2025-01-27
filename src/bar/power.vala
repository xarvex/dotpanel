public class Dotpanel.PowerBarModule : Dotpanel.BarModule {
    construct {
        var icon = new Gtk.Image();

        icon.halign = Gtk.Align.CENTER;
        icon.valign = Gtk.Align.CENTER;

        icon.icon_name = "md-power-settings-symbolic";

        append(icon);
    }
}

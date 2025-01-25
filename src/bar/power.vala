public class Dotpanel.PowerBarModule : Dotpanel.BarModule {
    construct {
        var icon = new Gtk.Image();

        icon.add_css_class("indicator-icon");

        icon.halign = Gtk.Align.CENTER;
        icon.valign = Gtk.Align.CENTER;

        icon.icon_name = "power-settings-symbolic";

        append(icon);
    }
}

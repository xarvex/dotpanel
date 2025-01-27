public class Dotpanel.TimeBarModule : Dotpanel.BarModule {
    private AstalIO.Time interval = AstalIO.Time.interval(1000, null);

    private Gtk.Image icon = new Gtk.Image();
    private Gtk.Label clock = new Gtk.Label(null);

    private void sync() {
        var now = new DateTime.now_local();

        switch (now.get_hour()) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
            icon.icon_name = "md-weather-night-symbolic";
            break;
        case 6:
        case 7:
        case 8:
        case 9:
        case 10:
            icon.icon_name = "cod-coffee-symbolic";
            break;
        case 11:
        case 12:
        case 13:
        case 14:
        case 15:
        case 16:
        case 17:
        case 18:
            icon.icon_name = "md-window-closed-variant-symbolic";
            break;
        case 19:
        case 20:
        case 21:
            icon.icon_name = "md-weather-sunset-symbolic";
            break;
        case 22:
        case 23:
            icon.icon_name = "md-weather-night-symbolic";
            break;
        }

        clock.label = now.format("%H:%M");
    }

    construct {
        add_css_class("spaced");
        clock.add_css_class("monospaced");

        interval.now.connect(sync);

        append(icon);
        append(clock);
    }
}

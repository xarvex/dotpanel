public class Dotpanel.TimeBarModule : Dotpanel.BarModule {
    private AstalIO.Time interval = AstalIO.Time.interval(1000, null);

    private Gtk.Label icon = new Gtk.Label(null);
    private Gtk.Label clock = new Gtk.Label(null);

    private void sync() {
        var now = new GLib.DateTime.now_local();

        switch (now.get_hour()) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
            icon.label = "󰖔 ";
            break;
        case 6:
        case 7:
        case 8:
        case 9:
        case 10:
            icon.label = " ";
            break;
        case 11:
        case 12:
        case 13:
        case 14:
        case 15:
        case 16:
        case 17:
        case 18:
            icon.label = "󰥟 ";
            break;
        case 19:
        case 20:
        case 21:
            icon.label = "󰖚 ";
            break;
        case 22:
        case 23:
            icon.label = "󰖔 ";
            break;
        }

        clock.label = now.format("%H:%M");
    }

    construct {
        icon.add_css_class("time");
        clock.add_css_class("time");

        append(icon);
        append(clock);

        interval.now.connect(sync);
    }
}

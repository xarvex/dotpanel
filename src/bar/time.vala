public class Dotpanel.TimeBarModule : Astal.Box {
    private AstalIO.Time interval = AstalIO.Time.interval(1000, null);

    private Gtk.Label clock_icon = new Gtk.Label(null);
    private Gtk.Label clock_time = new Gtk.Label(null);

    private void sync() {
        var now = new GLib.DateTime.now_local();

        switch (now.get_hour()) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
            clock_icon.label = "󰖔 ";
            break;
        case 6:
        case 7:
        case 8:
        case 9:
        case 10:
            clock_icon.label = " ";
            break;
        case 11:
        case 12:
        case 13:
        case 14:
        case 15:
        case 16:
        case 17:
        case 18:
            clock_icon.label = "󰥟 ";
            break;
        case 19:
        case 20:
        case 21:
            clock_icon.label = "󰖚 ";
            break;
        case 22:
        case 23:
            clock_icon.label = "󰖔 ";
            break;
        }

        clock_time.label = now.format("%H:%M");
    }

    construct {
        add_css_class("bar-widget-module");

        margin_start = 6;
        margin_end = 6;

        clock_icon.add_css_class("time");
        clock_time.add_css_class("time");

        append(clock_icon);
        append(clock_time);

        interval.now.connect(sync);
    }
}

public class Dotpanel.Bar : Astal.Window {
    public Bar(Gdk.Monitor monitor) {
        Object(gdkmonitor: monitor);

        var center_box = new Gtk.CenterBox() {
            orientation = Gtk.Orientation.HORIZONTAL,
        };

        var start_widget = new Astal.Box();

        var center_widget = new Dotpanel.WorkspaceBarModule(monitor.connector);
        var end_widget = new Astal.Box();

        start_widget.append(new Dotpanel.HostBarModule());
        start_widget.append(new Dotpanel.TimeBarModule());

        end_widget.append(new Dotpanel.BatteryBarModule());
        end_widget.append(new Dotpanel.PowerBarModule());

        center_box.start_widget = start_widget;

        center_box.center_widget = center_widget;
        center_box.end_widget = end_widget;

        child = center_box;
    }

    construct {
        add_css_class("bar");

        // Not having `this` causes formatting to break?
        this.namespace = "dotpanel-bar";

        anchor = Astal.WindowAnchor.TOP
            | Astal.WindowAnchor.LEFT
            | Astal.WindowAnchor.RIGHT;
        exclusivity = Astal.Exclusivity.EXCLUSIVE;
        keymode = Astal.Keymode.NONE;
        layer = Astal.Layer.BOTTOM;
    }
}

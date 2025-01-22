class Dotpanel.Bar : Astal.Window {
    public Bar(Gdk.Monitor monitor) {
        Object(gdkmonitor: monitor);

        var center_box = new Gtk.CenterBox() {
            orientation = Gtk.Orientation.HORIZONTAL,
        };

        var start_widget = new Astal.Box();
        var center_widget = new Gtk.CenterBox() {
            orientation = Gtk.Orientation.HORIZONTAL,
        };
        var end_widget = new Astal.Box();
        start_widget.add_css_class("bar-widget");
        center_widget.add_css_class("bar-widget");
        end_widget.add_css_class("bar-widget");

        center_widget.center_widget = new Dotpanel.WorkspaceBarModule(monitor.connector);
        center_widget.end_widget = new Dotpanel.TimeBarModule();

        center_box.start_widget = start_widget;
        center_box.center_widget = center_widget;
        center_box.end_widget = end_widget;

        child = center_box;
    }

    construct {
        add_css_class("bar");

        margin_top = 4;

        application = Dotpanel.Application.instance;
        namespace = "dotpanel-bar";

        anchor = Astal.WindowAnchor.TOP
            | Astal.WindowAnchor.LEFT
            | Astal.WindowAnchor.RIGHT;
        exclusivity = Astal.Exclusivity.EXCLUSIVE;
        keymode = Astal.Keymode.NONE;
        layer = Astal.Layer.BOTTOM;
    }
}

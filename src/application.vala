public class Dotpanel.Application : Astal.Application {
    private static Dotpanel.LauncherMenu? launcher_menu = null;

    public override void request(string message, SocketConnection connection) {
        switch (message) {
        case "menu-launcher" : if (launcher_menu != null) launcher_menu.present();
            break;
        default:
            AstalIO.write_sock.begin(connection, @"The response implementation on $(instance_name) is missing");
            break;
        }
    }

    public override void activate() {
        base.activate();

        var display = Gdk.Display.get_default();

        var icon_theme = Gtk.IconTheme.get_for_display(display);
        icon_theme.add_resource_path("/org/codeberg/xarvex/dotpanel/icons");

        var css_provider = new Gtk.CssProvider();
        css_provider.load_from_resource("/org/codeberg/xarvex/dotpanel/style.css");

        // INFO: Not actually deprecated, bindings issue. Static methods are fine.
        // See: https://discourse.gnome.org/t/what-good-is-gtkcssprovider-without-gtkstylecontext/12621/2
        // See: https://discourse.gnome.org/t/correct-way-to-set-style-without-using-stylecontext/15454/4
        // See: https://discourse.gnome.org/t/gtkcssprovider-is-deprecated-is-there-a-replacement-mechanism/22500/7
        // HACK: Must be able to override things such as background. I am the user now.
        Gtk.StyleContext.add_provider_for_display(display, css_provider, Gtk.STYLE_PROVIDER_PRIORITY_USER + 1);

        foreach (var monitor in monitors) present_bar(monitor);
        launcher_menu = new Dotpanel.LauncherMenu();
        add_window(launcher_menu);

        var monitors = display.get_monitors();
        display.get_monitors().items_changed.connect((position, removed, added) => {
            if (added > removed) {
                display.sync();
                for (var i = 0; i < added; i++) {
                    var monitor = monitors.get_item(position + i);
                    if (monitor != null) present_bar((Gdk.Monitor) monitor);
                }
            }
        });
    }

    private void present_bar(Gdk.Monitor monitor) {
        var bar = new Dotpanel.Bar(monitor);

        add_window(bar);
        bar.present();
    }

    construct {
        instance_name = "dotpanel";
    }
}

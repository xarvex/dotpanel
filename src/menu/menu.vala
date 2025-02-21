public class Dotpanel.Menu : Astal.Window {
    construct {
        add_css_class("menu");

        // Not having `this` causes formatting to break?
        this.namespace = "dotpanel-menu";

        exclusivity = Astal.Exclusivity.EXCLUSIVE;
        keymode = Astal.Keymode.EXCLUSIVE;
        layer = Astal.Layer.TOP;

        var key_event = new Gtk.EventControllerKey();
        key_event.key_released.connect(keyval => {
            if (keyval == Gdk.Key.Escape) visible = false;
        });
        ((Gtk.Widget) this).add_controller(key_event);
    }
}

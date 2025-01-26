public class Dotpanel.BatteryBarModule : Dotpanel.BarModule {
    private AstalBattery.Device device;

    private Gtk.Image icon = new Gtk.Image();
    private Gtk.Label percentage = new Gtk.Label(null);

    private void sync_icon() {
        icon.icon_name = device.battery_icon_name;
    }

    private void sync_percentage() {
        percentage.label = @"$(Math.round(device.percentage * 100).to_string())%";
    }

    construct {
        add_css_class("spaced");
        percentage.add_css_class("monospaced");

        device = AstalBattery.get_default();
        device.notify.connect(spec => {
            if (spec.name == "percentage") sync_percentage();
            else print("%s\n", spec.name);
            sync_icon();
        });

        sync_icon();
        sync_percentage();

        append(icon);
        append(percentage);
    }
}

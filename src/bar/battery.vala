public class Dotpanel.BatteryBarModule : Dotpanel.BarModule {
    private AstalBattery.Device device;

    private Gtk.Image icon = new Gtk.Image();
    private Gtk.Label percentage = new Gtk.Label(null);

    private string format_time_until(int64 seconds) {
        if (seconds >= 60) {
            var hours = seconds / 3600;
            var minutes = (seconds / 60) % 60;

            // Using nested template strings breaks uncrustify.
            // See: https://github.com/uncrustify/uncrustify/issues/4230
            return ((hours > 0) ? @"$(hours) hr " : "") + @"$(minutes) min";
        } else return "<1 min";
    }

    private void update_icon() {
        icon.icon_name = device.battery_icon_name;
    }

    private void update_percentage() {
        percentage.label = @"$(Math.round(device.percentage * 100).to_string())%";
    }

    private void update_tooltip() {
        switch (device.state) {
        case AstalBattery.State.CHARGING:
            if (device.time_to_full > 0) tooltip_markup =
                    @"Charging, <b>$(format_time_until(device.time_to_full))</b> until full.";
            else tooltip_text = "Charging.";
            break;
        case AstalBattery.State.DISCHARGING:
            if (device.time_to_full > 0) tooltip_markup =
                    @"Discharging, <b>$(format_time_until(device.time_to_empty))</b> until empty.";
            else tooltip_text = "Discharging.";
            break;
        case AstalBattery.State.EMPTY:
            tooltip_markup = "<b>Empty!</b>";
            break;
        case AstalBattery.State.FULLY_CHARGED:
            tooltip_text = "Fully charged!";
            break;
        case AstalBattery.State.PENDING_CHARGE:
            tooltip_text = "Plugged in.";
            break;
        default:
            tooltip_markup = "<i>Status unknown?</i>";
            break;
        }
    }

    construct {
        add_css_class("spaced");
        percentage.add_css_class("monospaced");

        device = AstalBattery.get_default();
        device.notify.connect(pspec => {
            switch (pspec.name) {
                case "battery-icon-name":
                    update_icon();
                    break;
                case "percentage":
                    update_percentage();
                    break;
                case "state":
                case "time-to-empty":
                case "time-to-full":
                    update_tooltip();
                    break;
            }
        });

        update_icon();
        update_percentage();
        update_tooltip();

        append(icon);
        append(percentage);
    }
}

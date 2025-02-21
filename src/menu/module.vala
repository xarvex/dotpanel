public class Dotpanel.MenuModule : Astal.Box {
    construct {
        vertical = true;

        add_css_class("module");
        add_css_class("boxlike");

        vexpand = false;

        height_request = 500;
        width_request = (int) Math.round(500.0 * (16.0 / 9.0));
    }
}

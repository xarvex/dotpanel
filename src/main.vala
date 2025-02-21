public class Dotpanel.Main {
    private static bool stop;
    private static bool inspector;
    private static string menu;

    private const OptionEntry[] OPTIONS = {
        { "stop", 'q', OptionFlags.NONE, OptionArg.NONE, ref stop, "Stop running instance", null },
        {
            "inspector", 'I', OptionFlags.NONE, OptionArg.NONE, ref inspector, "Open GTK inspector on running instance",
            null,
        },
        {
            "menu", 'm', OptionFlags.NONE, OptionArg.STRING, ref menu, "Display a menu",
            "MENU",
        },
        { null },
    };

    public static int main(string[] args) {
        var context = new OptionContext();

        context.add_main_entries(OPTIONS, null);
        try {
            context.parse(ref args);
        } catch (OptionError e) {
            printerr("%s\n", e.message);
            return 1;
        }

        if (stop)
            try {
                AstalIO.quit_instance("dotpanel");
            } catch (Error e) {
                printerr("%s\n", e.message);
                return 1;
            }
        else if (inspector)
            try {
                AstalIO.open_inspector("dotpanel");
            } catch (Error e) {
                printerr("%s\n", e.message);
                return 1;
            }
        else if (menu != null) {
            try {
                var response = AstalIO.send_message("dotpanel", @"menu-$(menu)");
                if (response != null) print("%s\n", response);
            } catch (Error e) {
                printerr("%s\n", e.message);
                return 1;
            }
        } else {
            var app = new Dotpanel.Application();

            try {
                app.acquire_socket();
            } catch (Error e) {
                printerr("%s\n", e.message);
                return 1;
            }

            return app.run(args);
        }

        return 0;
    }
}

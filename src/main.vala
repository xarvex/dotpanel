public class Dotpanel.Main {
    private static bool daemon;
    private static string request;
    private static bool inspector;
    private static bool quit;

    private const OptionEntry[] options = {
        { "daemon", 0, OptionFlags.NONE, OptionArg.NONE, ref daemon, "Run daemon", null },
        {
            "inspector", 0, OptionFlags.NONE, OptionArg.NONE, ref inspector, "Open GTK inspector on running instance",
            null,
        },
        { "quit", 'q', OptionFlags.NONE, OptionArg.NONE, ref quit, "Quit running instance", null },
        {
            "request", 'r', OptionFlags.NONE, OptionArg.STRING, ref request, "Request to running instance",
            "REQUEST",
        },
        { null },
    };

    public static int main(string[] args) {
        var context = new OptionContext();

        context.add_main_entries(options, null);
        try {
            context.parse(ref args);
        } catch (OptionError e) {
            printerr("%s\n", e.message);
            return 1;
        }

        if (quit)
            try {
                AstalIO.quit_instance("dotpanel");
            } catch (Error e) {
                printerr("%s\n", e.message);
                if (!daemon || (e.code != DBusError.SERVICE_UNKNOWN)) return 1;
            }

        if (request != null)
            try {
                print("%s\n", AstalIO.send_message("dotpanel", request));
            } catch (Error e) {
                printerr("%s\n", e.message);
                return 1;
            }

        if (inspector)
            try {
                AstalIO.open_inspector("dotpanel");
            } catch (Error e) {
                printerr("%s\n", e.message);
                return 1;
            }

        if (daemon) {
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

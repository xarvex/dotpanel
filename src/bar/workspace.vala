public class Dotpanel.WorkspaceBarModule : Dotpanel.BarModule {
    private class WorkspaceButton : Astal.Box {
        private AstalHyprland.Hyprland hyprland;
        private AstalHyprland.Workspace dummy_workspace;

        private Gtk.GestureClick left_click = new Gtk.GestureClick();
        private Gtk.GestureClick right_click = new Gtk.GestureClick();

        public WorkspaceButton(int number, AstalHyprland.Hyprland hyprland) {
            this.hyprland = hyprland;
            dummy_workspace = new AstalHyprland.Workspace.dummy(number, null);

            set_workspace(hyprland.get_workspace(number));
        }

        public void set_monitor(AstalHyprland.Monitor? monitor, bool active = false) {
            if (monitor == null) {
                remove_css_class("visible");
                remove_css_class("active");
            } else {
                add_css_class("visible");
                if (active) add_css_class("active");
                else remove_css_class("active");
            }
        }

        public void set_workspace(AstalHyprland.Workspace? workspace) {
            if (workspace == null) remove_css_class("occupied");
            else {
                if (workspace.clients.length() > 0) add_css_class("occupied");
                workspace.notify.connect(spec => {
                    if (spec.name == "clients") {
                        if (workspace.clients.length() > 0) add_css_class("occupied");
                        else remove_css_class("occupied");
                    }
                });
            }
        }

        construct {
            add_css_class("workspace");

            halign = Gtk.Align.CENTER;
            valign = Gtk.Align.CENTER;

            left_click.set_button(Gdk.BUTTON_PRIMARY);
            left_click.pressed.connect(() => dummy_workspace.focus());
            right_click.set_button(Gdk.BUTTON_SECONDARY);
            right_click.pressed.connect(() => {
                var client = hyprland.focused_client;
                if (client != null) client.move_to(dummy_workspace);
            });
            add_controller(left_click);
            add_controller(right_click);
        }
    }

    private GLib.List<int> monitor_buttons = new GLib.List<int>();
    private WorkspaceButton[] buttons = new WorkspaceButton[10];
    private string monitor_connector;

    public WorkspaceBarModule(string monitor_connector) {
        this.monitor_connector = monitor_connector;

        var hyprland = AstalHyprland.get_default();

        for (var i = 0; i < buttons.length; i++) {
            var button = new WorkspaceButton(i + 1, hyprland);
            buttons[i] = button;
            append(button);
        }

        hyprland.workspace_added.connect(workspace => {
            var index = workspace.id - 1;
            if ((index >= 0) && (index < buttons.length)) buttons[index].set_workspace(workspace);
        });
        hyprland.workspace_removed.connect(id => {
            var index = id - 1;
            if ((index >= 0) && (index < buttons.length)) buttons[index].set_workspace(null);
        });

        foreach (var monitor in hyprland.monitors) check_monitor(monitor);
        hyprland.monitor_added.connect(check_monitor);
        hyprland.monitor_removed.connect(id => unset_monitor(id, true));
    }

    private void set_monitor(AstalHyprland.Monitor monitor, bool active) {
        var index = monitor.active_workspace.id - 1;

        if ((index >= 0) && (index < buttons.length)) {
            monitor_buttons.insert(index, monitor.id);
            buttons[index].set_monitor(monitor, active);
        } else monitor_buttons.remove(monitor.id);
    }

    private void unset_monitor(int id, bool always_remove = true) {
        var index = monitor_buttons.nth_data(id);
        var inside_bounds = (index >= 0) && (index < buttons.length);

        if (inside_bounds) buttons[index].set_monitor(null);
        if (!inside_bounds || always_remove) monitor_buttons.remove(id);
    }

    private void check_monitor(AstalHyprland.Monitor monitor) {
        var active = monitor.name == monitor_connector;

        if (monitor.active_workspace != null) set_monitor(monitor, active);

        monitor.notify.connect(spec => {
            if ((spec.name == "active-workspace")) {
                if (monitor.active_workspace == null) unset_monitor(monitor.id, true);
                else {
                    unset_monitor(monitor.id);
                    set_monitor(monitor, active);
                }
            }
        });
    }
}

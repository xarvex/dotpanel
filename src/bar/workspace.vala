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

        public void set_monitor_state(bool state, bool active = false) {
            if (state) {
                add_css_class("workspace-visible");
                if (active) add_css_class("workspace-active");
                else remove_css_class("workspace-active");
            } else {
                remove_css_class("workspace-visible");
                remove_css_class("workspace-active");
            }
        }

        public void set_workspace(AstalHyprland.Workspace? workspace) {
            if (workspace == null) remove_css_class("workspace-occupied");
            else {
                if (workspace.clients.length() > 0) add_css_class("workspace-occupied");
                workspace.notify.connect(pspec => {
                    if (pspec.name == "clients") {
                        if (workspace.clients.length() > 0) add_css_class("workspace-occupied");
                        else remove_css_class("workspace-occupied");
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

    private AstalHyprland.Hyprland hyprland;

    private GenericArray<int> monitor_buttons = new GenericArray<int>();
    private WorkspaceButton[] buttons = new WorkspaceButton[10];
    private string monitor_connector;

    public WorkspaceBarModule(string monitor_connector) {
        hyprland = AstalHyprland.get_default();
        this.monitor_connector = monitor_connector;

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

        var monitors = hyprland.monitors.copy();
        monitors.reverse();
        foreach (var monitor in monitors)
            // NOTE: If null, will come through on a monitor_added signal.
            if (monitor.name != null) check_monitor(monitor);

        hyprland.monitor_added.connect(monitor => {
            check_monitor(monitor);
        });
        hyprland.monitor_removed.connect(id => {
            unset_monitor(id);
            monitor_buttons.remove_index(id);
        });
    }

    private void set_monitor(AstalHyprland.Monitor monitor, bool active) {
        if (monitor.active_workspace == null) monitor_buttons[monitor.id] = -1;
        else {
            var index = monitor.active_workspace.id - 1;

            monitor_buttons[monitor.id] = index;
            if ((index >= 0) && (index < buttons.length)) buttons[index].set_monitor_state(true, active);
        }
    }

    private void unset_monitor(int monitor_id) {
        var index = monitor_buttons[monitor_id];

        if ((index >= 0) && (index < buttons.length)) buttons[index].set_monitor_state(false);
    }

    private void check_monitor(AstalHyprland.Monitor monitor) {
        monitor_buttons.add(-1);
        set_monitor(monitor, monitor.name == monitor_connector);

        // NOTE: Cannot use reference to monitor, will prevent disposal.
        monitor.notify.connect((gobject, pspec) => {
            var mon = (AstalHyprland.Monitor) gobject;
            if ((pspec.name == "active-workspace")) {
                unset_monitor(mon.id);
                set_monitor(mon, mon.name == monitor_connector);
            }
        });
    }
}

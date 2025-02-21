public class Dotpanel.WorkspaceBarModule : Dotpanel.BarModule {
    private AstalHyprland.Hyprland hyprland;

    private GenericArray<int> monitor_buttons = new GenericArray<int>();
    private Dotpanel.WorkspaceBarButton[] buttons = new Dotpanel.WorkspaceBarButton[10];
    private string monitor_connector;

    public WorkspaceBarModule(string monitor_connector) {
        hyprland = AstalHyprland.get_default();
        this.monitor_connector = monitor_connector;

        for (var i = 0; i < buttons.length; i++) {
            var button = new Dotpanel.WorkspaceBarButton(i + 1, hyprland);
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

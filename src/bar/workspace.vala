public class Dotpanel.WorkspaceBarModule : Dotpanel.BarModule {
    private class WorkspaceButton : Astal.Box {
        private Gtk.GestureClick left_click = new Gtk.GestureClick();
        private Gtk.GestureClick right_click = new Gtk.GestureClick();

        private AstalHyprland.Hyprland hyprland;
        private AstalHyprland.Workspace dummy_workspace;

        public WorkspaceButton(int number, string monitor_connector, AstalHyprland.Hyprland hyprland) {
            this.hyprland = hyprland;
            dummy_workspace = new AstalHyprland.Workspace.dummy(number, null);

            foreach (var monitor in hyprland.monitors) {
                var visible = number == monitor.active_workspace.id;

                if (visible) add_css_class("visible");

                // NOTE: Logic cannot be combined as that may create a race condition.
                if (monitor.name == monitor_connector) {
                    if (visible) add_css_class("active");
                    monitor.notify.connect(
                        spec => {
                            if (spec.name == "active-workspace") {
                                if (number == monitor.active_workspace.id) {
                                    add_css_class("visible");
                                    add_css_class("active");
                                } else if (has_css_class("active")) {
                                    remove_css_class("visible");
                                    remove_css_class("active");
                                }
                            }
                        });
                } else
                    monitor.notify.connect(
                        spec => {
                            if (spec.name == "active-workspace") {
                                if (number == monitor.active_workspace.id) add_css_class("visible");
                                else if (!has_css_class("active")) remove_css_class("visible");
                            }
                        });
            }

            hyprland.workspace_added.connect(
                workspace => {
                    if (number == workspace.id) monitor_clients(workspace);
                });
            var workspace = hyprland.get_workspace(number);
            if (workspace != null) {
                if (workspace.clients.length() > 0) add_css_class("occupied");
                monitor_clients(workspace);
            }
        }

        private void monitor_clients(AstalHyprland.Workspace workspace) {
            workspace.notify.connect(
                () => {
                    if (workspace.clients.length() > 0) add_css_class("occupied");
                    else remove_css_class("occupied");
                });
            workspace.removed.connect(() => remove_css_class("occupied"));
        }

        construct {
            add_css_class("workspace");

            halign = Gtk.Align.CENTER;
            valign = Gtk.Align.CENTER;
            vexpand = false;

            left_click.set_button(Gdk.BUTTON_PRIMARY);
            left_click.pressed.connect(() => dummy_workspace.focus());
            right_click.set_button(Gdk.BUTTON_SECONDARY);
            right_click.pressed.connect(
                () => {
                    var client = hyprland.focused_client;
                    if (client != null) client.move_to(dummy_workspace);
                });
            add_controller(left_click);
            add_controller(right_click);
        }
    }

    public WorkspaceBarModule(string monitor_connector) {
        for (var i = 1; i <= 10; i++) append(new WorkspaceButton(i, monitor_connector, AstalHyprland.get_default()));
    }
}

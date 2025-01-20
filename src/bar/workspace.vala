public class Dotpanel.WorkspaceBarModule : Dotpanel.BarModule {
    private class WorkspaceButton : Astal.Box {
        private Gtk.GestureClick left_click = new Gtk.GestureClick();
        private Gtk.GestureClick right_click = new Gtk.GestureClick();

        private AstalHyprland.Hyprland hyprland;
        private AstalHyprland.Workspace dummy_workspace;

        public WorkspaceButton(int number, AstalHyprland.Hyprland hyprland) {
            this.hyprland = hyprland;
            dummy_workspace = new AstalHyprland.Workspace.dummy(number, null);

            if (number == hyprland.focused_workspace.id) add_css_class("focused");
            hyprland.notify.connect(
                spec => {
                    if (spec.name == "focused-workspace") {
                        if (number == hyprland.focused_workspace.id) add_css_class("focused");
                        else remove_css_class("focused");
                    }
                });

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

    construct {
        for (var i = 1; i <= 10; i++) append(new WorkspaceButton(i, AstalHyprland.get_default()));
    }
}

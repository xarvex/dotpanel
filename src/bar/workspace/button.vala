private class Dotpanel.WorkspaceBarButton : Astal.Box {
    private AstalHyprland.Hyprland hyprland;
    private AstalHyprland.Workspace dummy_workspace;

    private Gtk.GestureClick left_click = new Gtk.GestureClick();
    private Gtk.GestureClick right_click = new Gtk.GestureClick();

    public WorkspaceBarButton(int number, AstalHyprland.Hyprland hyprland) {
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

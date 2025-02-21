public abstract class Dotpanel.InputMenu : Dotpanel.Menu {
    protected Gtk.Entry input = new Gtk.Entry();
    protected Gtk.ScrolledWindow scroll = new Gtk.ScrolledWindow();
    protected Gtk.ListBox list = new Gtk.ListBox();

    public abstract void update_list();

    construct {
        notify["visible"].connect(() => {
            if (visible) input.grab_focus();
            else input.text = "";
        });

        scroll.child = list;

        var module = new Dotpanel.MenuModule();
        module.append(input);
        module.append(scroll);
        child = module;
    }
}

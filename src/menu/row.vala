public abstract class Dotpanel.MenuRow : Gtk.ListBoxRow {
    protected abstract void on_select();

    construct {
        activate.connect(on_select);
    }
}

public class Dotpanel.LauncherMenuRow : Dotpanel.MenuRow {
    public AstalApps.Application application { get; construct; }
    public double score { get; set; }
    public LauncherMenuRow(AstalApps.Application application) {
        Object(application: application);

        var icon = new Gtk.Image();
        icon.icon_name = application.icon_name;

        var name = new Gtk.Label(application.name);

        var box = new Astal.Box();
        box.append(icon);
        box.append(name);
        child = box;
    }

    protected override void on_select() {
        application.launch();
    }
}

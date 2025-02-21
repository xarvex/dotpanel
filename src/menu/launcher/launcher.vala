public class Dotpanel.LauncherMenu : Dotpanel.InputMenu {
    private AstalApps.Apps apps = new AstalApps.Apps();

    public override void update_list() {
        var child = list.get_first_child();

        while (child != null) {
            if (child is Dotpanel.MenuRow) {
                var row = (Dotpanel.LauncherMenuRow) child;
                row.score = apps.fuzzy_score(input.text, row.application);
            }
            child = child.get_next_sibling();
        }
    }

    construct {
        foreach (var application in apps.list) list.append(new Dotpanel.LauncherMenuRow(application));
    }
}

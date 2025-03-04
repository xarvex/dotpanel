use constcat::concat;
use gtk::{gdk::Display, gio, glib, prelude::*, subclass::prelude::*, CssProvider, IconTheme};

use crate::Bar;

pub const APP_TYPENAME: &str = "Dotpanel";
pub const APP_ID: &str = "com.xarvex.dotpanel";
pub const APP_PATH: &str = "/com/xarvex/dotpanel";

#[derive(Default)]
pub struct ImpApplication {}

#[glib::object_subclass]
impl ObjectSubclass for ImpApplication {
    const NAME: &'static str = concat!(APP_TYPENAME, "Application");
    type Type = self::Application;
    type ParentType = gtk::Application;
}

impl ObjectImpl for ImpApplication {}
impl ApplicationImpl for ImpApplication {
    fn startup(&self) {
        self.parent_startup();

        let display = Display::default().expect("Failed to connect to a display.");

        let css_provider = CssProvider::new();
        css_provider.load_from_resource(concat!(APP_PATH, "/style.css"));

        let icon_theme = IconTheme::for_display(&display);
        icon_theme.add_resource_path(concat!(APP_PATH, "/icons"));

        // HACK: Must be able to override things. I am the user now.
        gtk::style_context_add_provider_for_display(
            &display,
            &css_provider,
            gtk::STYLE_PROVIDER_PRIORITY_USER + 1,
        );
    }

    fn activate(&self) {
        self.parent_activate();

        let bar = Bar::new(&*self.obj());
        bar.present();
    }
}
impl GtkApplicationImpl for ImpApplication {}

glib::wrapper! {
    pub struct Application(ObjectSubclass<ImpApplication>)
        @extends gio::Application, gtk::Application,
        @implements gio::ActionGroup, gio::ActionMap;
}

impl Default for Application {
    fn default() -> Self {
        Self::new()
    }
}

impl Application {
    pub fn new() -> Self {
        glib::Object::builder()
            .property("application-id", APP_ID)
            .build()
    }
}

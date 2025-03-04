use constcat::concat;
use gtk::{gio, glib, prelude::*, subclass::prelude::*, CompositeTemplate};
use gtk_layer_shell::{Edge, Layer, LayerShell};

use crate::{HostBarModule, WorkspaceBarModule};

#[derive(CompositeTemplate, Default)]
#[template(file = "src/bar/main.blp")]
pub struct ImpBar;

#[glib::object_subclass]
impl ObjectSubclass for ImpBar {
    const NAME: &'static str = concat!(crate::APP_TYPENAME, "Bar");
    type Type = self::Bar;
    type ParentType = gtk::ApplicationWindow;

    fn class_init(klass: &mut Self::Class) {
        HostBarModule::ensure_type();
        WorkspaceBarModule::ensure_type();

        klass.bind_template();
    }
    fn instance_init(obj: &glib::subclass::InitializingObject<Self>) {
        obj.init_template();
    }
}

impl ObjectImpl for ImpBar {
    fn constructed(&self) {
        self.parent_constructed();

        let obj = self.obj();

        obj.init_layer_shell();

        obj.set_namespace("dotpanel-bar");

        obj.set_layer(Layer::Bottom);
        obj.set_anchor(Edge::Left, true);
        obj.set_anchor(Edge::Right, true);
        obj.set_anchor(Edge::Top, true);

        obj.auto_exclusive_zone_enable();
    }
}
impl WidgetImpl for ImpBar {}
impl WindowImpl for ImpBar {}
impl ApplicationWindowImpl for ImpBar {}

glib::wrapper! {
    pub struct Bar(ObjectSubclass<ImpBar>)
        @extends gtk::ApplicationWindow, gtk::Window, gtk::Widget,
        @implements gio::ActionGroup, gio::ActionMap, gtk::Accessible,
        gtk::Buildable, gtk::ConstraintTarget, gtk::Native, gtk::Root,
        gtk::ShortcutManager;
}

impl Bar {
    pub fn new<P: IsA<gtk::Application>>(app: &P) -> Self {
        glib::Object::builder().property("application", app).build()
    }
}

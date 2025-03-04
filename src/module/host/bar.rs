use constcat::concat;
use gtk::{glib, subclass::prelude::*, CompositeTemplate};

#[derive(CompositeTemplate, Default)]
#[template(file = "src/module/host/bar.blp")]
pub struct ImpHostBarModule;
#[glib::object_subclass]
impl ObjectSubclass for ImpHostBarModule {
    const NAME: &'static str = concat!(crate::APP_TYPENAME, "HostBarModule");
    type Type = self::HostBarModule;
    type ParentType = crate::BarModule;
}

impl ObjectImpl for ImpHostBarModule {}
impl WidgetImpl for ImpHostBarModule {}
impl BoxImpl for ImpHostBarModule {}

glib::wrapper! {
    pub struct HostBarModule(ObjectSubclass<ImpHostBarModule>)
        @extends gtk::Box, gtk::Widget,
        @implements gtk::Accessible, gtk::Buildable, gtk::ConstraintTarget;
}

impl Default for HostBarModule {
    fn default() -> Self {
        Self::new()
    }
}

impl HostBarModule {
    pub fn new() -> Self {
        glib::Object::new()
    }
}

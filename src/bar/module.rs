use constcat::concat;
use gtk::{glib, subclass::prelude::*, CompositeTemplate};

#[derive(CompositeTemplate, Default)]
#[template(file = "src/bar/module.blp")]
pub struct ImpBarModule;

#[glib::object_subclass]
impl ObjectSubclass for ImpBarModule {
    const NAME: &'static str = concat!(crate::APP_TYPENAME, "BarModule");
    type Type = self::BarModule;
    type ParentType = gtk::Box;

    fn class_init(klass: &mut Self::Class) {
        klass.bind_template();
    }
    fn instance_init(obj: &glib::subclass::InitializingObject<Self>) {
        obj.init_template();
    }
}

impl ObjectImpl for ImpBarModule {}
impl WidgetImpl for ImpBarModule {}
impl BoxImpl for ImpBarModule {}

glib::wrapper! {
    pub struct BarModule(ObjectSubclass<ImpBarModule>)
        @extends gtk::Box, gtk::Widget,
        @implements gtk::Accessible, gtk::Buildable, gtk::ConstraintTarget;
}

impl Default for BarModule {
    fn default() -> Self {
        Self::new()
    }
}

unsafe impl<T: BoxImpl> IsSubclassable<T> for BarModule {}

impl BarModule {
    pub fn new() -> Self {
        glib::Object::new()
    }
}

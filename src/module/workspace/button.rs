use constcat::concat;
use gtk::{glib, subclass::prelude::*, CompositeTemplate};

#[derive(CompositeTemplate, Default)]
#[template(file = "src/module/workspace/button.blp")]
pub struct ImpWorkspaceButton;

#[glib::object_subclass]
impl ObjectSubclass for ImpWorkspaceButton {
    const NAME: &'static str = concat!(crate::APP_TYPENAME, "WorkspaceButton");
    type Type = self::WorkspaceButton;
    type ParentType = gtk::Box;

    fn class_init(klass: &mut Self::Class) {
        klass.bind_template();
    }
    fn instance_init(obj: &glib::subclass::InitializingObject<Self>) {
        obj.init_template();
    }
}

impl ObjectImpl for ImpWorkspaceButton {}
impl WidgetImpl for ImpWorkspaceButton {}
impl BoxImpl for ImpWorkspaceButton {}

glib::wrapper! {
    pub struct WorkspaceButton(ObjectSubclass<ImpWorkspaceButton>)
        @extends gtk::Box, gtk::Widget,
        @implements gtk::Accessible, gtk::Buildable, gtk::ConstraintTarget;
}

impl Default for WorkspaceButton {
    fn default() -> Self {
        Self::new()
    }
}

impl WorkspaceButton {
    pub fn new() -> Self {
        glib::Object::new()
    }
}

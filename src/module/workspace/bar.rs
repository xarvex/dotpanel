use constcat::concat;
use gtk::{glib, prelude::*, subclass::prelude::*};

use super::WorkspaceButton;

#[derive(Default)]
pub struct ImpWorkspaceBarModule {
    pub buttons: [WorkspaceButton; 10],
}

#[glib::object_subclass]
impl ObjectSubclass for ImpWorkspaceBarModule {
    const NAME: &'static str = concat!(crate::APP_TYPENAME, "WorkspaceBarModule");
    type Type = self::WorkspaceBarModule;
    type ParentType = crate::BarModule;
}

impl ObjectImpl for ImpWorkspaceBarModule {
    fn constructed(&self) {
        self.parent_constructed();

        let obj = self.obj();

        for button in &self.buttons {
            button.set_parent(&*obj);
        }
    }
}
impl WidgetImpl for ImpWorkspaceBarModule {}
impl BoxImpl for ImpWorkspaceBarModule {}

glib::wrapper! {
    pub struct WorkspaceBarModule(ObjectSubclass<ImpWorkspaceBarModule>)
        @extends crate::BarModule, gtk::Box, gtk::Widget,
        @implements gtk::Accessible, gtk::Buildable, gtk::ConstraintTarget;
}

impl Default for WorkspaceBarModule {
    fn default() -> Self {
        Self::new()
    }
}

impl WorkspaceBarModule {
    pub fn new() -> Self {
        glib::Object::new()
    }
}

mod app;
mod bar;
mod module;

pub use app::{Application, APP_ID, APP_PATH, APP_TYPENAME};
pub use bar::{Bar, BarModule};
use gtk::{gio, glib, prelude::*};
pub use module::{HostBarModule, WorkspaceBarModule};

fn main() -> glib::ExitCode {
    gio::resources_register_include!("com.xarvex.dotpanel.gresource")
        .expect("Failed to register resources.");

    let app = app::Application::new();

    app.run()
}

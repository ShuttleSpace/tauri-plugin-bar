use tauri::{
    plugin::{Builder, TauriPlugin},
    Manager, Runtime,
};

pub use models::*;

#[cfg(mobile)]
mod mobile;

mod commands;
mod error;
mod models;

pub use error::{ImmersionBarError, Result};

#[cfg(mobile)]
use mobile::ImmersionBar;

/// Extensions to [`tauri::App`], [`tauri::AppHandle`] and [`tauri::Window`] to access the immersion-bar APIs.
pub trait ImmersionBarExt<R: Runtime> {
    #[cfg(mobile)]
    fn immersionbar(&self) -> &ImmersionBar<R>;
}

impl<R: Runtime, T: Manager<R>> crate::ImmersionBarExt<R> for T {
    #[cfg(mobile)]
    fn immersionbar(&self) -> &ImmersionBar<R> {
        self.state::<ImmersionBar<R>>().inner()
    }
}

/// Initializes the plugin.
pub fn init<R: Runtime>() -> TauriPlugin<R> {
    Builder::new("immersionbar")
        .invoke_handler(tauri::generate_handler![
            #[cfg(mobile)]
            commands::set_immersionbar,
        ])
        .setup(|app, api| {
            #[cfg(mobile)]
            {
                let immersionbar = mobile::init(app, api)?;
                app.manage(immersionbar);
            }
            Ok(())
        })
        .build()
}

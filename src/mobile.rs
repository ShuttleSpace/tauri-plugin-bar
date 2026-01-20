use serde::de::DeserializeOwned;
use tauri::{
    plugin::{PluginApi, PluginHandle},
    AppHandle, Runtime,
};

use crate::models::*;

#[cfg(target_os = "ios")]
tauri::ios_plugin_binding!(init_plugin_immersionbar);

// initializes the Kotlin or Swift plugin classes
pub fn init<R: Runtime, C: DeserializeOwned>(
    _app: &AppHandle<R>,
    api: PluginApi<R, C>,
) -> crate::Result<ImmersionBar<R>> {
    #[cfg(target_os = "android")]
    let handle = api.register_android_plugin("com.tauri.immersionbar", "ImmersionBarPlugin")?;
    #[cfg(target_os = "ios")]
    let handle = api.register_ios_plugin(init_plugin_immersionbar)?;
    Ok(ImmersionBar(handle))
}

/// Access to the immersionbar APIs.
pub struct ImmersionBar<R: Runtime>(PluginHandle<R>);

impl<R: Runtime> ImmersionBar<R> {
    pub fn enable(&self, payload: Option<SetImmersionBarRequest>) -> crate::Result<()> {
        self.0
            .run_mobile_plugin("enable", payload)
            .map_err(Into::into)
    }
    pub fn disable(&self, payload: Option<SetImmersionBarRequest>) -> crate::Result<()> {
        self.0
            .run_mobile_plugin("disable", payload)
            .map_err(Into::into)
    }

    pub fn set_immersionbar(&self, payload: Option<SetImmersionBarRequest>) -> crate::Result<()> {
        self.0
            .run_mobile_plugin("setImmersionBar", payload)
            .map_err(Into::into)
    }
}

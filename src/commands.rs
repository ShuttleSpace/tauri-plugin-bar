use tauri::{AppHandle, Runtime};

use crate::models::*;
use crate::ImmersionBarExt;
use crate::Result;

#[cfg(mobile)]
#[tauri::command]
pub(crate) async fn set_immersionbar<R: Runtime>(
    app: tauri::AppHandle<R>,
    payload: Option<SetImmersionBarRequest>,
) -> Result<()> {
    app.immersionbar().set_immersionbar(payload)
}

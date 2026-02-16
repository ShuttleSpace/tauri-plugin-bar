use serde::{Deserialize, Serialize};

#[derive(Debug, Deserialize, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct SetImmersionBarRequest {
    // Transparency
    pub transparent_status_bar: Option<bool>,
    pub transparent_navigation_bar: Option<bool>,
    pub transparent_bar: Option<bool>,

    // Colors
    // Supported formats:
    // - Hexadecimal: "#RGB", "#ARGB", "#RRGGBB", "#AARRGGBB"
    // - Named colors: "red", "blue", "green", "black", "white", "gray", "cyan", "magenta", "yellow"
    // - Android also supports: "darkgray", "lightgray", "aqua", "fuchsia", "lime", "maroon", "navy", "olive", "purple", "silver", "teal"
    // - iOS supports hex formats and will convert named colors
    pub status_bar_color: Option<String>,
    pub navigation_bar_color: Option<String>,
    pub bar_color: Option<String>,

    // Alpha (0.0 - 1.0)
    pub status_bar_alpha: Option<f32>,
    pub navigation_bar_alpha: Option<f32>,
    pub bar_alpha: Option<f32>,

    // Dark mode
    pub status_bar_dark_font: Option<bool>,
    pub navigation_bar_dark_icon: Option<bool>,
    pub auto_dark_mode_enable: Option<bool>,
    pub auto_status_bar_dark_mode_enable: Option<bool>,
    pub auto_status_bar_dark_mode_threshold: Option<f32>,
    pub auto_navigation_bar_dark_mode_enable: Option<bool>,
    pub auto_navigation_bar_dark_mode_threshold: Option<f32>,

    // Layout
    pub full_screen: Option<bool>,
    pub fits_system_windows: Option<bool>,

    // Visibility
    pub hide_status_bar: Option<bool>,
    pub hide_navigation_bar: Option<bool>,

    // Enable flags
    pub navigation_bar_enable: Option<bool>,
    pub keyboard_enable: Option<bool>,

    // Reset
    pub reset: Option<bool>,
}

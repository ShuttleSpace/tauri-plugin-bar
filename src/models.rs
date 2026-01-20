use serde::{Deserialize, Serialize};

#[derive(Debug, Deserialize, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct SetImmersionBarRequest {
    pub padding_status_bar: Option<bool>,
    pub padding_navigation_bar: Option<bool>,
    pub dark_status_bar: Option<bool>,
    pub show_status_bar: Option<bool>,
    pub show_navigation_bar: Option<bool>,
}

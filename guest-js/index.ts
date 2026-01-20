import { invoke } from "@tauri-apps/api/core";

export interface SetImmersionBarArgs {
  paddingStatusBar?: boolean;
  paddingNavigationBar?: boolean;
  darkStatusBar?: boolean;
  showStatusBar?: boolean;
  showNavigationBar?: boolean;
}

export async function setImmersionBar(args?: SetImmersionBarArgs): Promise<void> {
  await invoke("plugin:immersionbar|set_immersionbar", {
    payload: args,
  });
}

export async function enable(args?: SetImmersionBarArgs): Promise<void> {
  await invoke("plugin:immersionbar|enable", {
    payload: args,
  });
}

export async function disable(args?: SetImmersionBarArgs): Promise<void> {
  await invoke("plugin:immersionbar|disable", {
    payload: args,
  });
}

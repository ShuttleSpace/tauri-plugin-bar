<script>
  import Greet from "./lib/Greet.svelte";
  import { setImmersionBar } from "tauri-plugin-immersionbar-api";

  let response = $state("");

  function updateResponse(msg) {
    response += `[${new Date().toLocaleTimeString()}] ${msg}<br>`;
  }

  async function transparentBars() {
    try {
      await setImmersionBar({ transparentBar: true, statusBarDarkFont: true });
      updateResponse("Transparent bars");
    } catch (error) {
       console.log(error);
      alert(error);
      updateResponse(`Error: ${error.toString()}`);
    }
  }

  async function coloredBars() {
    try {
      await setImmersionBar({ 
        statusBarColor: "#3F51B5", 
        navigationBarColor: "#303F9F",
        statusBarDarkFont: false
      });
      updateResponse("Colored bars (blue)");
    } catch (error) {
       console.log(error);
      alert(error);
      updateResponse(`Error: ${error.tostring()}`);
    }
  }

  async function semiTransparent() {
    try {
      await setImmersionBar({ 
        barColor: "#80000000", 
        statusBarDarkFont: false
      });
      updateResponse("Semi-transparent bars");
    } catch (error) {
       console.log(error);
      alert(error);
      updateResponse(`Error: ${error.tostring()}`);
    }
  }

  async function darkMode() {
    try {
      await setImmersionBar({ 
        barColor: "#FFFFFF",
        statusBarDarkFont: true,
        navigationBarDarkIcon: true
      });
      updateResponse("Dark icons/font");
    } catch (error) {
       console.log(error);
      alert(error);
      updateResponse(`Error: ${error.tostring()}`);
    }
  }

  async function autoDark() {
    try {
      await setImmersionBar({ 
        statusBarColor: "#FF5722",
        navigationBarColor: "#E64A19",
        autoDarkModeEnable: true
      });
      updateResponse("Auto dark mode");
    } catch (error) {
       console.log(error);
      alert(error);
      updateResponse(`Error: ${error.tostring()}`);
    }
  }

  async function fullScreen() {
    try {
      await setImmersionBar({ 
        transparentBar: true,
        fullScreen: true
      });
      updateResponse("Full screen");
    } catch (error) {
       console.log(error);
      alert(error);
      updateResponse(`Error: ${error.tostring()}`);
    }
  }

  async function hideStatusBar() {
    try {
      await setImmersionBar({ hideStatusBar: true });
      updateResponse("Status bar hidden");
    } catch (error) {
       console.log(error);
      alert(error);
      updateResponse(`Error: ${error.tostring()}`);
    }
  }

  async function resetBars() {
    try {
      await setImmersionBar({ reset: true });
      updateResponse("Reset to defaults");
    } catch (error) {
       console.log(error);
      alert(error);
      updateResponse(`Error: ${error.tostring()}`);
    }
  }

  async function fitSystem() {
    try {
      await setImmersionBar({ fitsSystemWindows: true, statusBarColor: "#FF5722" });
      updateResponse("Fit system windows");
    } catch (error) {
      console.log(error);
      alert(error);
      updateResponse(`Error: ${error.tostring()}`);
    }
  }
</script>

<main class="container">
  <h1>Tauri ImmersionBar Plugin Demo</h1>

  <div class="immersion-bar-controls">
    <h2>Transparency</h2>
    <div class="button-row">
      <button onclick={transparentBars}>Transparent Bars</button>
      <button onclick={semiTransparent}>Semi-Transparent</button>
    </div>

    <h2>Colors</h2>
    <div class="button-row">
      <button onclick={coloredBars}>Blue Bars</button>
      <button onclick={darkMode}>White Bars</button>
    </div>

    <h2>Dark Mode</h2>
    <div class="button-row">
      <button onclick={autoDark}>Auto Dark Mode</button>
    </div>

    <h2>Layout</h2>
    <div class="button-row">
      <button onclick={fullScreen}>Full Screen</button>
      <button onclick={hideStatusBar}>Hide Status Bar</button>
    </div>

    <h2>Reset</h2>
    <div class="button-row">
      <button onclick={resetBars}>Reset All</button>
    </div>

    <h2>FitSystem</h2>
    <div class="button-row">
      <button onclick={fitSystem}>Fit system</button>
    </div>
  </div>

  <div class="response-container">
    <h3>Log:</h3>
    <div>{@html response}</div>
  </div>
</main>

<style>
  .immersion-bar-controls {
    margin-top: 2em;
    padding: 1em;
    border: 1px solid #ccc;
    border-radius: 8px;
  }

  .immersion-bar-controls h2 {
    font-size: 1.2em;
    margin: 1em 0 0.5em 0;
  }

  .immersion-bar-controls h2:first-of-type {
    margin-top: 0;
  }

  .button-row {
    margin: 10px 0;
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
  }

  .button-row button {
    padding: 10px 20px;
    background-color: #3F51B5;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 14px;
  }

  .button-row button:hover {
    background-color: #303F9F;
  }

  .response-container {
    margin-top: 2em;
    padding: 1em;
    background-color: #f5f5f5;
    border-radius: 8px;
    max-height: 300px;
    overflow-y: auto;
  }
</style>

<script>
  import Greet from "./lib/Greet.svelte";
  import { setImmersionBar } from "tauri-plugin-immersionbar-api";

  let response = $state("");

  function updateResponse(returnValue) {
    response += `[${new Date().toLocaleTimeString()}] ` + (typeof returnValue === "string" ? returnValue : JSON.stringify(returnValue)) + "<br>";
  }

  async function _setImmersionBar() {
    try {
      await setImmersionBar({
        paddingStatusBar: true,
        paddingNavigationBar: false,
        darkStatusBar: true,
        showStatusBar: true,
        showNavigationBar: true,
      });
      updateResponse("Immersion bar set successfully");
    } catch (error) {
      updateResponse(`Error: ${error.message}`);
    }
  }

  async function _hideStatusBar() {
    try {
      await setImmersionBar({
        showStatusBar: false,
      });
      updateResponse("Status bar hidden");
    } catch (error) {
      updateResponse(`Error: ${error.message}`);
    }
  }

  async function _showStatusBar() {
    try {
      await setImmersionBar({
        showStatusBar: true,
      });
      updateResponse("Status bar shown");
    } catch (error) {
      updateResponse(`Error: ${error.message}`);
    }
  }
</script>

<main class="container">
  <h1>Welcome to Tauri ImmersionBar Plugin!</h1>

  <div class="row">
    <a href="https://vite.dev" target="_blank">
      <img src="/vite.svg" class="logo vite" alt="Vite Logo" />
    </a>
    <a href="https://tauri.app" target="_blank">
      <img src="/tauri.svg" class="logo tauri" alt="Tauri Logo" />
    </a>
    <a href="https://svelte.dev" target="_blank">
      <img src="/svelte.svg" class="logo svelte" alt="Svelte Logo" />
    </a>
  </div>

  <p>Click on the Tauri, Vite, and Svelte logos to learn more.</p>

  <div class="row">
    <Greet />
  </div>

  <div class="immersion-bar-controls">
    <h2>Immersion Bar Controls</h2>
    <div class="button-row">
      <button onclick={_setImmersionBar}>Set Immersion Bar</button>
    </div>
    <div class="button-row">
      <button onclick={_showStatusBar}>Show Status Bar</button>
      <button onclick={_hideStatusBar}>Hide Status Bar</button>
    </div>
  </div>

  <div class="response-container">
    <h3>Response Log:</h3>
    <div>{@html response}</div>
  </div>
</main>

<style>
  .logo.vite:hover {
    filter: drop-shadow(0 0 2em #747bff);
  }

  .logo.svelte:hover {
    filter: drop-shadow(0 0 2em #ff3e00);
  }

  .immersion-bar-controls {
    margin-top: 2em;
    padding: 1em;
    border: 1px solid #ccc;
    border-radius: 4px;
  }

  .button-row {
    margin: 10px 0;
  }

  .button-row button {
    margin-right: 10px;
    margin-bottom: 5px;
    padding: 8px 16px;
    background-color: #f0f0f0;
    border: 1px solid #ccc;
    border-radius: 4px;
    cursor: pointer;
  }

  .button-row button:hover {
    background-color: #e0e0e0;
  }

  .response-container {
    margin-top: 2em;
    padding: 1em;
    background-color: #f9f9f9;
    border-radius: 4px;
  }
</style>

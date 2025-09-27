// PWA Installation handling
let deferredPrompt;
let installable = false;

window.addEventListener("beforeinstallprompt", (e) => {
  console.log("beforeinstallprompt fired");
  // Prevent Chrome 67 and earlier from automatically showing the prompt
  e.preventDefault();
  // Stash the event so it can be triggered later.
  deferredPrompt = e;
  installable = true;

  // Notify Flutter that PWA can be installed
  if (window.flutter_js) {
    window.flutter_js.dispatchEvent(new CustomEvent("pwa-installable"));
  }
});

window.addEventListener("appinstalled", (evt) => {
  console.log("PWA was installed");
  installable = false;
  deferredPrompt = null;
});

// Function to be called from Flutter
window.installPWA = async function () {
  if (deferredPrompt) {
    // Show the prompt
    deferredPrompt.prompt();

    // Wait for the user to respond to the prompt
    const { outcome } = await deferredPrompt.userChoice;
    console.log(`User response to the install prompt: ${outcome}`);

    // We no longer need the prompt
    deferredPrompt = null;
    installable = false;

    return outcome === "accepted";
  }
  return false;
};

// Function to check if PWA can be installed
window.canInstallPWA = function () {
  return installable;
};

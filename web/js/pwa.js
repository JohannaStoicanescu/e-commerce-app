// PWA Installation handling
let deferredPrompt;
let installable = false;

window.addEventListener("beforeinstallprompt", (e) => {
  console.log("beforeinstallprompt fired");
  e.preventDefault();

  deferredPrompt = e;
  installable = true;

  if (window.flutter_js) {
    window.flutter_js.dispatchEvent(new CustomEvent("pwa-installable"));
  }
});

window.addEventListener("appinstalled", (evt) => {
  console.log("PWA was installed");
  installable = false;
  deferredPrompt = null;
});

window.installPWA = async function () {
  if (deferredPrompt) {
    deferredPrompt.prompt();

    const { outcome } = await deferredPrompt.userChoice;
    console.log(`User response to the install prompt: ${outcome}`);

    deferredPrompt = null;
    installable = false;

    return outcome === "accepted";
  }
  return false;
};

window.canInstallPWA = function () {
  return installable;
};

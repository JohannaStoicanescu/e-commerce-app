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
  try {
    if (deferredPrompt) {
      deferredPrompt.prompt();

      const { outcome } = await deferredPrompt.userChoice;
      console.log(`User response to the install prompt: ${outcome}`);

      deferredPrompt = null;
      installable = false;

      return outcome === "accepted";
    }
    return false;
  } catch (error) {
    console.error("Error during PWA installation:", error);
    return false;
  }
};

window.canInstallPWA = function () {
  return installable;
};

window.isPWASupported = function () {
  return "serviceWorker" in navigator && "PushManager" in window;
};

window.isRunningAsPWA = function () {
  return (
    window.matchMedia("(display-mode: standalone)").matches ||
    window.navigator.standalone === true
  );
};

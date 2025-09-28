// Application initialization for better error handling
window.flutterConfiguration = {
  serviceWorker: {
    serviceWorkerVersion: null,
  },
};

window.addEventListener("error", function (e) {
  console.error("JavaScript Error:", e.error);
  console.error("Stack:", e.error?.stack);
});

window.addEventListener("unhandledrejection", function (e) {
  console.error("Unhandled Promise Rejection:", e.reason);
});

if ("performance" in window) {
  window.addEventListener("load", function () {
    setTimeout(function () {
      const perfData = performance.getEntriesByType("navigation")[0];
      console.log(
        "Page Load Time:",
        perfData.loadEventEnd - perfData.fetchStart + "ms"
      );
    }, 0);
  });
}

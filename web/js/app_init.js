// Application initialization for better error handling
window.flutterConfiguration = {
  serviceWorker: {
    serviceWorkerVersion: null,
  },
};

window.addEventListener("error", function (e) {
  console.error("JavaScript Error:", e.error);
  console.error("Stack:", e.error?.stack);

  if (
    e.error &&
    e.error.message &&
    e.error.message.includes("is not a subtype of type")
  ) {
    console.warn("Type casting error detected - continuing execution");
    e.preventDefault();
    return false;
  }
});

window.addEventListener("unhandledrejection", function (e) {
  console.error("Unhandled Promise Rejection:", e.reason);

  if (e.reason && e.reason.toString().includes("is not a subtype of type")) {
    console.warn("Type casting promise rejection - continuing execution");
    e.preventDefault();
    return false;
  }
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

if (typeof window.flutterCanvasKit === "undefined") {
  window.flutterCanvasKit = {
    calloc: function () {
      return null;
    },
    free: function () {},
  };
}

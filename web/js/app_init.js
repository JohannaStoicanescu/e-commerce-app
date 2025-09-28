// Application initialization for better error handling and performance
window.flutterConfiguration = {
  serviceWorker: {
    serviceWorkerVersion: null,
  }
};

// Enhanced error handling for web
window.addEventListener('error', function(e) {
  console.error('JavaScript Error:', e.error);
  console.error('Stack:', e.error?.stack);
  
  // Don't crash on type casting errors in release mode
  if (e.error && e.error.message && e.error.message.includes('is not a subtype of type')) {
    console.warn('Type casting error detected - continuing execution');
    e.preventDefault();
    return false;
  }
});

window.addEventListener('unhandledrejection', function(e) {
  console.error('Unhandled Promise Rejection:', e.reason);
  
  // Handle type casting promise rejections
  if (e.reason && e.reason.toString().includes('is not a subtype of type')) {
    console.warn('Type casting promise rejection - continuing execution');
    e.preventDefault();
    return false;
  }
});

// Performance monitoring
if ('performance' in window) {
  window.addEventListener('load', function() {
    setTimeout(function() {
      const perfData = performance.getEntriesByType('navigation')[0];
      console.log('Page Load Time:', perfData.loadEventEnd - perfData.fetchStart + 'ms');
    }, 0);
  });
}

// Additional Flutter web stability
if (typeof window.flutterCanvasKit === 'undefined') {
  window.flutterCanvasKit = {
    calloc: function() { return null; },
    free: function() { },
  };
}

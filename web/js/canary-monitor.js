// Canary Deployment Monitoring
class CanaryMonitor {
  static get _storageKey() {
    return "canary-metrics";
  }
  static get _environmentKey() {
    return "canary-environment";
  }

  constructor() {
    this.startMonitoring();
  }

  startMonitoring() {
    // Track page loads
    this.trackPageLoad();

    // Track errors
    this.setupErrorTracking();

    // Track performance
    this.trackPerformance();

    // Track user interactions
    this.trackInteractions();

    // Send metrics periodically
    setInterval(() => this.sendMetrics(), 30000); // Every 30 seconds
  }

  trackPageLoad() {
    const environment = this.getEnvironment();
    const metrics = this.getMetrics();

    metrics.pageLoads = (metrics.pageLoads || 0) + 1;
    metrics.environment = environment;
    metrics.lastPageLoad = new Date().toISOString();
    metrics.userAgent = navigator.userAgent;
    metrics.url = window.location.href;

    this.saveMetrics(metrics);

    console.log(`📊 [${environment}] Page load tracked`);
  }

  setupErrorTracking() {
    const originalOnError = window.onerror;
    const self = this;

    window.onerror = function (message, source, lineno, colno, error) {
      const metrics = self.getMetrics();

      if (!metrics.errors) metrics.errors = [];

      metrics.errors.push({
        message: message,
        source: source,
        line: lineno,
        column: colno,
        stack: error ? error.stack : null,
        timestamp: new Date().toISOString(),
        url: window.location.href,
      });

      // Keep only last 10 errors to avoid localStorage bloat
      if (metrics.errors.length > 10) {
        metrics.errors = metrics.errors.slice(-10);
      }

      self.saveMetrics(metrics);
      console.error(`🚨 [${self.getEnvironment()}] Error tracked:`, message);

      // Call original handler if it exists
      if (originalOnError) {
        return originalOnError.apply(this, arguments);
      }

      return false;
    };

    // Track unhandled promise rejections
    window.addEventListener("unhandledrejection", (event) => {
      const metrics = this.getMetrics();

      if (!metrics.errors) metrics.errors = [];

      metrics.errors.push({
        message: "Unhandled Promise Rejection",
        reason: event.reason.toString(),
        timestamp: new Date().toISOString(),
        url: window.location.href,
      });

      if (metrics.errors.length > 10) {
        metrics.errors = metrics.errors.slice(-10);
      }

      this.saveMetrics(metrics);
      console.error(
        `🚨 [${this.getEnvironment()}] Promise rejection tracked:`,
        event.reason
      );
    });
  }

  trackPerformance() {
    if (!window.performance || !window.performance.timing) return;

    window.addEventListener("load", () => {
      setTimeout(() => {
        const timing = window.performance.timing;
        const metrics = this.getMetrics();

        metrics.performance = {
          navigationStart: timing.navigationStart,
          loadEventEnd: timing.loadEventEnd,
          domContentLoadedEventEnd: timing.domContentLoadedEventEnd,
          loadTime: timing.loadEventEnd - timing.navigationStart,
          domReady: timing.domContentLoadedEventEnd - timing.navigationStart,
          timestamp: new Date().toISOString(),
        };

        // Track Web Vitals if available
        if (window.performance.getEntriesByType) {
          const paintEntries = window.performance.getEntriesByType("paint");
          metrics.performance.firstPaint = paintEntries.find(
            (entry) => entry.name === "first-paint"
          )?.startTime;
          metrics.performance.firstContentfulPaint = paintEntries.find(
            (entry) => entry.name === "first-contentful-paint"
          )?.startTime;
        }

        this.saveMetrics(metrics);
        console.log(
          `⚡ [${this.getEnvironment()}] Performance metrics tracked`
        );
      }, 0);
    });
  }

  trackInteractions() {
    let interactionCount = 0;

    const trackInteraction = (event) => {
      interactionCount++;
      const metrics = this.getMetrics();

      metrics.interactions = (metrics.interactions || 0) + 1;
      metrics.lastInteraction = {
        type: event.type,
        timestamp: new Date().toISOString(),
        target: event.target.tagName,
      };

      this.saveMetrics(metrics);

      if (interactionCount % 10 === 0) {
        console.log(
          `👆 [${this.getEnvironment()}] ${interactionCount} interactions tracked`
        );
      }
    };

    ["click", "submit", "input", "scroll"].forEach((eventType) => {
      document.addEventListener(eventType, trackInteraction, { passive: true });
    });
  }

  sendMetrics() {
    const metrics = this.getMetrics();
    const environment = this.getEnvironment();

    if (!metrics.pageLoads) return; // No metrics to send

    // In a real implementation, you would send this to your analytics service
    // For demonstration, we'll use console and localStorage
    const payload = {
      ...metrics,
      sessionId: this.getSessionId(),
      environment: environment,
      timestamp: new Date().toISOString(),
      canaryVersion: this.getCanaryVersion(),
    };

    // Simulate sending to analytics service
    console.log(`📤 [${environment}] Sending metrics:`, payload);

    // Store in localStorage for demo purposes (in production, send to your backend)
    const allMetrics = JSON.parse(
      localStorage.getItem("canary-analytics") || "[]"
    );
    allMetrics.push(payload);

    // Keep only last 50 entries
    if (allMetrics.length > 50) {
      allMetrics.splice(0, allMetrics.length - 50);
    }

    localStorage.setItem("canary-analytics", JSON.stringify(allMetrics));

    // Reset metrics after sending
    this.saveMetrics({});
  }

  getEnvironment() {
    // Check if we're on canary path
    if (window.location.pathname.includes("/canary/")) {
      return "canary";
    }

    // Check for environment variable from build
    if (typeof ENVIRONMENT !== "undefined") {
      return ENVIRONMENT;
    }

    return "stable";
  }

  getCanaryVersion() {
    if (typeof VERSION !== "undefined") {
      return VERSION;
    }

    // Try to get from deployment info
    fetch("./deployment-info.json")
      .then((response) => response.json())
      .then((data) => {
        if (data.canary && data.canary.version) {
          return data.canary.version;
        }
        return "unknown";
      })
      .catch(() => "unknown");

    return "unknown";
  }

  getSessionId() {
    let sessionId = sessionStorage.getItem("canary-session-id");
    if (!sessionId) {
      sessionId =
        "session-" + Date.now() + "-" + Math.random().toString(36).substring(2);
      sessionStorage.setItem("canary-session-id", sessionId);
    }
    return sessionId;
  }

  getMetrics() {
    try {
      return JSON.parse(
        localStorage.getItem(CanaryMonitor._storageKey) || "{}"
      );
    } catch (e) {
      console.warn("Failed to parse metrics from localStorage:", e);
      return {};
    }
  }

  saveMetrics(metrics) {
    try {
      localStorage.setItem(CanaryMonitor._storageKey, JSON.stringify(metrics));
    } catch (e) {
      console.warn("Failed to save metrics to localStorage:", e);
    }
  }

  // Method to get aggregated metrics for reporting
  static getAnalytics() {
    try {
      const analytics = JSON.parse(
        localStorage.getItem("canary-analytics") || "[]"
      );
      const canaryMetrics = analytics.filter((m) => m.environment === "canary");
      const stableMetrics = analytics.filter((m) => m.environment === "stable");

      return {
        canary: {
          sessions: canaryMetrics.length,
          errors: canaryMetrics.reduce(
            (sum, m) => sum + (m.errors?.length || 0),
            0
          ),
          avgLoadTime:
            canaryMetrics.reduce(
              (sum, m) => sum + (m.performance?.loadTime || 0),
              0
            ) / canaryMetrics.length || 0,
          totalInteractions: canaryMetrics.reduce(
            (sum, m) => sum + (m.interactions || 0),
            0
          ),
        },
        stable: {
          sessions: stableMetrics.length,
          errors: stableMetrics.reduce(
            (sum, m) => sum + (m.errors?.length || 0),
            0
          ),
          avgLoadTime:
            stableMetrics.reduce(
              (sum, m) => sum + (m.performance?.loadTime || 0),
              0
            ) / stableMetrics.length || 0,
          totalInteractions: stableMetrics.reduce(
            (sum, m) => sum + (m.interactions || 0),
            0
          ),
        },
        comparison: {
          errorRateRatio:
            canaryMetrics.length > 0 && stableMetrics.length > 0
              ? canaryMetrics.reduce(
                  (sum, m) => sum + (m.errors?.length || 0),
                  0
                ) /
                canaryMetrics.length /
                (stableMetrics.reduce(
                  (sum, m) => sum + (m.errors?.length || 0),
                  0
                ) /
                  stableMetrics.length)
              : 0,
        },
      };
    } catch (e) {
      console.warn("Failed to get analytics:", e);
      return null;
    }
  }
}

// Initialize monitoring
if (typeof window !== "undefined") {
  window.canaryMonitor = new CanaryMonitor();

  // Expose analytics getter globally
  window.getCanaryAnalytics = CanaryMonitor.getAnalytics;

  console.log(
    `🔍 Canary monitoring initialized for environment: ${window.canaryMonitor.getEnvironment()}`
  );
}

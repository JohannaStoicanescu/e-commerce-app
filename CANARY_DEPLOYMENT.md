# 🐤 Canary Deployment Setup

This document explains the canary deployment strategy implemented for the Flutter e-commerce application.

## Overview

A canary deployment allows you to release new features to a small percentage of users before rolling out to everyone. This helps identify issues early and reduces the risk of widespread problems.

## Architecture

```
┌─────────────────┐    ┌─────────────────┐
│   Stable App    │    │   Canary App    │
│   (main branch) │    │   (dev branch)  │
└─────────────────┘    └─────────────────┘
         │                       │
         └───────┬───────────────┘
                 │
    ┌─────────────────────────┐
    │   Traffic Router        │
    │   (JavaScript-based)    │
    └─────────────────────────┘
                 │
    ┌─────────────────────────┐
    │   GitHub Pages          │
    │   - /           (stable)│
    │   - /canary/    (canary)│
    └─────────────────────────┘
```

## Workflows

### 1. Canary Deployment (`canary-deploy.yml`)

**Trigger**: Push to `dev` branch or manual dispatch

**Process**:

1. **Build**: Creates a Flutter web build with canary configuration
2. **Deploy**: Deploys to `/canary/` path on GitHub Pages
3. **Traffic Routing**: Implements JavaScript-based traffic splitting
4. **Health Check**: Verifies deployment accessibility
5. **Notification**: Comments on commit with deployment details

**Key Features**:

- Configurable traffic percentage (default: 10%)
- Session stickiness (users stay on their assigned version)
- Visual canary indicator
- Automated health checks

### 2. Canary Operations (`canary-operations.yml`)

**Trigger**: Manual dispatch with operation type

**Operations**:

#### Promote Canary

- Promotes canary to stable production
- Creates a release tag
- Removes traffic routing
- Notifies via GitHub issue

#### Rollback Canary

- Reverts to last stable version
- Removes canary routing
- Creates incident issue

#### Adjust Traffic

- Changes traffic percentage to canary
- Redeploys with new routing configuration
- Updates deployment info

## Monitoring

### JavaScript Monitoring (`canary-monitor.js`)

Automatically tracks:

- **Page loads**: Count and timing
- **Errors**: JavaScript errors and promise rejections
- **Performance**: Load times, Web Vitals
- **Interactions**: User clicks, form submissions
- **Environment detection**: Stable vs canary

### Dashboard (`canary-dashboard.html`)

Provides:

- Real-time metrics comparison
- Health scoring
- Deployment controls
- Traffic adjustment
- Error rate monitoring
- Live logs

## Usage

### 1. Deploy Canary

Push to `dev` branch or manually trigger:

```bash
# Via GitHub Actions UI
# Go to Actions > Canary Deployment > Run workflow
# Set traffic percentage (optional, default: 10%)
```

### 2. Monitor Deployment

Visit the dashboard:

```
https://JohannaStoicanescu.github.io/e-commerce-app/canary-dashboard.html
```

### 3. Manage Traffic

Adjust traffic percentage:

```bash
# Via GitHub Actions UI
# Go to Actions > Canary Operations > Run workflow
# Select "adjust-traffic" and set percentage
```

### 4. Promote or Rollback

```bash
# Promote to stable
# Actions > Canary Operations > Run workflow > "promote"

# Rollback if issues
# Actions > Canary Operations > Run workflow > "rollback"
```

## Configuration

### Environment Variables

Set in your Flutter build:

- `ENVIRONMENT`: "canary" or "production"
- `VERSION`: Build version identifier

### Traffic Routing

The traffic router uses:

- **localStorage**: For session stickiness
- **Random distribution**: Based on percentage
- **URL detection**: Identifies canary vs stable

### Monitoring Configuration

Customize in `canary-monitor.js`:

```javascript
// Metrics collection interval
setInterval(() => this.sendMetrics(), 30000); // 30 seconds

// Error history limit
if (metrics.errors.length > 10) {
  metrics.errors = metrics.errors.slice(-10);
}
```

## Best Practices

### 1. Gradual Rollout

Start with low traffic percentages:

- **5-10%**: Initial deployment
- **25%**: If no issues after 1 hour
- **50%**: If stable after 6 hours
- **100%**: Full promotion

### 2. Monitoring

Watch for:

- **Error rate**: Should not exceed 2x stable rate
- **Performance**: Load times should be comparable
- **User feedback**: Monitor support channels

### 3. Rollback Criteria

Rollback if:

- Error rate > 2x stable
- Performance degradation > 50%
- Critical user-facing issues
- Security vulnerabilities

### 4. Testing

Before canary deployment:

- Run full test suite
- Perform manual testing
- Check Firebase configuration
- Verify API compatibility

## Troubleshooting

### Common Issues

#### 1. Canary Not Receiving Traffic

**Check**:

- Traffic percentage configuration
- JavaScript console errors
- localStorage settings

**Fix**:

```javascript
// Clear routing cache
localStorage.removeItem("canary-route");
```

#### 2. High Error Rate

**Investigate**:

- Check browser console
- Review deployment logs
- Compare with stable metrics

**Action**:

- Reduce traffic percentage
- Rollback if critical

#### 3. Performance Issues

**Monitor**:

- Load times in dashboard
- Network requests
- Resource sizes

**Optimize**:

- Check bundle size differences
- Verify CDN configuration
- Review code changes

### Debugging

Enable debug logging:

```javascript
// In browser console
localStorage.setItem("canary-debug", "true");
location.reload();
```

View analytics:

```javascript
// In browser console
console.log(getCanaryAnalytics());
```

## Security Considerations

- Canary deployments include `robots.txt` to prevent indexing
- Session data is stored locally, not transmitted
- Traffic routing is client-side only
- GitHub Actions secrets are properly configured

## Future Enhancements

- **A/B Testing**: Feature flags for specific functionality
- **Blue-Green**: Full environment switching
- **Geographic Routing**: Region-specific canaries
- **Real User Monitoring**: Integration with external tools
- **Automated Rollback**: Based on metric thresholds

## Support

For issues or questions:

1. Check GitHub Actions logs
2. Review canary dashboard metrics
3. Create GitHub issue with deployment details
4. Check Firebase console for backend issues

---

**Happy Canary Deploying!** 🐤✨

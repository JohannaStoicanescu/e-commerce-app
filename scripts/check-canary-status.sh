#!/bin/bash

# This script helps verify canary deployment status without requiring special GitHub permissions

set -e

REPO_OWNER="${GITHUB_REPOSITORY_OWNER:-$(git config --get remote.origin.url | sed -n 's/.*github\.com[:/]\([^/]*\).*/\1/p')}"
REPO_NAME="${GITHUB_REPOSITORY##*/}"
REPO_NAME="${REPO_NAME%.git}"

echo "🐤 Canary Deployment Status Check"
echo "=================================="
echo "Repository: $REPO_OWNER/$REPO_NAME"
echo "Timestamp: $(date -u +"%Y-%m-%d %H:%M:%S UTC")"
echo ""

# Check stable deployment
echo "📋 Checking Stable Deployment..."
STABLE_URL="https://$REPO_OWNER.github.io/$REPO_NAME/"
if curl -s -f -o /dev/null "$STABLE_URL"; then
    echo "✅ Stable deployment is accessible: $STABLE_URL"
else
    echo "❌ Stable deployment is not accessible: $STABLE_URL"
fi

# Check canary deployment
echo ""
echo "🐤 Checking Canary Deployment..."
CANARY_URL="https://$REPO_OWNER.github.io/$REPO_NAME/canary/"
if curl -s -f -o /dev/null "$CANARY_URL"; then
    echo "✅ Canary deployment is accessible: $CANARY_URL"
else
    echo "❌ Canary deployment is not accessible: $CANARY_URL"
    echo "ℹ️  This might be normal if no canary is currently deployed"
fi

# Check deployment info
echo ""
echo "📊 Checking Deployment Information..."
DEPLOY_INFO_URL="https://$REPO_OWNER.github.io/$REPO_NAME/deployment-info.json"
if curl -s -f "$DEPLOY_INFO_URL" > /tmp/deploy-info.json 2>/dev/null; then
    echo "✅ Deployment info found:"
    if command -v jq >/dev/null 2>&1; then
        cat /tmp/deploy-info.json | jq .
    else
        cat /tmp/deploy-info.json
    fi
else
    echo "ℹ️  No deployment info found (this is normal for basic deployments)"
fi

# Check dashboard
echo ""
echo "📊 Checking Dashboard..."
DASHBOARD_URL="https://$REPO_OWNER.github.io/$REPO_NAME/canary-dashboard.html"
if curl -s -f -o /dev/null "$DASHBOARD_URL"; then
    echo "✅ Dashboard is accessible: $DASHBOARD_URL"
else
    echo "❌ Dashboard is not accessible: $DASHBOARD_URL"
fi

echo ""
echo "🔗 Quick Links:"
echo "   Stable App:    $STABLE_URL"
echo "   Canary App:    $CANARY_URL"
echo "   Dashboard:     $DASHBOARD_URL"
echo "   Deploy Info:   $DEPLOY_INFO_URL"

echo ""
echo "📋 Next Steps:"
echo "   1. Visit the dashboard to monitor metrics"
echo "   2. Check GitHub Actions workflows for deployment status"
echo "   3. Use 'Canary Operations' workflow for promote/rollback/traffic adjustment"

echo ""
echo "✨ Status check complete!"

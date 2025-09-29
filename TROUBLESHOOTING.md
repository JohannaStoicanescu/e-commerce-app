# 🔧 Canary Deployment Troubleshooting

## GitHub Actions Permissions Issues

### Problem: "Resource not accessible by integration" Error

This error occurs when GitHub Actions doesn't have sufficient permissions to perform certain operations like creating commit comments or issues.

### Solutions:

#### 1. Repository Settings (Recommended)

1. Go to your repository on GitHub
2. Navigate to **Settings** → **Actions** → **General**
3. Under "Workflow permissions", select **"Read and write permissions"**
4. Check **"Allow GitHub Actions to create and approve pull requests"**
5. Click **Save**

#### 2. Alternative: Manual Verification

If you prefer to keep restricted permissions:

1. **Check Workflow Summaries**: All deployment information is now available in the GitHub Actions workflow summary instead of commit comments
2. **Monitor via Dashboard**: Use the canary dashboard at `/canary-dashboard.html` for real-time monitoring
3. **Use Manual Operations**: Use the "Canary Operations" workflow for promote/rollback operations

### Current Workflow Features:

#### ✅ What Works Without Extra Permissions:

- Canary deployments to GitHub Pages
- Traffic routing and monitoring
- Health checks
- Workflow summaries with deployment details
- Dashboard monitoring

#### ℹ️ What Requires Additional Permissions:

- Automatic commit comments
- Automatic issue creation for notifications
- Pull request comments

### Verification Steps:

1. **Test Canary Deployment**:

   ```bash
   # Push to dev branch or manually trigger workflow
   git checkout dev
   git push origin dev
   ```

2. **Check Workflow Summary**:

   - Go to GitHub Actions → Canary Deployment workflow
   - Check the workflow summary for deployment details

3. **Verify Deployment**:

   - Visit: `https://yourusername.github.io/yourrepo/canary/`
   - Check canary indicator appears
   - Test traffic routing

4. **Use Dashboard**:
   - Visit: `https://yourusername.github.io/yourrepo/canary-dashboard.html`
   - Monitor metrics and health

### Common Issues and Fixes:

#### Issue: Workflow fails with permission errors

**Fix**: Enable "Read and write permissions" in repository settings

#### Issue: No commit comments appear

**Fix**: This is normal with restricted permissions - check workflow summaries instead

#### Issue: Issues not created for notifications

**Fix**: Enable write permissions or rely on workflow summaries

#### Issue: Can't promote/rollback

**Fix**: Use the "Canary Operations" workflow through GitHub Actions UI

### Manual Operations:

If you prefer manual control, you can always:

1. **Manual Promote**:

   - Go to Actions → Canary Operations
   - Select "promote" operation
   - Run workflow

2. **Manual Rollback**:

   - Go to Actions → Canary Operations
   - Select "rollback" operation
   - Run workflow

3. **Adjust Traffic**:
   - Go to Actions → Canary Operations
   - Select "adjust-traffic" operation
   - Set desired percentage
   - Run workflow

### Monitoring Without Permissions:

Even with restricted permissions, you can still monitor your canary deployments effectively:

1. **Workflow Summaries**: Rich deployment information in GitHub Actions
2. **Canary Dashboard**: Real-time metrics and controls
3. **Browser Console**: Debug information and analytics
4. **GitHub Pages Deployment**: Direct URL verification

### Security Considerations:

The restricted permissions approach is actually more secure:

- ✅ Workflows can't modify repository content unexpectedly
- ✅ No risk of accidental issue/PR creation
- ✅ All operations are explicit and traceable
- ✅ Deployment summaries provide full transparency

### Alternative Notification Methods:

If you want notifications without granting extra permissions:

1. **Slack/Discord Webhooks**: Add webhook notifications to workflows
2. **Email Notifications**: Use GitHub's built-in email notifications
3. **External Monitoring**: Use tools like StatusPage or custom monitoring
4. **Manual Checks**: Regular monitoring via dashboard and workflow summaries

---

**Remember**: The canary deployment system works perfectly with restricted permissions. The additional permissions are only for convenience features like automatic comments and issues.

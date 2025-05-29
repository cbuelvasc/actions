# CI/CD Workflows and Automation Guide

This directory contains GitHub Actions workflows and automation configurations for the custom actions repository.

> **Note**: This is the CI/CD automation guide. For action usage documentation, see the [main README](../README.md).

## 📋 Available Workflows

### `release.yml` - Release Pipeline

Complete pipeline for automated and manual release creation.

**Features:**
- ✅ Automatic testing of all actions before release
- ✅ Action metadata validation
- ✅ Automatic changelog generation
- ✅ GitHub release creation
- ✅ Major version tag updates
- ✅ Support for manual releases with semantic versioning

**Triggers:**
- Push of tags with `v*` format (e.g.: `v1.0.0`)
- Push to `main` branch (validation only)
- Manual with release type selection (major, minor, patch)

**Manual Usage:**
```yaml
# In GitHub Actions -> Actions tab -> Release Actions -> Run workflow
# Select release type: major, minor, patch
```

### `test-actions.yml` - Test Suite

Comprehensive test suite for all repository actions.

**Features:**
- ✅ Automatic test project creation (Maven and Gradle)
- ✅ Matrix testing with different Java versions (17, 21)
- ✅ Individual action validation
- ✅ End-to-end integration tests
- ✅ Performance and cache tests
- ✅ Automatic artifact cleanup

**Triggers:**
- Push to `main` or `develop` (when action files change)
- Pull Requests to `main`
- Manual with configuration options

**Test Types:**
- `full`: All tests including performance
- `quick`: Basic tests without integration
- `integration`: Integration tests only

## 🔧 Automation Configurations

### `dependabot.yml`

Configuration to keep dependencies up to date:

- **GitHub Actions**: Weekly updates on Mondays
- **Docker**: Weekly updates on Tuesdays

> **Note**: Test projects (Maven/Gradle) are created dynamically during workflow runs and don't require dependency monitoring.

### Issue Templates

#### `bug_report.md`
Structured template for bug reporting with:
- Detailed problem description
- Environment information
- Steps to reproduce
- Error logs
- Workflow configuration

#### `feature_request.md`
Template for feature requests with:
- Description and motivation
- Use cases
- Acceptance criteria
- Usage examples

### `PULL_REQUEST_TEMPLATE.md`

Template for Pull Requests ensuring:
- Clear description of changes
- Validation checklist
- Testing performed
- Updated documentation
- Verified compatibility

## 🚀 Developer Workflow

### Before committing:
```bash
# Validate actions locally
./scripts/validate-actions.sh

# Validate specific action
./scripts/validate-actions.sh --action setup-java-maven-env

# Create test projects
./scripts/validate-actions.sh --create-test-projects
```

### To create a release:

**Option 1: Automatic tag**
```bash
git tag v1.2.3
git push origin v1.2.3
```

**Option 2: Manual release**
1. Go to GitHub Actions
2. Select "Release Actions"
3. Click "Run workflow"
4. Select release type (major/minor/patch)

## 📊 Pipeline Metrics

### Release Pipeline
- **Average time**: ~15-20 minutes
- **Success rate**: >95%
- **Test coverage**: All actions with multiple Java versions

### Test Pipeline
- **Average time**: ~25-30 minutes (full)
- **Test matrix**: 2 Java versions × 4 cache strategies × 2 build tools
- **Artifacts**: Test projects, logs, reports

## 🛠️ Maintenance

### Automatic Updates
- Dependabot updates dependencies weekly
- Workflows run automatically on changes
- Automatic artifact cleanup after 30 days

### Manual Review
Monthly review recommended for:
- Workflow performance
- Recurring error logs
- Cache usage metrics
- User feedback

## 🚨 Troubleshooting

### Common Errors

#### Release fails validation
```bash
# Verify locally
./scripts/validate-actions.sh

# Review specific logs in GitHub Actions
```

#### Tests fail intermittently
- Check runner availability
- Review external API rate limits
- Validate version compatibility

#### Cache not working correctly
- Verify cache keys in test matrix
- Review dependabot configuration
- Manually clear cache if needed

### Contact and Support

For workflow issues:
1. Create issue using templates
2. Include complete logs
3. Specify environment and configuration
4. Mention `@cbuelvasc` if urgent

---

**Author**: Carmelo Buelvas Comas  
**Last updated**: May 2024
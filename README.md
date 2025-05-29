# GitHub Actions for Java Spring Boot Projects

A collection of reusable GitHub Actions designed to streamline CI/CD workflows for Java Spring Boot applications. These actions provide optimized setups for Maven and Gradle builds, comprehensive testing suites, and best practices for Spring Boot development.

> **📖 Documentation Structure**
> - **This README**: Action usage and examples
> - **[CI/CD Workflows Guide](.github/WORKFLOWS.md)**: Workflows, automation, and development setup

## 🚀 Available Actions

| Action | Description | Build Tool | Use Case |
|--------|-------------|------------|----------|
| [setup-java-maven-env](./setup-java-maven-env/) | Sets up Java 21 and Maven environment with caching | Maven | Environment setup for Maven projects |
| [setup-java-gradle-env](./setup-java-gradle-env/) | Sets up Java 21 and Gradle environment with caching | Gradle | Environment setup for Gradle projects |
| [spring-boot-test-suite](./spring-boot-test-suite/) | Comprehensive testing with coverage and reporting | Maven/Gradle | Complete testing pipeline |
| [docker-build](./docker-build/) | Builds and optionally pushes Docker images | Maven/Gradle | Docker image creation and deployment |

## 🔄 Available Reusable Workflows

| Workflow | Description | Use Case |
|----------|-------------|----------|
| [build-and-test.yml](.github/workflows/build-and-test.yml) | Complete build and testing pipeline | CI for Spring Boot services |
| [docker-build-deploy.yml](.github/workflows/docker-build-deploy.yml) | Docker build and registry deployment | Container deployment |
| [ci-cd-pipeline.yml](.github/workflows/ci-cd-pipeline.yml) | End-to-end CI/CD automation | Complete service lifecycle |

### Quick Workflow Usage

#### Simple CI Pipeline
```yaml
name: My Service CI
on: [push, pull_request]
jobs:
  ci:
    uses: cbuelvasc/actions/.github/workflows/build-and-test.yml@v1
    with:
      build-tool: 'maven'
      service-name: 'my-service'
      coverage-threshold: '80'
```

#### Complete CI/CD Pipeline
```yaml
name: My Service CI/CD
on: 
  push:
    branches: [main]
jobs:
  pipeline:
    uses: cbuelvasc/actions/.github/workflows/ci-cd-pipeline.yml@v1
    with:
      build-tool: 'gradle'
      service-name: 'my-service'
      docker-enabled: true
      image-name: 'my-org/my-service'
      push-enabled: true
    secrets:
      registry-username: ${{ secrets.DOCKER_USERNAME }}
      registry-password: ${{ secrets.DOCKER_PASSWORD }}
```

> **📚 Detailed Documentation**: [Reusable Workflows Guide](.github/REUSABLE_WORKFLOWS.md)

## 📋 Quick Start

### Action Usage

Actions can be used by referencing specific versions:

```yaml
# Use specific version (recommended for production)
- uses: cbuelvasc/actions/setup-java-maven-env@v1.2.3

# Use major version (gets latest compatible version)
- uses: cbuelvasc/actions/setup-java-maven-env@v1

# Use development version (not recommended in production)
- uses: cbuelvasc/actions/setup-java-maven-env@main
```

### Basic Usage

#### For Maven Projects
```yaml
- name: Setup Java Maven Environment
  uses: cbuelvasc/actions/setup-java-maven-env@v1
  with:
    java-version: '21'
    maven-args: '-T 1C --no-transfer-progress'
```

#### For Gradle Projects
```yaml
- name: Setup Java Gradle Environment
  uses: cbuelvasc/actions/setup-java-gradle-env@v1
  with:
    java-version: '21'
    gradle-args: '--no-daemon --parallel'
```

#### For Testing
```yaml
- name: Run Spring Boot Test Suite
  uses: cbuelvasc/actions/spring-boot-test-suite@v1
  with:
    build-tool: 'gradle'
    coverage-enabled: 'true'
    coverage-threshold: '80'
```

#### For Docker Build
```yaml
- name: Build Docker Image
  uses: cbuelvasc/actions/docker-build@v1
  with:
    build-tool: 'maven'
    image-name: 'my-spring-app'
    image-tag: 'latest'
    push: 'true'
    registry-username: ${{ secrets.DOCKER_USERNAME }}
    registry-password: ${{ secrets.DOCKER_PASSWORD }}
```

## 🏷️ Semantic Versioning Guide

This repository follows **Semantic Versioning 2.0.0** for all actions. Here's your complete step-by-step guide:

### Understanding Version Numbers

```
v1.2.3
│ │ └─ PATCH: Bug fixes, security patches
│ └─── MINOR: New features, backwards compatible  
└───── MAJOR: Breaking changes, API changes
```

### For Action Users

#### 🎯 **Recommended Versioning Strategy**

```yaml
# ✅ PRODUCTION: Use major version (safest)
- uses: cbuelvasc/actions/setup-java-maven-env@v1
  # Gets: Latest v1.x.x (e.g., v1.4.2)
  # Safe: Only gets compatible updates

# ✅ SPECIFIC: Use exact version (most stable)  
- uses: cbuelvasc/actions/setup-java-maven-env@v1.2.3
  # Gets: Exactly v1.2.3
  # Safe: Never changes

# ⚠️ DEVELOPMENT: Use branch (risky)
- uses: cbuelvasc/actions/setup-java-maven-env@main
  # Gets: Latest development code
  # Risk: May have breaking changes
```

#### 📊 **Version Selection Matrix**

| Use Case | Recommended | Example | Update Frequency |
|----------|-------------|---------|------------------|
| **Production** | Major version | `@v1` | Minor + Patch only |
| **Staging** | Minor version | `@v1.2` | Patch only |
| **Testing** | Exact version | `@v1.2.3` | Manual only |
| **Development** | Branch | `@main` | Every commit |

### For Action Maintainers

#### 🚀 **Step-by-Step Release Process**

**Step 1: Determine Release Type**
```bash
# Ask yourself:
# - Are there breaking changes? → MAJOR
# - New features added? → MINOR  
# - Only bug fixes? → PATCH
```

**Step 2: Choose Release Method**

**Method A: Manual Release (Recommended)**
```bash
# 1. Go to GitHub Actions tab
# 2. Select "Release Actions" workflow
# 3. Click "Run workflow"
# 4. Select release type:
#    - major: 1.0.0 → 2.0.0
#    - minor: 1.0.0 → 1.1.0
#    - patch: 1.0.0 → 1.0.1
# 5. Click "Run workflow" button
```

**Method B: Tag-based Release**
```bash
# 1. Create and push tag
git tag v1.2.3
git push origin v1.2.3

# 2. Release pipeline runs automatically
```

**Step 3: What Happens Automatically**
```bash
✅ Validates all actions
✅ Runs comprehensive tests  
✅ Generates changelog
✅ Creates GitHub release
✅ Updates major version tag (v1 → v1.2.3)
✅ Publishes release notes
```

#### 📝 **Release Workflow Examples**

**Example 1: Patch Release (Bug Fix)**
```bash
# Scenario: Fixed caching issue in maven-env action
# Current version: v1.2.1
# Target: v1.2.2

# Option A: Manual
GitHub UI → Release Actions → Run workflow → "patch"

# Option B: Tag
git tag v1.2.2
git push origin v1.2.2

# Result: 
# - v1.2.2 tag created
# - v1 tag updated to point to v1.2.2
# - Users on @v1 get the fix automatically
```

**Example 2: Minor Release (New Feature)**
```bash
# Scenario: Added support for Java 23
# Current version: v1.2.2  
# Target: v1.3.0

# Process:
GitHub UI → Release Actions → Run workflow → "minor"

# Result:
# - v1.3.0 tag created
# - v1 tag updated to point to v1.3.0
# - New feature available to @v1 users
```

**Example 3: Major Release (Breaking Change)**
```bash
# Scenario: Changed input parameter names
# Current version: v1.3.0
# Target: v2.0.0

# Process:
GitHub UI → Release Actions → Run workflow → "major"

# Result:
# - v2.0.0 tag created
# - v2 tag created pointing to v2.0.0
# - v1 tag remains at v1.3.0 (no breaking changes)
# - Users must explicitly upgrade to @v2
```

#### ⚠️ **Important Release Guidelines**

1. **Before Releasing:**
   ```bash
   # Validate locally first
   ./scripts/validate-actions.sh
   
   # Test with both Maven and Gradle
   ./scripts/validate-actions.sh --create-test-projects
   ```

2. **Version Bumping Rules:**
   - **MAJOR**: Breaking changes, API changes, removed features
   - **MINOR**: New features, new inputs, enhanced functionality  
   - **PATCH**: Bug fixes, security patches, documentation

3. **Changelog Guidelines:**
   - Automatically generated from commit messages
   - Use conventional commits for better changelogs:
     ```bash
     feat: add Java 23 support
     fix: resolve caching issue in Windows
     docs: update setup examples
     ```

### 🔍 **Version Checking**

**Check Available Versions:**
```bash
# List all releases
gh release list --repo cbuelvasc/actions

# Check latest version  
gh release view --repo cbuelvasc/actions
```

**In Workflows:**
```yaml
# See what version is being used
- name: Check Action Version
  run: |
    echo "Using action version from: ${{ github.action_ref }}"
    echo "Action repository: ${{ github.action_repository }}"
```

### 📚 **Migration Guide**

**Upgrading Between Major Versions:**

```yaml
# From v1 to v2 example
# OLD (v1):
- uses: cbuelvasc/actions/setup-java-maven-env@v1
  with:
    java-version: '21'
    cache-strategy: 'all'

# NEW (v2):  
- uses: cbuelvasc/actions/setup-java-maven-env@v2
  with:
    java-version: '21'
    cache-type: 'full'  # ← Parameter renamed
```

> 💡 **Pro Tip**: Always check the [CHANGELOG.md](./CHANGELOG.md) and release notes before upgrading major versions.

## 💡 Common Workflow Examples

### Example 1: Basic Maven CI Pipeline

```yaml
name: Maven CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    
    - name: Setup Java Maven Environment
      uses: cbuelvasc/actions/setup-java-maven-env@main
      with:
        java-version: '21'
        cache-strategy: 'all'
        spring-profiles: 'test'
    
    - name: Run Tests
      run: mvn test
    
    - name: Build Application
      run: mvn package -DskipTests
```

### Example 2: Complete Gradle Pipeline with Testing

```yaml
name: Gradle CI/CD

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    
    - name: Run Spring Boot Test Suite
      uses: cbuelvasc/actions/spring-boot-test-suite@main
      with:
        build-tool: 'gradle'
        java-version: '21'
        coverage-enabled: 'true'
        coverage-threshold: '85'
        integration-tests: 'true'
        parallel-tests: 'true'
    
    - name: Build Application
      run: ./gradlew build -x test
```

### Example 3: Multi-Module Maven Project

```yaml
name: Multi-Module Maven

on:
  push:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        module: [user-service, order-service, notification-service]
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Setup Java Maven Environment
      uses: cbuelvasc/actions/setup-java-maven-env@main
      with:
        java-version: '21'
        maven-args: '-T 2C --no-transfer-progress'
        cache-strategy: 'all'
    
    - name: Test Module
      run: mvn test -pl ${{ matrix.module }}
      working-directory: .
    
    - name: Build Module
      run: mvn package -pl ${{ matrix.module }} -DskipTests
```

### Example 4: Custom Maven Repositories

```yaml
name: Custom Repositories

on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    
    - name: Setup Maven with Custom Repositories
      uses: cbuelvasc/actions/setup-java-maven-env@main
      with:
        java-version: '21'
        maven-repositories: |
          [
            {
              "id": "central",
              "url": "https://repo1.maven.org/maven2/"
            },
            {
              "id": "spring-snapshots",
              "url": "https://repo.spring.io/snapshot"
            }
          ]
    
    - name: Build
      run: mvn clean compile
```

### Example 5: Complete CI/CD Pipeline with Docker

```yaml
name: Complete CI/CD with Docker

on:
  push:
    branches: [main]
    tags: ['v*']
  pull_request:
    branches: [main]

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  # Test the application
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    
    - name: Run Spring Boot Test Suite
      uses: cbuelvasc/actions/spring-boot-test-suite@main
      with:
        build-tool: 'maven'
        java-version: '21'
        coverage-enabled: 'true'
        coverage-threshold: '80'

  # Build and push Docker image
  docker:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main' || startsWith(github.ref, 'refs/tags/')
    
    permissions:
      contents: read
      packages: write
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Build and Push Docker Image
      uses: cbuelvasc/actions/docker-build@main
      with:
        build-tool: 'maven'
        image-name: ${{ env.IMAGE_NAME }}
        image-tag: ${{ github.ref == 'refs/heads/main' && 'latest' || github.ref_name }}
        platforms: 'linux/amd64,linux/arm64'
        push: 'true'
        registry-url: ${{ env.REGISTRY }}
        registry-username: ${{ github.actor }}
        registry-password: ${{ secrets.GITHUB_TOKEN }}
        build-args: |
          BUILD_VERSION=${{ github.sha }}
          BUILD_DATE=${{ github.event.head_commit.timestamp }}

## 🔧 Advanced Configuration

### Environment Variables

These actions automatically set up several environment variables:

| Variable | Description | Example |
|----------|-------------|---------|
| `JAVA_HOME` | Java installation path | `/opt/hostedtoolcache/Java_Temurin-Hotspot_jdk/21.0.1/...` |
| `MAVEN_OPTS` | Maven JVM options | `-Xmx2g -XX:+UseG1GC -XX:MaxGCPauseMillis=200` |
| `SPRING_PROFILES_ACTIVE` | Active Spring profiles | `test` |

### Cache Strategy Options

All setup actions support different cache strategies:

- `all`: Cache both dependencies and build cache (default)
- `dependencies-cache`: Cache only dependencies (Maven repo, Gradle cache)
- `maven-cache`/`gradle-cache`: Cache only build cache
- `none`: Disable all caching

### Java Distributions

Supported Java distributions:
- `temurin` (default) - Eclipse Temurin
- `corretto` - Amazon Corretto
- `microsoft` - Microsoft OpenJDK
- `oracle` - Oracle JDK

## 📊 Test Suite Features

The `spring-boot-test-suite` action provides:

- ✅ **Automatic environment setup** based on build tool
- ✅ **Parallel test execution** for faster builds
- ✅ **Code coverage reporting** with configurable thresholds
- ✅ **Integration test support**
- ✅ **Test result publishing** as GitHub checks
- ✅ **Flexible configuration** for different project types

### Coverage Reporting

```yaml
- name: Test with Coverage
  uses: cbuelvasc/actions/spring-boot-test-suite@main
  with:
    coverage-enabled: 'true'
    coverage-format: 'jacoco'
    coverage-threshold: '90'
    fail-on-coverage-threshold: 'true'
```

## 📚 Action Documentation

For detailed documentation on each action, including all inputs, outputs, and advanced usage:

- [Setup Java Maven Environment](./setup-java-maven-env/README.md)
- [Setup Java Gradle Environment](./setup-java-gradle-env/README.md)
- [Spring Boot Test Suite](./spring-boot-test-suite/README.md)
- [Docker Build](./docker-build/README.md)

## 🤝 Contributing

When contributing new actions or improvements:

1. Follow the [Action Standards](./ACTION_STANDARD.md)
2. Include comprehensive documentation
3. Add usage examples
4. Test with different Java versions and build tools
5. See [CI/CD Workflows Guide](.github/WORKFLOWS.md) for development workflow

### Development Setup

```bash
# Clone the repository
git clone <repository-url>
cd actions

# Validate actions locally
./scripts/validate-actions.sh

# Create test projects for validation
./scripts/validate-actions.sh --create-test-projects

# Test specific action
./scripts/validate-actions.sh --action setup-java-maven-env
```

For detailed information about:
- **Release process**: See [CI/CD Workflows Guide](.github/WORKFLOWS.md#developer-workflow)
- **Testing workflows**: See [CI/CD Workflows Guide](.github/WORKFLOWS.md#available-workflows)
- **Automation setup**: See [CI/CD Workflows Guide](.github/WORKFLOWS.md#automation-configurations)

## 👨‍💻 Author

**Carmelo Buelvas Comas**

These actions are designed to provide a consistent, optimized experience for Java Spring Boot development in GitHub Actions workflows.

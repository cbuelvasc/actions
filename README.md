# GitHub Actions for Java Spring Boot Projects

A collection of reusable GitHub Actions designed to streamline CI/CD workflows for Java Spring Boot applications. These actions provide optimized setups for Maven and Gradle builds, comprehensive testing suites, and best practices for Spring Boot development.

## 🚀 Available Actions

| Action | Description | Build Tool | Use Case |
|--------|-------------|------------|----------|
| [setup-java-maven-env](./setup-java-maven-env/) | Sets up Java 21 and Maven environment with caching | Maven | Environment setup for Maven projects |
| [setup-java-gradle-env](./setup-java-gradle-env/) | Sets up Java 21 and Gradle environment with caching | Gradle | Environment setup for Gradle projects |
| [spring-boot-test-suite](./spring-boot-test-suite/) | Comprehensive testing with coverage and reporting | Maven/Gradle | Complete testing pipeline |
| [docker-build](./docker-build/) | Builds and optionally pushes Docker images | Maven/Gradle | Docker image creation and deployment |

## 📋 Quick Start

### Basic Usage

#### For Maven Projects
```yaml
- name: Setup Java Maven Environment
  uses: your-org/actions/setup-java-maven-env@main
  with:
    java-version: '21'
    maven-args: '-T 1C --no-transfer-progress'
```

#### For Gradle Projects
```yaml
- name: Setup Java Gradle Environment
  uses: your-org/actions/setup-java-gradle-env@main
  with:
    java-version: '21'
    gradle-args: '--no-daemon --parallel'
```

#### For Testing
```yaml
- name: Run Spring Boot Test Suite
  uses: your-org/actions/spring-boot-test-suite@main
  with:
    build-tool: 'gradle'
    coverage-enabled: 'true'
    coverage-threshold: '80'
```

#### For Docker Build
```yaml
- name: Build Docker Image
  uses: your-org/actions/docker-build@main
  with:
    build-tool: 'maven'
    image-name: 'my-spring-app'
    image-tag: 'latest'
    push: 'true'
    registry-username: ${{ secrets.DOCKER_USERNAME }}
    registry-password: ${{ secrets.DOCKER_PASSWORD }}
```

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
      uses: your-org/actions/setup-java-maven-env@main
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
      uses: your-org/actions/spring-boot-test-suite@main
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
      uses: your-org/actions/setup-java-maven-env@main
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
      uses: your-org/actions/setup-java-maven-env@main
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
      uses: your-org/actions/spring-boot-test-suite@main
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
      uses: your-org/actions/docker-build@main
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
  uses: your-org/actions/spring-boot-test-suite@main
  with:
    coverage-enabled: 'true'
    coverage-format: 'jacoco'
    coverage-threshold: '90'
    fail-on-coverage-threshold: 'true'
```

## 🛠️ Troubleshooting

### Common Issues

1. **Cache not working**: Ensure your `pom.xml` or `build.gradle` files are in the repository root
2. **Out of memory errors**: Increase JVM memory with `jvm-args` or `maven-args`
3. **Tests failing**: Check that `spring-profiles` are correctly configured

### Debug Mode

Enable debug output by setting:

```yaml
- name: Setup with Debug
  uses: your-org/actions/setup-java-gradle-env@main
  with:
    java-version: '21'
  env:
    ACTIONS_STEP_DEBUG: true
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

## 📝 License

This project is licensed under the MIT License - see the individual action directories for specific licensing information.

## 👨‍💻 Author

**Carmelo Buelvas Comas**

These actions are designed to provide a consistent, optimized experience for Java Spring Boot development in GitHub Actions workflows.

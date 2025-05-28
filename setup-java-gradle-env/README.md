# Setup Java Gradle Environment Action

A comprehensive GitHub Action that configures Java 21 and Gradle environment for Spring Boot applications with optimized caching strategies.

## Features

- 🚀 **Java Setup**: Configures Java with multiple distribution options (Temurin, Corretto, Microsoft, Oracle)
- 📦 **Gradle Configuration**: Supports both Gradle wrapper and specific versions
- ⚡ **Smart Caching**: Multiple caching strategies for dependencies and build cache
- 🔧 **JVM Optimization**: Configurable JVM arguments for optimal performance
- 🌱 **Spring Boot Ready**: Pre-configured for Spring Boot applications
- 📊 **Build Insights**: Optional Gradle build scan integration
- 🔄 **Flexible**: Supports additional Maven repositories

## Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `java-version` | Java version to setup | No | `21` |
| `java-distribution` | Java distribution (temurin, corretto, microsoft, oracle) | No | `temurin` |
| `gradle-version` | Specific Gradle version (uses wrapper by default) | No | `wrapper` |
| `cache-strategy` | Cache strategy (gradle-cache\|dependencies-cache\|all\|none) | No | `all` |
| `jvm-args` | Additional JVM arguments for Gradle | No | `-Xmx4g -XX:+UseG1GC -XX:MaxGCPauseMillis=200` |
| `spring-profiles` | Spring profiles to activate during build | No | `test` |
| `gradle-args` | Additional Gradle arguments | No | `--no-daemon --parallel` |
| `maven-repositories` | Additional Maven repositories (JSON array) | No | `[]` |

## Outputs

| Output | Description |
|--------|-------------|
| `gradle-version` | Installed Gradle version |
| `java-home` | Java installation path |
| `java-version` | Installed Java version |
| `cache-hit` | Whether Gradle cache was found |
| `cache-key` | Cache key used |

## Usage Examples

### Basic Usage

```yaml
name: CI/CD Pipeline
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Java & Gradle
        uses: your-org/your-repo/.github/actions/setup-java-gradle-env@v1
        
      - name: Run tests
        run: ./gradlew test
```

### Advanced Configuration

```yaml
name: Advanced CI/CD
on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Java & Gradle Environment
        uses: your-org/your-repo/.github/actions/setup-java-gradle-env@v1
        with:
          java-version: '21'
          java-distribution: 'temurin'
          gradle-version: '8.5'
          cache-strategy: 'all'
          jvm-args: '-Xmx6g -XX:+UseG1GC -XX:MaxGCPauseMillis=100'
          spring-profiles: 'test,integration'
          gradle-args: '--no-daemon --parallel --build-cache'
          maven-repositories: '["https://repo.spring.io/milestone", "https://oss.sonatype.org/content/repositories/snapshots"]'
        
      - name: Build application
        run: ./gradlew build
        
      - name: Run integration tests
        run: ./gradlew integrationTest
```

### Multi-OS Matrix Build

```yaml
name: Multi-OS Build
on: [push, pull_request]

jobs:
  test:
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
        java-version: ['17', '21']
    runs-on: ${{ matrix.os }}
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Java & Gradle
        uses: your-org/your-repo/.github/actions/setup-java-gradle-env@v1
        with:
          java-version: ${{ matrix.java-version }}
          cache-strategy: 'all'
          
      - name: Test
        run: ./gradlew test
```

### Performance Optimized Build

```yaml
name: Performance Build
on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup High-Performance Environment
        uses: your-org/your-repo/.github/actions/setup-java-gradle-env@v1
        with:
          jvm-args: '-Xmx8g -XX:+UseG1GC -XX:MaxGCPauseMillis=50 -XX:+UnlockExperimentalVMOptions -XX:+UseJVMCICompiler'
          gradle-args: '--no-daemon --parallel --build-cache --configuration-cache'
          cache-strategy: 'all'
        env:
          GRADLE_BUILD_SCAN: 'true'
          
      - name: Build with optimizations
        run: ./gradlew build --scan
```

### Spring Boot Microservices

```yaml
name: Microservices Build
on: [push, pull_request]

jobs:
  build-services:
    strategy:
      matrix:
        service: [user-service, order-service, payment-service]
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Java & Gradle for Spring Boot
        uses: your-org/your-repo/.github/actions/setup-java-gradle-env@v1
        with:
          spring-profiles: 'test,docker'
          maven-repositories: '["https://repo.spring.io/milestone"]'
          
      - name: Build service
        working-directory: ./${{ matrix.service }}
        run: ./gradlew bootJar
        
      - name: Test service
        working-directory: ./${{ matrix.service }}
        run: ./gradlew test
```

## Cache Strategies

### `all` (Default)
Caches both Gradle dependencies and build cache for maximum performance.

### `dependencies-cache`
Only caches Gradle dependencies (`.gradle/caches`, `~/.gradle/caches`).

### `gradle-cache`
Only caches Gradle build cache for incremental builds.

### `none`
Disables all caching (useful for debugging cache issues).

## JVM Optimization

The action comes with sensible JVM defaults optimized for CI/CD environments:

```bash
-Xmx4g                    # 4GB heap size
-XX:+UseG1GC             # G1 garbage collector
-XX:MaxGCPauseMillis=200 # GC pause time goal
```

### Custom JVM Arguments Examples

```yaml
# For large projects
jvm-args: '-Xmx8g -XX:+UseG1GC -XX:MaxGCPauseMillis=100'

# For memory-constrained environments
jvm-args: '-Xmx2g -XX:+UseSerialGC'

# With JVM compiler optimizations
jvm-args: '-Xmx6g -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -XX:+UseJVMCICompiler'
```

## Environment Variables

| Variable | Description |
|----------|-------------|
| `GRADLE_BUILD_SCAN` | Set to `true` to enable Gradle build scans |
| `GRADLE_OPTS` | Additional Gradle options |
| `JAVA_OPTS` | Additional Java options |

## Best Practices

### 1. Use Gradle Wrapper
Always prefer using the Gradle wrapper over a specific version:
```yaml
gradle-version: 'wrapper'  # Default and recommended
```

### 2. Optimize for Your Project Size
- **Small projects**: Use default JVM settings
- **Large projects**: Increase heap size and enable build cache
- **Monorepos**: Use parallel builds and configuration cache

### 3. Cache Strategy Selection
- **CI/CD pipelines**: Use `all` for best performance
- **Development branches**: Use `dependencies-cache` for faster feedback
- **Release builds**: Use `gradle-cache` for reproducible builds

### 4. Spring Profiles
Configure appropriate profiles for different environments:
```yaml
spring-profiles: 'test,ci'        # For CI builds
spring-profiles: 'test,docker'    # For containerized builds
spring-profiles: 'prod'           # For production builds
```

## Troubleshooting

### Common Issues

#### Cache Miss
If you're experiencing frequent cache misses:
```yaml
- name: Debug cache
  uses: your-org/your-repo/.github/actions/setup-java-gradle-env@v1
  with:
    cache-strategy: 'all'
    
- name: Check cache status
  run: echo "Cache hit: ${{ steps.setup.outputs.cache-hit }}"
```

#### Out of Memory
For large projects that run out of memory:
```yaml
jvm-args: '-Xmx8g -XX:+UseG1GC -XX:MaxGCPauseMillis=100'
```

#### Slow Builds
To improve build performance:
```yaml
gradle-args: '--no-daemon --parallel --build-cache --configuration-cache'
jvm-args: '-Xmx6g -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions'
```

## Requirements

- GitHub Actions runner with at least 2GB RAM (4GB recommended)
- Gradle project with wrapper (recommended) or compatible Gradle version
- Java project compatible with specified Java version

## Support

For issues and questions:
- Create an issue in the repository
- Check existing documentation
- Review troubleshooting section

---

**Note**: This action is optimized for Spring Boot applications but can be used with any Gradle-based Java project.

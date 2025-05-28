# Setup Java Maven Environment Action

A comprehensive GitHub Action for setting up Java and Maven environment for Spring Boot applications with intelligent caching and optimization features.

## Features

- ✅ **Automatic Java setup** (Java 8-21) with multiple distributions
- ✅ **Maven environment configuration** with wrapper support
- ✅ **Intelligent caching strategies** for dependencies and build artifacts
- ✅ **Spring Boot optimizations** with profile support
- ✅ **Maven settings configuration** with custom repositories
- ✅ **Performance tuning** with optimized JVM settings
- ✅ **Dependency pre-download** for faster builds
- ✅ **Comprehensive validation** and error handling

## Basic Usage

```yaml
name: Build

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Java Maven Environment
        uses: ./actions/setup-java-maven-env
        with:
          java-version: '21'
```

## Advanced Configuration

```yaml
name: Advanced Maven Build

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Java Maven Environment
        id: setup
        uses: ./actions/setup-java-maven-env
        with:
          java-version: '21'
          java-distribution: 'temurin'
          maven-version: '3.9.6'
          maven-args: '-T 2C --no-transfer-progress --batch-mode'
          cache-strategy: 'all'
          spring-profiles: 'dev,test'
          maven-repositories: |
            [
              "https://repo.spring.io/milestone",
              "https://repository.jboss.org/nexus/content/repositories/releases"
            ]
      
      - name: Use setup outputs
        run: |
          echo "Cache hit: ${{ steps.setup.outputs.cache-hit }}"
          echo "Maven version: ${{ steps.setup.outputs.maven-version }}"
          echo "Java home: ${{ steps.setup.outputs.java-home }}"
```

## Inputs

### Required Inputs
*None - All inputs have sensible defaults*

### Standard Build Inputs

| Input | Description | Required | Default Value |
|-------|-------------|----------|---------------|
| `java-version` | Java version to set up (8, 11, 17, 21) | No | `'21'` |
| `java-distribution` | Java distribution (temurin, corretto, microsoft, oracle) | No | `'temurin'` |
| `cache-strategy` | Cache strategy (maven-cache, dependencies-cache, all, none) | No | `'all'` |
| `spring-profiles` | Spring profiles to activate during build | No | `'test'` |

### Maven-Specific Inputs

| Input | Description | Required | Default Value |
|-------|-------------|----------|---------------|
| `maven-version` | Specific Maven version (uses system default if 'default') | No | `'default'` |
| `maven-args` | Additional Maven arguments | No | `'-T 1C --no-transfer-progress'` |
| `maven-repositories` | Additional Maven repositories (JSON array format) | No | `'[]'` |

## Outputs

### Primary Outputs

| Output | Description |
|--------|-------------|
| `cache-hit` | Indicates if Maven cache was found (`true`/`false`) |
| `cache-key` | Cache key used for dependencies |
| `maven-version` | Installed Maven version |

### Environment Outputs

| Output | Description |
|--------|-------------|
| `java-home` | Java installation path |
| `java-version` | Installed Java version |

## Cache Strategies

### `all` (Default)
- Caches Maven dependencies (`~/.m2/repository`)
- Caches Maven wrapper (`~/.m2/wrapper`)
- Caches build artifacts (`target/maven-archiver`, `target/maven-status`)

### `dependencies-cache`
- Only caches Maven dependencies
- Best for simple projects

### `maven-cache`
- Only caches build artifacts
- Useful when dependencies change frequently

### `none`
- Disables all caching
- For debugging cache issues

## Usage Examples

### Simple Spring Boot Project

```yaml
- name: Setup Maven Environment
  uses: ./actions/setup-java-maven-env
  with:
    java-version: '17'
    spring-profiles: 'test'
```

### Multi-Module Maven Project

```yaml
- name: Setup Maven for Multi-Module
  uses: ./actions/setup-java-maven-env
  with:
    java-version: '21'
    maven-args: '-T 2C --no-transfer-progress --batch-mode'
    cache-strategy: 'all'
```

### Corporate Environment with Custom Repositories

```yaml
- name: Setup Maven with Corporate Repos
  uses: ./actions/setup-java-maven-env
  with:
    java-version: '17'
    maven-repositories: |
      [
        "https://nexus.company.com/repository/maven-public/",
        "https://repo.spring.io/milestone"
      ]
```

### Performance Optimized Build

```yaml
- name: High-Performance Maven Setup
  uses: ./actions/setup-java-maven-env
  with:
    java-version: '21'
    maven-version: '3.9.6'
    maven-args: '-T 4C --no-transfer-progress --batch-mode -Dmaven.compile.fork=true'
    cache-strategy: 'all'
```

### Development Environment

```yaml
- name: Setup Dev Environment
  uses: ./actions/setup-java-maven-env
  with:
    java-version: '21'
    spring-profiles: 'dev,h2,debug'
    maven-args: '-X'  # Debug mode
```

## Environment Variables Set

The action automatically sets these environment variables:

- `MAVEN_OPTS`: JVM optimization settings (`-Xmx2g -XX:+UseG1GC -XX:MaxGCPauseMillis=200`)
- `SPRING_PROFILES_ACTIVE`: Active Spring profiles for the build

## Maven Configuration

### Automatic Settings.xml Creation

The action creates a basic `~/.m2/settings.xml` if it doesn't exist:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 
                              http://maven.apache.org/xsd/settings-1.0.0.xsd">
  <localRepository/>
  <interactiveMode>false</interactiveMode>
  <usePluginRegistry>false</usePluginRegistry>
  <offline>false</offline>
</settings>
```

### Repository Integration

When `maven-repositories` is provided, the action automatically adds them to your `settings.xml`:

```xml
<repositories>
  <repository>
    <id>repo-https-repo-spring-io-milestone</id>
    <url>https://repo.spring.io/milestone</url>
  </repository>
</repositories>
```

## Optimization Features

### JVM Tuning
- **Heap Size**: 2GB default allocation
- **Garbage Collector**: G1GC for better performance
- **GC Tuning**: MaxGCPauseMillis=200 for lower latency

### Maven Optimizations
- **Parallel Builds**: `-T 1C` (1 thread per core) by default
- **Transfer Progress**: Disabled with `--no-transfer-progress`
- **Dependency Pre-download**: Runs `dependency:go-offline` automatically

### Caching Optimizations
- **Smart Cache Keys**: Based on `pom.xml` and wrapper properties
- **Hierarchical Restore**: Multiple fallback cache keys
- **Build Artifact Caching**: Includes Maven metadata and status

## Integration with Other Actions

This action is designed to work seamlessly with:

- **Spring Boot Test Suite**: Provides optimized Maven environment
- **Deployment Actions**: Consistent build environment
- **Code Quality Tools**: SonarQube, SpotBugs, etc.

## Best Practices

### Performance
1. **Use parallel builds**: `-T 2C` or `-T 4C` based on runner capacity
2. **Enable all caching**: Use `cache-strategy: 'all'` for best results
3. **Specify Java 21**: Latest LTS with best performance

### Reliability
1. **Pin Maven version**: Use specific versions for reproducible builds
2. **Use wrapper**: Prefer `mvnw` over system Maven
3. **Set profiles**: Use dedicated profiles for CI/CD

### Security
1. **Validate repositories**: Only use trusted Maven repositories
2. **Use official distributions**: Stick to `temurin` or `corretto`
3. **Review dependencies**: Regularly audit dependency sources

## Troubleshooting

### Cache Issues
If you experience cache-related problems:

```yaml
- name: Debug Cache Issues
  uses: ./actions/setup-java-maven-env
  with:
    cache-strategy: 'none'  # Temporarily disable caching
```

### Maven Wrapper Issues
If the Maven wrapper fails:

```yaml
- name: Force System Maven
  uses: ./actions/setup-java-maven-env
  with:
    maven-version: '3.9.6'  # Force specific version
```

### Memory Issues
For large projects that run out of memory:

```yaml
- name: High Memory Setup
  uses: ./actions/setup-java-maven-env
  with:
    maven-args: '-T 1C -Xmx4g'
```

### Repository Issues
If custom repositories are not working:

```yaml
- name: Debug Repository Setup
  uses: ./actions/setup-java-maven-env
  with:
    maven-repositories: '[]'  # Use default repositories only
```

## Examples by Use Case

### Spring Boot Microservice

```yaml
- name: Setup for Microservice
  uses: ./actions/setup-java-maven-env
  with:
    java-version: '21'
    spring-profiles: 'test,docker'
    maven-args: '-T 2C --no-transfer-progress'
```

### Enterprise Application

```yaml
- name: Setup for Enterprise
  uses: ./actions/setup-java-maven-env
  with:
    java-version: '17'
    maven-version: '3.8.8'
    maven-repositories: |
      [
        "https://nexus.company.com/repository/maven-public/"
      ]
    cache-strategy: 'all'
```

### Multi-Profile Build

```yaml
strategy:
  matrix:
    profile: [dev, test, prod]

steps:
  - name: Setup for ${{ matrix.profile }}
    uses: ./actions/setup-java-maven-env
    with:
      spring-profiles: ${{ matrix.profile }}
```

This action provides a solid foundation for Maven-based Spring Boot projects with optimized performance and comprehensive caching strategies. 
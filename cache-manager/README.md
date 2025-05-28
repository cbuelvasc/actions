# Cache Manager Action

A unified cache management solution for Maven and Gradle builds in GitHub Actions workflows. This action optimizes build performance by intelligently caching dependencies and build outputs based on your build tool and strategy preferences.

## 📋 Features

- **Multi-tool support**: Works with both Maven and Gradle projects
- **Flexible caching strategies**: Choose between dependencies-only, build-only, or comprehensive caching
- **Intelligent cache keys**: Automatically generates optimized cache keys based on project files
- **Cross-platform**: Supports Linux, macOS, and Windows runners
- **Customizable**: Add custom suffixes to cache keys for advanced scenarios

## 🚀 Usage

### Basic Usage

```yaml
- name: Setup cache
  uses: ./actions/cache-manager
  with:
    build-tool: 'gradle'
```

### Advanced Usage

```yaml
- name: Setup cache with custom strategy
  uses: ./actions/cache-manager
  with:
    build-tool: 'maven'
    cache-strategy: 'dependencies-cache'
    cache-key-suffix: '-custom'
```

## 📥 Inputs

| Input | Description | Required | Default | Valid Values |
|-------|-------------|----------|---------|--------------|
| `build-tool` | Build tool to use for caching | ✅ Yes | - | `maven`, `gradle` |
| `cache-strategy` | Caching strategy to apply | ❌ No | `all` | `dependencies-cache`, `build-cache`, `all`, `none` |
| `cache-key-suffix` | Additional suffix for cache key customization | ❌ No | `''` | Any string |

### Input Details

#### `build-tool`
Specifies which build tool your project uses. This determines:
- Which dependency directories to cache
- Which build files to monitor for cache key generation
- Tool-specific optimization patterns

#### `cache-strategy`
Controls what gets cached:
- **`dependencies-cache`**: Only caches downloaded dependencies (recommended for CI/CD pipelines)
- **`build-cache`**: Only caches build outputs and intermediate files
- **`all`**: Caches both dependencies and build outputs (recommended for development workflows)
- **`none`**: Disables caching entirely

#### `cache-key-suffix`
Allows customization of cache keys for advanced scenarios such as:
- Multi-environment builds
- Feature branch isolation
- Custom build configurations

## 📤 Outputs

| Output | Description | Type |
|--------|-------------|------|
| `cache-hit` | Indicates if cache was restored successfully | `boolean` |
| `cache-key` | The generated cache key used for dependencies | `string` |

### Output Usage

```yaml
- name: Setup cache
  id: cache-setup
  uses: ./actions/cache-manager
  with:
    build-tool: 'gradle'

- name: Check cache status
  run: |
    echo "Cache hit: ${{ steps.cache-setup.outputs.cache-hit }}"
    echo "Cache key: ${{ steps.cache-setup.outputs.cache-key }}"
```

## 📁 Cached Paths

### Gradle Projects
- **Dependencies**: `~/.gradle/caches`, `~/.gradle/wrapper`, `.gradle/caches`
- **Build outputs**: `~/.gradle/build-cache`, `.gradle/build-cache`

### Maven Projects
- **Dependencies**: `~/.m2/repository`, `~/.m2/wrapper`
- **Build outputs**: `~/.m2/build-cache`, `target/maven-archiver`, `target/maven-status`

## 🔑 Cache Key Generation

Cache keys are automatically generated based on:

### For Gradle
```
gradle-{OS}-{hash(*.gradle*, gradle-wrapper.properties, gradle.properties)}{suffix}
```

### For Maven
```
maven-{OS}-{hash(pom.xml, maven-wrapper.properties)}{suffix}
```

## 📚 Examples

### Spring Boot with Gradle

```yaml
name: Spring Boot CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup cache
        uses: ./actions/cache-manager
        with:
          build-tool: 'gradle'
          cache-strategy: 'all'
          
      - name: Setup Java
        uses: actions/setup-java@v4
        with:
          distribution: 'temurin'
          java-version: '21'
          
      - name: Run tests
        run: ./gradlew test
```

### Maven Multi-Module Project

```yaml
name: Maven Build

on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup dependencies cache only
        uses: ./actions/cache-manager
        with:
          build-tool: 'maven'
          cache-strategy: 'dependencies-cache'
          
      - name: Setup Java
        uses: actions/setup-java@v4
        with:
          distribution: 'temurin'
          java-version: '21'
          
      - name: Build project
        run: ./mvnw clean compile
```

### Feature Branch Isolation

```yaml
- name: Setup isolated cache
  uses: ./actions/cache-manager
  with:
    build-tool: 'gradle'
    cache-strategy: 'all'
    cache-key-suffix: '-${{ github.head_ref }}'
```

## ⚡ Performance Tips

1. **Use `dependencies-cache` for CI/CD**: Faster for build pipelines that don't need build cache persistence
2. **Use `all` for development**: Better for workflows that rebuild frequently
3. **Custom suffixes for isolation**: Use branch names or environment variables to isolate caches
4. **Monitor cache hit rates**: Use outputs to track cache effectiveness

## 🔧 Troubleshooting

### Cache Miss Issues
- Ensure build files haven't changed unexpectedly
- Check if `cache-key-suffix` is consistent across runs
- Verify file paths exist in your project structure

### Permission Issues
- Ensure runner has write access to cache directories
- Check if workspace permissions allow cache operations

### Build Tool Detection
- Verify `build-tool` input matches your project structure
- Ensure wrapper files are present and accessible

## 🏗️ Integration with Other Actions

This action works well with:

```yaml
# Setup Java first
- uses: actions/setup-java@v4
  with:
    distribution: 'temurin'
    java-version: '21'

# Then setup cache
- uses: ./actions/cache-manager
  with:
    build-tool: 'gradle'

# Finally run builds
- name: Build
  run: ./gradlew build
```

## 📊 Monitoring Cache Effectiveness

```yaml
- name: Setup cache with monitoring
  id: cache
  uses: ./actions/cache-manager
  with:
    build-tool: 'maven'
    
- name: Report cache status
  run: |
    if [[ "${{ steps.cache.outputs.cache-hit }}" == "true" ]]; then
      echo "✅ Cache hit! Build should be faster."
    else
      echo "❌ Cache miss. First run or cache expired."
    fi
    echo "📦 Cache key: ${{ steps.cache.outputs.cache-key }}"
```

## 🤝 Contributing

When contributing to this action:

1. Follow the [ACTION_STANDARD.md](../ACTION_STANDARD.md) guidelines
2. Test with both Maven and Gradle projects
3. Verify cache behavior across different operating systems
4. Update documentation for any new features or changes

## 📝 License

This action is part of the POC project by Carmelo Buelvas Comas. 
# Cache Gradle Dependencies Action

This custom action optimizes build times in GitHub Actions by caching Gradle dependencies for specific services.

## 📋 Description

The `Cache Gradle Dependencies` action automates the Gradle dependency caching process, significantly reducing build times in CI/CD workflows by avoiding repetitive dependency downloads.

## 🔧 Functionality

This action caches the following directories:
- `~/.gradle/caches` - Global Gradle cache
- `~/.gradle/wrapper` - Gradle wrapper
- `~/.gradle/daemon` - Gradle daemon
- `{service-name}/.gradle/caches` - Service-specific cache
- `{service-name}/.gradle/wrapper` - Service-specific wrapper

## 📝 Inputs

| Parameter | Description | Required | Default Value |
|-----------|-------------|----------|---------------|
| `service-name` | The name of the service to cache dependencies for | ✅ Yes | `user-service` |

## 🚀 Usage in Workflows

### Basic Example

```yaml
name: Build Service
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Set up JDK 21
        uses: actions/setup-java@v4
        with:
          java-version: '21'
          distribution: 'temurin'
      
      - name: Cache Gradle Dependencies
        uses: ./actions/.github/workflows/cache
        with:
          service-name: order-service
      
      - name: Build with Gradle
        run: |
          cd order-service
          ./gradlew build
```

### Multiple Services Example

```yaml
name: Build Multiple Services
on:
  push:
    branches: [ main ]

jobs:
  build-order-service:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with:
          java-version: '21'
          distribution: 'temurin'
      
      - name: Cache Gradle Dependencies for Order Service
        uses: ./actions/.github/workflows/cache
        with:
          service-name: order-service
      
      - name: Build Order Service
        run: |
          cd order-service
          ./gradlew build

  build-user-service:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with:
          java-version: '21'
          distribution: 'temurin'
      
      - name: Cache Gradle Dependencies for User Service
        uses: ./actions/.github/workflows/cache
        with:
          service-name: user-service
      
      - name: Build User Service
        run: |
          cd user-service
          ./gradlew build
```

### Matrix Strategy Example

```yaml
name: Build All Services
on:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        service: [order-service, user-service, payment-service]
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Set up JDK 21
        uses: actions/setup-java@v4
        with:
          java-version: '21'
          distribution: 'temurin'
      
      - name: Cache Gradle Dependencies
        uses: ./actions/.github/workflows/cache
        with:
          service-name: ${{ matrix.service }}
      
      - name: Build ${{ matrix.service }}
        run: |
          cd ${{ matrix.service }}
          ./gradlew build
```

## 🔑 Cache Strategy

The action uses a hierarchical cache strategy:

1. **Primary cache**: `{OS}-gradle-{service-name}-{hash-files}`
2. **Service fallback cache**: `{OS}-gradle-{service-name}-`
3. **General fallback cache**: `{OS}-gradle-`
4. **Gradle files cache**: `{OS}-gradle-{hash-gradle-files}`
5. **Wrapper cache**: `{OS}-gradle-wrapper-`

## 📊 Benefits

- ⚡ **Significant build time reduction** (up to 80% less time)
- 💰 **CI/CD cost savings** by reducing execution minutes
- 🔄 **Smart cache** that automatically invalidates when dependencies change
- 🎯 **Service-specific cache** for granular optimization
- 🔒 **Shared global cache** for common dependencies

## 🛠️ Technical Considerations

### Cache Invalidation

The cache is automatically invalidated when:
- `*.gradle` or `*.gradle.kts` files change
- `gradle-wrapper.properties` is modified
- The runner's operating system changes

### Cache Size

GitHub Actions has cache limits:
- **10 GB per repository**
- **LRU Cache**: Oldest caches are automatically removed

### Best Practices

1. **Use descriptive service names** for easy identification
2. **Maintain consistent directory structure** for services
3. **Combine with setup-java** for complete environment caching
4. **Monitor cache usage** in the repository's Actions tab

## 🔍 Troubleshooting

### Cache is not being used

```yaml
# Verify the service path is correct
- name: Debug service path
  run: |
    echo "Service path: ${{ inputs.service-name }}"
    ls -la ${{ inputs.service-name }}/
```

### Cache is too large

```yaml
# Clean Gradle cache manually if needed
- name: Clean Gradle cache
  run: |
    cd ${{ inputs.service-name }}
    ./gradlew clean
```

## 📚 References

- [GitHub Actions Cache](https://github.com/actions/cache)
- [Gradle Build Cache](https://docs.gradle.org/current/userguide/build_cache.html)
- [Composite Actions](https://docs.github.com/en/actions/creating-actions/creating-a-composite-action)

## 👨‍💻 Author

**Carmelo Buelvas Comas**

---

> 💡 **Tip**: For maximum performance, combine this action with `setup-java` which also includes Maven/Gradle dependency caching.

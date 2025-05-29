# Docker Build for Java Spring Boot

🐳 **Builds and optionally pushes Docker images for Java Spring Boot applications with Maven or Gradle support**

This GitHub Action provides a comprehensive solution for building Docker images from Java Spring Boot applications, supporting both Maven and Gradle build tools with optimized caching and multi-platform builds.

## 🚀 Features

- **Multi-Build Tool Support**: Works with both Maven and Gradle projects
- **Java Version Flexibility**: Supports Java 8+ with configurable distributions
- **Registry Support**: Works with Docker Hub, GitHub Container Registry, and private registries
- **Multi-Platform Builds**: Support for AMD64, ARM64, and other architectures
- **Optimized Caching**: Built-in GitHub Actions cache integration
- **Spring Boot Optimized**: Automatic Spring profiles configuration
- **Comprehensive Validation**: Input validation and error handling
- **Rich Outputs**: Provides image metadata, digests, and build information

## 📋 Quick Start

### Basic Maven Project

```yaml
- name: Build Docker Image
  uses: your-org/actions/docker-build@main
  with:
    build-tool: 'maven'
    image-name: 'my-spring-app'
    image-tag: 'v1.0.0'
```

### Basic Gradle Project

```yaml
- name: Build Docker Image
  uses: your-org/actions/docker-build@main
  with:
    build-tool: 'gradle'
    image-name: 'my-spring-app'
    image-tag: 'v1.0.0'
```

### Build and Push to Registry

```yaml
- name: Build and Push Docker Image
  uses: your-org/actions/docker-build@main
  with:
    build-tool: 'maven'
    image-name: 'my-spring-app'
    image-tag: 'latest'
    push: 'true'
    registry-url: 'ghcr.io'
    registry-username: ${{ github.actor }}
    registry-password: ${{ secrets.GITHUB_TOKEN }}
```

## 🔧 Inputs

### Required Inputs

| Input | Description | Example |
|-------|-------------|---------|
| `build-tool` | Build tool to use (`maven` or `gradle`) | `maven` |
| `image-name` | Docker image name (without registry prefix or tag) | `my-spring-app` |

### Optional Inputs

| Input | Description | Default | Example |
|-------|-------------|---------|---------|
| `build-args` | Docker build arguments in multiline format (ARG=value format) | `''` | `ARG1=value1\nARG2=value2` |
| `cache-from` | External cache sources | `type=gha` | `type=registry,ref=ghcr.io/user/app:cache` |
| `cache-strategy` | Cache strategy (`docker-cache`, `build-cache`, `all`, `none`) | `all` | `docker-cache` |
| `cache-to` | External cache export destination | `type=gha,mode=max` | `type=registry,ref=ghcr.io/user/app:cache` |
| `context` | Build context path relative to working directory | `.` | `./backend` |
| `dockerfile` | Dockerfile path relative to working directory | `Dockerfile` | `docker/Dockerfile.prod` |
| `image-tag` | Docker image tag (e.g., latest, v1.0.0, dev) | `latest` | `v1.0.0` |
| `java-distribution` | Java distribution | `temurin` | `corretto` |
| `java-version` | Java version to use (8, 11, 17, 21, etc.) | `21` | `17` |
| `platforms` | Target platforms for build (comma-separated) | `linux/amd64` | `linux/amd64,linux/arm64` |
| `push` | Push image to registry (true or false) | `false` | `true` |
| `registry-password` | Docker registry password or token | `''` | `${{ secrets.DOCKER_PASSWORD }}` |
| `registry-url` | Docker registry URL (docker.io, ghcr.io, etc.) | `docker.io` | `ghcr.io` |
| `registry-username` | Docker registry username | `''` | `${{ github.actor }}` |
| `spring-profiles` | Spring profiles for build (comma-separated) | `prod` | `prod,docker` |
| `working-directory` | Working directory for the project | `.` | `./backend` |

## 📤 Outputs

| Output | Description |
|--------|-------------|
| `build-tool` | Build tool used (maven or gradle) |
| `cache-hit` | Indicates if Docker cache was found |
| `image-digest` | Image digest SHA256 hash |
| `image-id` | Built image ID |
| `image-metadata` | Build result metadata JSON |
| `image-full-name` | Full image name with registry and tag |
| `java-version` | Java version used in build |

## 💡 Usage Examples

### Example 1: Simple Docker Build

```yaml
name: Docker Build

on:
  push:
    branches: [main]

jobs:
  docker:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    
    - name: Build Docker Image
      uses: your-org/actions/docker-build@main
      with:
        build-tool: 'maven'
        image-name: 'my-app'
        image-tag: ${{ github.sha }}
```

### Example 2: Multi-Platform Build with Push

```yaml
name: Multi-Platform Docker Build

on:
  release:
    types: [published]

jobs:
  docker:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    
    - name: Build and Push Multi-Platform Image
      uses: your-org/actions/docker-build@main
      with:
        build-tool: 'gradle'
        image-name: 'my-company/my-app'
        image-tag: ${{ github.event.release.tag_name }}
        platforms: 'linux/amd64,linux/arm64'
        push: 'true'
        registry-username: ${{ secrets.DOCKER_USERNAME }}
        registry-password: ${{ secrets.DOCKER_PASSWORD }}
```

### Example 3: Private Registry with Custom Dockerfile

```yaml
name: Private Registry Build

on:
  push:
    branches: [main]

jobs:
  docker:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    
    - name: Build and Push to Private Registry
      uses: your-org/actions/docker-build@main
      with:
        build-tool: 'maven'
        image-name: 'my-app'
        image-tag: 'latest'
        dockerfile: 'docker/Dockerfile.prod'
        context: '.'
        push: 'true'
        registry-url: 'registry.company.com'
        registry-username: ${{ secrets.REGISTRY_USERNAME }}
        registry-password: ${{ secrets.REGISTRY_PASSWORD }}
        build-args: |
          ENV=production
          VERSION=${{ github.sha }}
```

### Example 4: Gradle with Custom Java Version

```yaml
name: Gradle Docker Build

on:
  workflow_dispatch:
    inputs:
      java-version:
        description: 'Java version'
        required: true
        default: '17'
        type: string

jobs:
  docker:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    
    - name: Build Docker Image
      uses: your-org/actions/docker-build@main
      with:
        build-tool: 'gradle'
        image-name: 'my-gradle-app'
        image-tag: 'java-${{ inputs.java-version }}'
        java-version: ${{ inputs.java-version }}
        spring-profiles: 'prod,docker'
```

### Example 5: Matrix Build for Multiple Services

```yaml
name: Multi-Service Docker Build

on:
  push:
    branches: [main]

jobs:
  docker:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        service:
          - name: user-service
            build-tool: maven
            directory: ./user-service
          - name: order-service
            build-tool: gradle
            directory: ./order-service
          - name: notification-service
            build-tool: maven
            directory: ./notification-service
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Build ${{ matrix.service.name }}
      uses: your-org/actions/docker-build@main
      with:
        build-tool: ${{ matrix.service.build-tool }}
        image-name: 'mycompany/${{ matrix.service.name }}'
        image-tag: ${{ github.sha }}
        working-directory: ${{ matrix.service.directory }}
        push: 'true'
        registry-url: 'ghcr.io'
        registry-username: ${{ github.actor }}
        registry-password: ${{ secrets.GITHUB_TOKEN }}
```

### Example 6: Advanced Cache Configuration

```yaml
name: Advanced Docker Build with Cache

on:
  push:
    branches: [main]

jobs:
  docker:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    
    - name: Build with Advanced Cache
      uses: your-org/actions/docker-build@main
      with:
        build-tool: 'maven'
        image-name: 'my-app'
        image-tag: 'latest'
        cache-strategy: 'all'
        cache-from: |
          type=gha
          type=registry,ref=ghcr.io/${{ github.repository }}:cache
        cache-to: |
          type=gha,mode=max
          type=registry,ref=ghcr.io/${{ github.repository }}:cache,mode=max
        build-args: |
          BUILDKIT_INLINE_CACHE=1
          CUSTOM_ARG=value
        registry-url: 'ghcr.io'
        registry-username: ${{ github.actor }}
        registry-password: ${{ secrets.GITHUB_TOKEN }}
        push: 'true'
```

## 🔨 Dockerfile Requirements

Your Dockerfile should be optimized for Spring Boot applications. Here are some examples:

### Maven Dockerfile Example

```dockerfile
# Multi-stage build for Maven
FROM eclipse-temurin:21-jdk-alpine AS builder

WORKDIR /app
COPY pom.xml .
COPY src ./src

RUN ./mvnw clean package -DskipTests

FROM eclipse-temurin:21-jre-alpine

WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

### Gradle Dockerfile Example

```dockerfile
# Multi-stage build for Gradle
FROM eclipse-temurin:21-jdk-alpine AS builder

WORKDIR /app
COPY gradle gradle
COPY gradlew .
COPY build.gradle .
COPY settings.gradle .
COPY src ./src

RUN ./gradlew clean build -x test

FROM eclipse-temurin:21-jre-alpine

WORKDIR /app
COPY --from=builder /app/build/libs/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

## 🛠️ Advanced Configuration

### Cache Strategy Options

The action supports different cache strategies to optimize build performance:

- `all`: Cache both Docker layers and build artifacts (default)
- `docker-cache`: Cache only Docker build layers
- `build-cache`: Cache only Maven/Gradle build artifacts
- `none`: Disable all caching

```yaml
- name: Build with specific cache strategy
  uses: your-org/actions/docker-build@main
  with:
    build-tool: 'maven'
    image-name: 'my-app'
    cache-strategy: 'docker-cache'  # Only cache Docker layers
```

### Custom Build Arguments

```yaml
- name: Build with Custom Args
  uses: your-org/actions/docker-build@main
  with:
    build-tool: 'maven'
    image-name: 'my-app'
    build-args: |
      JAVA_OPTS=-Xmx2g -XX:+UseG1GC
      APP_VERSION=${{ github.sha }}
      BUILD_DATE=${{ github.event.head_commit.timestamp }}
      SPRING_PROFILES_ACTIVE=prod,docker
```

### Registry Cache Optimization

```yaml
- name: Build with Registry Cache
  uses: your-org/actions/docker-build@main
  with:
    build-tool: 'gradle'
    image-name: 'my-app'
    cache-from: 'type=registry,ref=ghcr.io/user/my-app:cache'
    cache-to: 'type=registry,ref=ghcr.io/user/my-app:cache,mode=max'
```

## 🔍 Troubleshooting

### Common Issues

1. **Build Tool Not Detected**
   - Ensure `build-tool` input is exactly `maven` or `gradle`
   - Verify the project structure matches the build tool

2. **Dockerfile Not Found**
   - Check the `dockerfile` and `working-directory` inputs
   - Ensure the Dockerfile exists in the specified location
   - Path should be relative to the working directory

3. **Registry Push Failures**
   - Verify `registry-username` and `registry-password` are correct
   - Ensure the registry URL is properly formatted
   - Check registry permissions and authentication

4. **Java Version Issues**
   - Ensure Java version is 8 or higher
   - Verify the distribution supports the requested version
   - Valid values: 8, 11, 17, 21, etc.

5. **Cache Strategy Issues**
   - Valid cache strategies: `docker-cache`, `build-cache`, `all`, `none`
   - Check cache permissions if using registry cache
   - Verify cache paths are accessible

6. **Image Name Validation**
   - Image names must be lowercase alphanumeric
   - Can include hyphens, underscores, dots, and forward slashes
   - Must not start or end with special characters

### Debug Mode

Add this step before the action to enable debug logging:

```yaml
- name: Enable Debug
  run: echo "ACTIONS_STEP_DEBUG=true" >> $GITHUB_ENV
```

### Checking Outputs

You can use the action outputs to debug issues:

```yaml
- name: Build Docker Image
  id: docker-build
  uses: your-org/actions/docker-build@main
  with:
    build-tool: 'maven'
    image-name: 'my-app'

- name: Debug Outputs
  run: |
    echo "Build tool: ${{ steps.docker-build.outputs.build-tool }}"
    echo "Cache hit: ${{ steps.docker-build.outputs.cache-hit }}"
    echo "Image digest: ${{ steps.docker-build.outputs.image-digest }}"
    echo "Full image name: ${{ steps.docker-build.outputs.image-full-name }}"
    echo "Java version: ${{ steps.docker-build.outputs.java-version }}"
```

## 🤝 Contributing

This action follows the project's standard conventions. See [ACTION_STANDARD.md](../ACTION_STANDARD.md) for development guidelines.

## 📄 License

This project is licensed under the MIT License. 
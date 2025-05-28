# Spring Boot Test Suite Action

A comprehensive GitHub Action for running tests in Spring Boot applications with support for code coverage, dependency caching, and detailed reporting.

**🔄 This action now integrates with both `setup-java-gradle-env` and `setup-java-maven-env` to provide optimized build environments for both build tools.**

## Features

- ✅ Support for Maven and Gradle
- ✅ **Integrated with `setup-java-gradle-env` for optimized Gradle builds**
- ✅ **Integrated with `setup-java-maven-env` for optimized Maven builds**
- ✅ Automatic Java setup (Java 8-21)
- ✅ Intelligent dependency caching with enhanced strategies
- ✅ Code coverage reports (JaCoCo)
- ✅ Parallel test execution
- ✅ Integration tests
- ✅ GitHub checks publication
- ✅ Coverage threshold validation
- ✅ Spring Profiles support
- ✅ Customizable test commands
- ✅ **Advanced JVM tuning for better performance**
- ✅ **Unified build environment setup**

## Basic Usage

```yaml
name: Test

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Run Spring Boot Tests
        uses: ./actions/spring-boot-test-suite
        with:
          java-version: '21'
          build-tool: 'gradle'  # or 'maven'
```

## Advanced Configuration

### Gradle Project

```yaml
name: Comprehensive Testing - Gradle

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Run Spring Boot Test Suite
        id: tests
        uses: ./actions/spring-boot-test-suite
        with:
          java-version: '21'
          java-distribution: 'temurin'
          build-tool: 'gradle'
          coverage-enabled: 'true'
          coverage-threshold: '85'
          fail-on-coverage-threshold: 'true'
          spring-profiles: 'test,integration'
          parallel-tests: 'true'
          integration-tests: 'true'
          working-directory: './my-service'
          # Advanced Gradle configuration
          gradle-args: '--no-daemon --parallel --build-cache'
          jvm-args: '-Xmx4g -XX:+UseG1GC -XX:MaxGCPauseMillis=200'
      
      - name: Use test outputs
        run: |
          echo "Test result: ${{ steps.tests.outputs.test-result }}"
          echo "Coverage: ${{ steps.tests.outputs.coverage-percentage }}%"
          echo "Tests executed: ${{ steps.tests.outputs.test-count }}"
          echo "Failed tests: ${{ steps.tests.outputs.failed-test-count }}"
          echo "Cache hit: ${{ steps.tests.outputs.cache-hit }}"
          echo "Build tool version: ${{ steps.tests.outputs.build-tool-version }}"
```

### Maven Project

```yaml
name: Comprehensive Testing - Maven

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Run Spring Boot Test Suite
        id: tests
        uses: ./actions/spring-boot-test-suite
        with:
          java-version: '21'
          java-distribution: 'temurin'
          build-tool: 'maven'
          coverage-enabled: 'true'
          coverage-threshold: '85'
          fail-on-coverage-threshold: 'true'
          spring-profiles: 'test,integration'
          parallel-tests: 'true'
          integration-tests: 'true'
          working-directory: './my-service'
          # Advanced Maven configuration
          maven-args: '-T 2C --no-transfer-progress --batch-mode'
          maven-repositories: |
            [
              "https://repo.spring.io/milestone"
            ]
```

## Inputs

### Standard Build Inputs

| Input | Description | Required | Default Value |
|-------|-------------|----------|---------------|
| `java-version` | Java version to use (8, 11, 17, 21) | No | `'21'` |
| `java-distribution` | Java distribution (temurin, corretto, microsoft, oracle) | No | `'temurin'` |
| `build-tool` | Build tool (`maven` or `gradle`) | No | `'gradle'` |
| `cache-enabled` | Enable dependency caching | No | `'true'` |
| `working-directory` | Working directory for the project | No | `'.'` |
| `spring-profiles` | Spring profiles to activate during tests | No | `'test'` |

### Advanced Build Tool Inputs

#### Gradle-Specific *(Inherited from setup-java-gradle-env)*

| Input | Description | Required | Default Value |
|-------|-------------|----------|---------------|
| `gradle-args` | Additional Gradle arguments | No | `'--no-daemon --parallel'` |
| `jvm-args` | Additional JVM arguments for Gradle | No | `'-Xmx4g -XX:+UseG1GC -XX:MaxGCPauseMillis=200'` |

#### Maven-Specific *(Inherited from setup-java-maven-env)*

| Input | Description | Required | Default Value |
|-------|-------------|----------|---------------|
| `maven-args` | Additional Maven arguments | No | `'-T 1C --no-transfer-progress'` |
| `maven-repositories` | Additional Maven repositories (JSON array format) | No | `'[]'` |

### Test-Specific Inputs

| Input | Description | Required | Default Value |
|-------|-------------|----------|---------------|
| `test-command` | Custom command to run tests | No | `''` |
| `coverage-enabled` | Enable coverage reports | No | `'true'` |
| `coverage-format` | Coverage report format (`jacoco`, `cobertura`) | No | `'jacoco'` |
| `fail-on-coverage-threshold` | Fail if coverage is below threshold | No | `'false'` |
| `coverage-threshold` | Minimum coverage percentage required | No | `'80'` |
| `parallel-tests` | Enable parallel test execution | No | `'true'` |
| `integration-tests` | Run integration tests | No | `'true'` |
| `publish-test-results` | Publish test results as GitHub check | No | `'true'` |

## Outputs

### Primary Outputs

| Output | Description |
|--------|-------------|
| `test-result` | Test execution result (`success`/`failure`) |
| `coverage-percentage` | Code coverage percentage |
| `test-count` | Total number of tests executed |
| `failed-test-count` | Number of failed tests |

### Build Environment Outputs *(From setup actions)*

| Output | Description |
|--------|-------------|
| `cache-hit` | Indicates if build cache was found |
| `build-tool-version` | Installed build tool version (Gradle or Maven) |

## Usage Examples

### High-Performance Gradle Testing

```yaml
- name: High-Performance Gradle Tests
  uses: ./actions/spring-boot-test-suite
  with:
    build-tool: 'gradle'
    java-version: '21'
    gradle-args: '--no-daemon --parallel --build-cache --configuration-cache'
    jvm-args: '-Xmx6g -XX:+UseG1GC -XX:MaxGCPauseMillis=100'
    parallel-tests: 'true'
```

### High-Performance Maven Testing

```yaml
- name: High-Performance Maven Tests
  uses: ./actions/spring-boot-test-suite
  with:
    build-tool: 'maven'
    java-version: '21'
    maven-args: '-T 4C --no-transfer-progress --batch-mode'
    parallel-tests: 'true'
```

### Maven with Custom Repositories

```yaml
- name: Maven Tests with Custom Repos
  uses: ./actions/spring-boot-test-suite
  with:
    build-tool: 'maven'
    maven-repositories: |
      [
        "https://nexus.company.com/repository/maven-public/",
        "https://repo.spring.io/milestone"
      ]
```

### Gradle Project with Strict Coverage

```yaml
- name: Test with Coverage Requirements
  uses: ./actions/spring-boot-test-suite
  with:
    build-tool: 'gradle'
    coverage-enabled: 'true'
    coverage-threshold: '90'
    fail-on-coverage-threshold: 'true'
    gradle-args: '--no-daemon --parallel'
```

### Multiple Services in Monorepo

```yaml
strategy:
  matrix:
    service: 
      - { name: user-service, tool: gradle }
      - { name: order-service, tool: maven }
      - { name: payment-service, tool: gradle }

steps:
  - uses: actions/checkout@v4
  
  - name: Test ${{ matrix.service.name }}
    uses: ./actions/spring-boot-test-suite
    with:
      working-directory: './${{ matrix.service.name }}'
      build-tool: ${{ matrix.service.tool }}
      spring-profiles: 'test,docker'
      gradle-args: '--no-daemon --parallel --max-workers=4'
      maven-args: '-T 2C --no-transfer-progress'
```

### Custom Test Command

```yaml
- name: Custom Test Command
  uses: ./actions/spring-boot-test-suite
  with:
    test-command: './gradlew clean test jacocoTestReport --info'
```

### Unit Tests Only (No Integration)

```yaml
- name: Unit Tests Only
  uses: ./actions/spring-boot-test-suite
  with:
    integration-tests: 'false'
    parallel-tests: 'true'
```

## Architecture & Integration

This action is designed with a **modular architecture** that automatically chooses the appropriate setup action based on the build tool:

### For Gradle Projects
- **Uses `setup-java-gradle-env`** for environment setup, caching, and Gradle configuration
- Inherits all optimization features from the base action
- Supports advanced Gradle features like build cache and configuration cache

### For Maven Projects  
- **Uses `setup-java-maven-env`** for environment setup, caching, and Maven configuration
- Inherits Maven-specific optimizations and repository management
- Supports parallel builds and custom repository configuration

### Unified Testing Layer
- **Consistent test execution** regardless of build tool
- **Unified coverage reporting** with JaCoCo integration
- **Common output format** for both Maven and Gradle

### Benefits of Integration
- ✅ **No duplication** of Java/build tool setup code
- ✅ **Enhanced caching strategies** for both Maven and Gradle
- ✅ **Consistent build environment** across different projects
- ✅ **Advanced performance tuning** for both build tools
- ✅ **Automatic optimization** based on build tool choice
- ✅ **Unified interface** with build-tool-specific optimizations

## Project Configuration

### For Gradle

Make sure you have the JaCoCo plugin configured in your `build.gradle`:

```gradle
plugins {
    id 'jacoco'
}

jacoco {
    toolVersion = "0.8.11"
}

jacocoTestReport {
    reports {
        xml.required = true
        html.required = true
    }
}

test {
    useJUnitPlatform()
    finalizedBy jacocoTestReport
}

// For integration tests (optional)
task integrationTest(type: Test) {
    testClassesDirs = sourceSets.integrationTest.output.classesDirs
    classpath = sourceSets.integrationTest.runtimeClasspath
    shouldRunAfter test
}
```

### For Maven

Configure the JaCoCo plugin in your `pom.xml`:

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.jacoco</groupId>
            <artifactId>jacoco-maven-plugin</artifactId>
            <version>0.8.11</version>
            <executions>
                <execution>
                    <goals>
                        <goal>prepare-agent</goal>
                    </goals>
                </execution>
                <execution>
                    <id>report</id>
                    <phase>test</phase>
                    <goals>
                        <goal>report</goal>
                    </goals>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>

<profiles>
    <profile>
        <id>coverage</id>
        <build>
            <plugins>
                <plugin>
                    <groupId>org.jacoco</groupId>
                    <artifactId>jacoco-maven-plugin</artifactId>
                    <executions>
                        <execution>
                            <id>report</id>
                            <goals>
                                <goal>report</goal>
                            </goals>
                        </execution>
                    </executions>
                </plugin>
            </plugins>
        </build>
    </profile>
</profiles>
```

## Spring Profiles for Testing

The action automatically configures `SPRING_PROFILES_ACTIVE` with the value from the `spring-profiles` input. This is useful for:

- Configuring in-memory databases for tests
- Enabling/disabling specific features
- Setting up different service providers

Example `application-test.yml`:

```yaml
spring:
  datasource:
    url: jdbc:h2:mem:testdb
    driver-class-name: org.h2.Driver
  jpa:
    hibernate:
      ddl-auto: create-drop
    show-sql: true

logging:
  level:
    com.xeppelin: DEBUG
```

## Performance Optimizations

### Gradle Optimizations
- **Build Cache**: Enabled with `--build-cache`
- **Configuration Cache**: Support for `--configuration-cache`
- **Parallel Execution**: Multi-threaded builds
- **JVM Tuning**: Optimized heap and GC settings

### Maven Optimizations
- **Parallel Builds**: `-T` flag for multi-threading
- **Dependency Pre-download**: Automatic `dependency:go-offline`
- **Transfer Progress**: Disabled for cleaner logs
- **Build Cache**: Maven build artifact caching

## Best Practices

### Build Tool Selection
1. **Gradle**: Better for complex builds, microservices, and performance
2. **Maven**: Better for enterprise environments and standardization
3. **Consistency**: Use the same tool across your organization

### Performance
1. **Java 21**: Use latest LTS for better performance
2. **Parallel Tests**: Enable for large test suites
3. **Caching**: Always enable for CI/CD pipelines
4. **Resource Allocation**: Tune JVM/Maven settings based on project size

### Reliability
1. **Pin Versions**: Use specific Java and build tool versions
2. **Use Wrappers**: Prefer `gradlew`/`mvnw` over system tools
3. **Set Profiles**: Use dedicated profiles for testing
4. **Monitor Coverage**: Set appropriate thresholds

## Troubleshooting

### Build Tool Detection Issues

The action automatically detects the build tool, but you can force it:

```yaml
- name: Force Build Tool
  uses: ./actions/spring-boot-test-suite
  with:
    build-tool: 'maven'  # or 'gradle'
```

### Memory Issues

For large projects:

```yaml
# Gradle
- name: High Memory Gradle
  uses: ./actions/spring-boot-test-suite
  with:
    build-tool: 'gradle'
    jvm-args: '-Xmx8g -XX:MaxMetaspaceSize=1g'

# Maven  
- name: High Memory Maven
  uses: ./actions/spring-boot-test-suite
  with:
    build-tool: 'maven'
    maven-args: '-T 1C -Xmx6g'
```

### Cache Issues

Debug caching problems:

```yaml
- name: Debug Cache
  uses: ./actions/spring-boot-test-suite
  with:
    cache-enabled: 'false'  # Temporarily disable
```

This action provides a unified interface for testing Spring Boot applications regardless of the build tool, with optimized performance and comprehensive feature set.

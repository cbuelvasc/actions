# Spring Boot Test Suite Action

A comprehensive GitHub Action for running tests in Spring Boot applications with support for code coverage, dependency caching, and detailed reporting.

## Features

- ✅ Support for Maven and Gradle
- ✅ Automatic Java setup (Java 8-21)
- ✅ Intelligent dependency caching
- ✅ Code coverage reports (JaCoCo)
- ✅ Parallel test execution
- ✅ Integration tests
- ✅ GitHub checks publication
- ✅ Coverage threshold validation
- ✅ Spring Profiles support
- ✅ Customizable test commands

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
          build-tool: 'gradle'
```

## Advanced Configuration

```yaml
name: Comprehensive Testing

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
      
      - name: Use test outputs
        run: |
          echo "Test result: ${{ steps.tests.outputs.test-result }}"
          echo "Coverage: ${{ steps.tests.outputs.coverage-percentage }}%"
          echo "Tests executed: ${{ steps.tests.outputs.test-count }}"
          echo "Failed tests: ${{ steps.tests.outputs.failed-test-count }}"
```

## Inputs

| Input | Description | Required | Default Value |
|-------|-------------|----------|---------------|
| `java-version` | Java version to use (8, 11, 17, 21) | No | `'21'` |
| `java-distribution` | Java distribution (temurin, adopt, etc.) | No | `'temurin'` |
| `build-tool` | Build tool (`maven` or `gradle`) | No | `'gradle'` |
| `test-command` | Custom command to run tests | No | `''` |
| `coverage-enabled` | Enable coverage reports | No | `'true'` |
| `coverage-format` | Coverage report format (`jacoco`, `cobertura`) | No | `'jacoco'` |
| `fail-on-coverage-threshold` | Fail if coverage is below threshold | No | `'false'` |
| `coverage-threshold` | Minimum coverage percentage required | No | `'80'` |
| `cache-enabled` | Enable dependency caching | No | `'true'` |
| `working-directory` | Working directory for the project | No | `'.'` |
| `spring-profiles` | Spring profiles to activate during tests | No | `'test'` |
| `parallel-tests` | Enable parallel test execution | No | `'true'` |
| `integration-tests` | Run integration tests | No | `'true'` |
| `publish-test-results` | Publish test results as GitHub check | No | `'true'` |

## Outputs

| Output | Description |
|--------|-------------|
| `test-result` | Test execution result (`success`/`failure`) |
| `coverage-percentage` | Code coverage percentage |
| `test-count` | Total number of tests executed |
| `failed-test-count` | Number of failed tests |

## Usage Examples

### Simple Maven Project

```yaml
- name: Test Maven Project
  uses: ./actions/spring-boot-test-suite
  with:
    build-tool: 'maven'
    java-version: '17'
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
```

### Multiple Services in Monorepo

```yaml
strategy:
  matrix:
    service: [user-service, order-service, payment-service]

steps:
  - uses: actions/checkout@v4
  
  - name: Test ${{ matrix.service }}
    uses: ./actions/spring-boot-test-suite
    with:
      working-directory: './${{ matrix.service }}'
      spring-profiles: 'test,docker'
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

## Dependency Caching

The action uses intelligent caching that:

- Caches Maven dependencies in `~/.m2/repository`
- Caches Gradle dependencies in `~/.gradle/caches` and `~/.gradle/wrapper`
- Uses configuration file hashes as cache keys
- Significantly reduces build times

## Reports and Artifacts

The action generates and stores:

- **Coverage reports**: Uploaded as GitHub artifacts
- **Test results**: Published as GitHub checks
- **Detailed logs**: Include execution information

## Best Practices

1. **Java Version**: Use Java 21 for better performance
2. **Parallel Tests**: Enable for large projects
3. **Coverage Thresholds**: Set realistic goals (80-90%)
4. **Dedicated Profiles**: Use dedicated profiles for testing
5. **Caching**: Always enabled for better performance
6. **Monitoring**: Use outputs to create metrics

## Troubleshooting

### Tests Fail Unexpectedly

```yaml
- name: Debug Test Failures
  uses: ./actions/spring-boot-test-suite
  with:
    test-command: './gradlew test --info --stacktrace'
    publish-test-results: 'true'
```

### Memory Issues

```yaml
- name: Tests with More Memory
  uses: ./actions/spring-boot-test-suite
  with:
    test-command: './gradlew test -Xmx2g'
```

### Coverage Not Generated

Verify that:
- The JaCoCo plugin is properly configured
- Tests run before the report
- XML coverage files are generated in the expected location

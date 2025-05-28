# Test Runner Action

A comprehensive GitHub Action that executes tests with coverage reporting for Spring Boot applications, supporting both Maven and Gradle build tools.

## Description

This action provides a unified test execution framework for Java/Spring Boot projects with advanced features including parallel execution, integration testing, code coverage analysis, and automated result publishing. It automatically detects the build tool configuration and executes appropriate test commands with comprehensive reporting.

## Features

- ✅ **Multi-build tool support**: Maven and Gradle
- ✅ **Parallel test execution**: Configurable parallel processing
- ✅ **Integration testing**: Separate integration test execution
- ✅ **Code coverage**: JaCoCo and Cobertura support with threshold validation
- ✅ **Test result publishing**: Automatic GitHub check integration
- ✅ **Artifact generation**: Coverage reports and test results
- ✅ **Custom commands**: Override default test execution
- ✅ **Comprehensive validation**: Input validation with clear error messages

## Usage

### Basic Usage

```yaml
- name: Run Tests
  uses: ./actions/test-runner
  with:
    build-tool: 'maven'
```

### Complete Configuration

```yaml
- name: Run Tests with Coverage
  uses: ./actions/test-runner
  with:
    build-tool: 'gradle'
    working-directory: './my-service'
    integration-tests: 'true'
    parallel-tests: 'true'
    coverage-enabled: 'true'
    coverage-threshold: '85'
    fail-on-coverage-threshold: 'true'
    publish-test-results: 'true'
    gradle-args: '--no-daemon --parallel --build-cache'
```

### Custom Test Command

```yaml
- name: Run Custom Tests
  uses: ./actions/test-runner
  with:
    build-tool: 'maven'
    test-command: 'mvn clean test -Dspring.profiles.active=ci'
```

## Inputs

### Required Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `build-tool` | Build tool to use (`maven` or `gradle`) | ✅ | - |

### Optional Inputs

#### General Configuration
| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `working-directory` | Working directory for the project | ❌ | `.` |

#### Test Execution
| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `integration-tests` | Run integration tests | ❌ | `true` |
| `parallel-tests` | Enable parallel test execution | ❌ | `true` |
| `test-command` | Custom test command (overrides default execution) | ❌ | `''` |

#### Coverage Configuration
| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `coverage-enabled` | Enable code coverage reporting | ❌ | `true` |
| `coverage-format` | Coverage report format (`jacoco`, `cobertura`) | ❌ | `jacoco` |
| `coverage-threshold` | Minimum coverage percentage required (0-100) | ❌ | `80` |
| `fail-on-coverage-threshold` | Fail if coverage is below threshold | ❌ | `false` |

#### Reporting
| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `publish-test-results` | Publish test results as GitHub check | ❌ | `true` |

#### Build Tool Specific
| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `gradle-args` | Additional Gradle arguments | ❌ | `--no-daemon --parallel` |
| `maven-args` | Additional Maven arguments | ❌ | `-T 1C --no-transfer-progress` |

### Input Validation

The action validates all critical inputs:
- **build-tool**: Must be either `maven` or `gradle`
- **coverage-format**: Must be either `jacoco` or `cobertura`
- **coverage-threshold**: Must be a number between 0 and 100

## Outputs

| Output | Description |
|--------|-------------|
| `test-result` | Test execution result (`success`/`failure`) |
| `coverage-percentage` | Code coverage percentage |
| `test-count` | Number of tests executed |
| `failed-test-count` | Number of failed tests |

## Build Tool Support

### Maven Configuration

The action supports Maven projects with the following features:
- Automatic detection of Maven wrapper (`mvnw`)
- Support for coverage profiles (`-Pcoverage`)
- Integration test execution via `integration-test` goal
- Parallel execution with `-T 1C`

**Example Maven execution:**
```bash
./mvnw clean test integration-test -Pcoverage -T 1C --no-transfer-progress
```

### Gradle Configuration

The action supports Gradle projects with the following features:
- Automatic detection of Gradle wrapper (`gradlew`)
- Integration test task execution
- JaCoCo report generation
- Parallel execution with `--parallel`

**Example Gradle execution:**
```bash
./gradlew clean test integrationTest jacocoTestReport --no-daemon --parallel
```

## Coverage Reporting

### Supported Formats
- **JaCoCo**: Default format with XML report generation
- **Cobertura**: Alternative coverage format

### Coverage Paths
- **Maven**: `target/site/jacoco/jacoco.xml`
- **Gradle**: `build/reports/jacoco/test/jacocoTestReport.xml`

### Threshold Validation
When `fail-on-coverage-threshold` is enabled, the action will fail if coverage falls below the specified threshold.

## Artifacts and Reports

### Test Results
- Publishes test results as GitHub checks using `EnricoMi/publish-unit-test-result-action@v2`
- Supports both Maven and Gradle test result formats

### Coverage Reports
- Uploads coverage reports as artifacts with 7-day retention
- Includes both HTML and XML reports for analysis

## Examples

### Spring Boot with Maven
```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Java
        uses: actions/setup-java@v4
        with:
          distribution: 'temurin'
          java-version: '21'
          
      - name: Run Tests
        uses: ./actions/test-runner
        with:
          build-tool: 'maven'
          coverage-threshold: '90'
          fail-on-coverage-threshold: 'true'
```

### Microservice with Gradle
```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        service: [user-service, order-service, payment-service]
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Java
        uses: actions/setup-java@v4
        with:
          distribution: 'temurin'
          java-version: '21'
          
      - name: Test ${{ matrix.service }}
        uses: ./actions/test-runner
        with:
          build-tool: 'gradle'
          working-directory: './${{ matrix.service }}'
          integration-tests: 'false'
          gradle-args: '--no-daemon --parallel --build-cache'
```

### Custom Test Profile
```yaml
- name: Run CI Tests
  uses: ./actions/test-runner
  with:
    build-tool: 'maven'
    test-command: 'mvn clean test -Dspring.profiles.active=ci -Dmaven.test.failure.ignore=false'
    coverage-enabled: 'false'
    publish-test-results: 'true'
```

## Requirements

- Java project with Maven or Gradle
- Test framework configured (JUnit, TestNG, etc.)
- Coverage plugin configured (JaCoCo recommended)

## Dependencies

This action uses the following GitHub Actions:
- `EnricoMi/publish-unit-test-result-action@v2` - Test result publishing
- `actions/upload-artifact@v4` - Artifact uploading

## Best Practices

1. **Enable parallel execution** for faster test execution
2. **Set appropriate coverage thresholds** based on project requirements
3. **Use integration tests** for comprehensive testing
4. **Configure build tool specific arguments** for optimization
5. **Monitor test artifacts** for debugging failed tests

## Troubleshooting

### Common Issues

1. **Build tool not found**: Ensure Maven or Gradle is properly configured
2. **Coverage reports missing**: Verify coverage plugin configuration
3. **Test failures**: Check test-specific outputs and artifacts
4. **Permission errors**: Ensure wrapper scripts have execute permissions

### Debug Mode

Enable debug logging by setting:
```yaml
env:
  ACTIONS_STEP_DEBUG: true
```

## Author

Carmelo Buelvas Comas 
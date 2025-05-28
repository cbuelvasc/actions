# Setup Java Base Environment

[![GitHub](https://img.shields.io/badge/GitHub-Action-blue?logo=github)](https://github.com/marketplace/actions)
[![Java](https://img.shields.io/badge/Java-8%2B-orange?logo=openjdk)](https://openjdk.org/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-Compatible-green?logo=springboot)](https://spring.io/projects/spring-boot)

A comprehensive GitHub Action for setting up Java environments with validation and optimized configuration for Spring Boot applications.

## 🚀 Features

- **Multiple Java Distributions**: Support for Temurin, Corretto, Microsoft, and Oracle distributions
- **Version Validation**: Automatic validation of Java version inputs with clear error messages
- **Spring Profile Configuration**: Built-in Spring profile management for different environments
- **Standardized Outputs**: Consistent output format for integration with other actions
- **Error Handling**: Comprehensive input validation with descriptive error messages

## 📋 Prerequisites

- GitHub Actions workflow environment
- Repository with Java/Spring Boot project

## 🔧 Inputs

| Input | Description | Required | Default | Valid Values |
|-------|-------------|----------|---------|--------------|
| `java-distribution` | Java distribution to use | No | `temurin` | `temurin`, `corretto`, `microsoft`, `oracle` |
| `java-version` | Java version to set up | No | `21` | `8` or higher (numeric) |
| `spring-profiles` | Spring profiles to activate | No | `test` | Any valid profile names (comma-separated) |

### Input Details

#### `java-distribution`
- **Description**: Specifies which Java distribution to install
- **Recommended**: `temurin` (Eclipse Temurin) for most use cases
- **Enterprise**: `corretto` (Amazon Corretto) for AWS environments

#### `java-version`
- **Description**: Major Java version number
- **Validation**: Must be numeric and 8 or higher
- **Examples**: `8`, `11`, `17`, `21`

#### `spring-profiles`
- **Description**: Spring profiles to activate via `SPRING_PROFILES_ACTIVE` environment variable
- **Format**: Comma-separated profile names
- **Examples**: `test`, `dev,local`, `prod,monitoring`

## 📤 Outputs

| Output | Description | Example Value |
|--------|-------------|---------------|
| `java-home` | Java installation path | `/opt/hostedtoolcache/Java_Temurin-Hotspot_jdk/21.0.1+12/x64` |
| `java-version` | Installed Java version | `21.0.1+12` |

## 🎯 Usage Examples

### Basic Usage

```yaml
steps:
  - name: Checkout code
    uses: actions/checkout@v4
    
  - name: Setup Java environment
    uses: ./actions/setup-java-base
```

### Custom Java Version

```yaml
steps:
  - name: Setup Java 17
    uses: ./actions/setup-java-base
    with:
      java-version: '17'
      java-distribution: 'temurin'
```

### Production Environment

```yaml
steps:
  - name: Setup production Java environment
    uses: ./actions/setup-java-base
    with:
      java-version: '21'
      java-distribution: 'corretto'
      spring-profiles: 'prod,monitoring'
```

### Multiple Profiles

```yaml
steps:
  - name: Setup development environment
    uses: ./actions/setup-java-base
    with:
      java-version: '21'
      spring-profiles: 'dev,local,debug'
```

### Using Outputs

```yaml
steps:
  - name: Setup Java
    id: java-setup
    uses: ./actions/setup-java-base
    with:
      java-version: '21'
      
  - name: Display Java information
    run: |
      echo "Java Home: ${{ steps.java-setup.outputs.java-home }}"
      echo "Java Version: ${{ steps.java-setup.outputs.java-version }}"
      echo "Active Profiles: $SPRING_PROFILES_ACTIVE"
```

## 🔄 Integration Examples

### With Maven Build

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Java
        uses: ./actions/setup-java-base
        with:
          java-version: '21'
          spring-profiles: 'test'
          
      - name: Build with Maven
        run: ./mvnw clean compile
```

### With Gradle Build

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Java
        uses: ./actions/setup-java-base
        with:
          java-version: '17'
          java-distribution: 'temurin'
          spring-profiles: 'test,integration'
          
      - name: Run tests
        run: ./gradlew test
```

### Matrix Strategy

```yaml
jobs:
  test-matrix:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        java-version: ['17', '21']
        distribution: ['temurin', 'corretto']
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Java ${{ matrix.java-version }} (${{ matrix.distribution }})
        uses: ./actions/setup-java-base
        with:
          java-version: ${{ matrix.java-version }}
          java-distribution: ${{ matrix.distribution }}
          spring-profiles: 'test'
```

## 🛠️ Use Cases

### Development Environment Setup
- Local development environment replication
- Consistent Java version across team members
- Spring profile configuration for development features

### Continuous Integration
- Automated testing with specific Java versions
- Multi-distribution compatibility testing
- Environment-specific profile activation

### Deployment Preparation
- Production environment Java setup
- Performance profile activation
- Security profile configuration

## ⚡ Performance Tips

1. **Use specific Java versions** to ensure consistent builds
2. **Leverage distribution defaults** for faster setup
3. **Combine with caching actions** for dependency management
4. **Use minimal profile sets** to reduce startup time

## 🐛 Troubleshooting

### Common Issues

#### Invalid Java Version
```
❌ Error: java-version must be a valid Java version (8 or higher)
   Provided: 'latest'
```
**Solution**: Use numeric versions like `17`, `21`

#### Unsupported Distribution
```
❌ Error: distribution 'custom' is not supported
```
**Solution**: Use supported distributions: `temurin`, `corretto`, `microsoft`, `oracle`

#### Profile Configuration Issues
- Ensure Spring profiles are valid identifiers
- Use comma separation for multiple profiles
- Avoid spaces in profile names

## 📊 Compatibility

| Component | Version | Status |
|-----------|---------|---------|
| GitHub Actions | Latest | ✅ Supported |
| Java | 8+ | ✅ Supported |
| Spring Boot | 2.x, 3.x | ✅ Supported |
| Maven | 3.6+ | ✅ Compatible |
| Gradle | 7.0+ | ✅ Compatible |

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Follow the [ACTION_STANDARD.md](../ACTION_STANDARD.md) guidelines
4. Add tests for new functionality
5. Submit a pull request

## 📝 License

This action is available under the [MIT License](LICENSE).

## 🔗 Related Actions

- [setup-java-maven-env](../setup-java-maven-env/README.md) - Maven-specific Java setup
- [setup-java-gradle-env](../setup-java-gradle-env/README.md) - Gradle-specific Java setup
- [spring-boot-test-suite](../spring-boot-test-suite/README.md) - Spring Boot testing automation

---

**Author**: Carmelo Buelvas Comas  
**Maintainer**: GitHub Actions Team 
# Workflows Reutilizables para Servicios Spring Boot

Esta guía documenta los workflows reutilizables disponibles para automatizar el CI/CD de servicios Spring Boot.

## 📋 Workflows Disponibles

| Workflow | Descripción | Casos de Uso |
|----------|-------------|-------------|
| [build-and-test.yml](#build-and-test) | Build y testing completo con cobertura | Integración continua básica |
| [docker-build-deploy.yml](#docker-build-deploy) | Build y deployment de imágenes Docker | Containerización y despliegue |
| [ci-cd-pipeline.yml](#ci-cd-pipeline) | Pipeline completo CI/CD | Automatización completa |

## 🚀 Workflow: Build and Test

### Descripción
Workflow reutilizable para construir y probar servicios Spring Boot con soporte para Maven y Gradle.

### Características
- ✅ Soporte para Maven y Gradle
- ✅ Configuración automática de Java 17/21
- ✅ Cache inteligente de dependencias
- ✅ Cobertura de código configurable
- ✅ Informes detallados de testing
- ✅ Extracción automática de metadatos del proyecto

### Uso Básico

```yaml
# .github/workflows/ci.yml
name: CI Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  build-test:
    uses: cbuelvasc/actions/.github/workflows/build-and-test.yml@v1
    with:
      build-tool: 'maven'  # o 'gradle'
      service-name: 'order-service'
      java-version: '21'
      coverage-threshold: '80'
```

### Configuración Avanzada

```yaml
jobs:
  build-test:
    uses: cbuelvasc/actions/.github/workflows/build-and-test.yml@v1
    with:
      # Configuración de Build
      build-tool: 'gradle'
      java-version: '21'
      java-distribution: 'temurin'
      
      # Configuración del Servicio
      service-name: 'user-service'
      working-directory: './user-service'
      
      # Configuración de Testing
      spring-profiles: 'test,integration'
      coverage-enabled: true
      coverage-threshold: '85'
      
      # Configuración de Cache
      cache-enabled: true
      
      # Argumentos adicionales
      gradle-args: '--no-daemon --parallel --continue'
```

### Parámetros de Entrada

| Parámetro | Requerido | Default | Descripción |
|-----------|-----------|---------|-------------|
| `build-tool` | ✅ | - | Herramienta de build (`maven` o `gradle`) |
| `service-name` | ✅ | - | Nombre del servicio |
| `java-version` | ❌ | `'21'` | Versión de Java a usar |
| `java-distribution` | ❌ | `'temurin'` | Distribución de Java |
| `working-directory` | ❌ | `'.'` | Directorio de trabajo |
| `spring-profiles` | ❌ | `'test'` | Perfiles de Spring a activar |
| `coverage-enabled` | ❌ | `true` | Habilitar cobertura de código |
| `coverage-threshold` | ❌ | `'80'` | Umbral mínimo de cobertura |
| `cache-enabled` | ❌ | `true` | Habilitar cache de dependencias |
| `maven-args` | ❌ | `'-T 1C --no-transfer-progress'` | Argumentos adicionales para Maven |
| `gradle-args` | ❌ | `'--no-daemon --parallel'` | Argumentos adicionales para Gradle |

### Outputs

| Output | Descripción |
|--------|-------------|
| `build-status` | Estado del build (`success`/`failure`) |
| `test-status` | Estado de los tests (`success`/`failure`) |
| `coverage-percentage` | Porcentaje de cobertura alcanzado |
| `artifact-name` | Nombre del artefacto generado |
| `artifact-version` | Versión del artefacto |

## 🐳 Workflow: Docker Build Deploy

### Descripción
Workflow reutilizable para construir y desplegar imágenes Docker de servicios Spring Boot.

### Características
- ✅ Build automático de aplicaciones Spring Boot
- ✅ Construcción de imágenes Docker optimizadas
- ✅ Soporte para múltiples registries
- ✅ Push condicional a registry
- ✅ Cache de layers Docker
- ✅ Información detallada de la imagen

### Uso Básico

```yaml
# .github/workflows/docker.yml
name: Docker Build

on:
  push:
    tags: ['v*']

jobs:
  docker-build:
    uses: cbuelvasc/actions/.github/workflows/docker-build-deploy.yml@v1
    with:
      build-tool: 'maven'
      service-name: 'order-service'
      image-name: 'my-org/order-service'
      image-tag: ${{ github.ref_name }}
      push-enabled: true
    secrets:
      registry-username: ${{ secrets.DOCKER_USERNAME }}
      registry-password: ${{ secrets.DOCKER_PASSWORD }}
```

### Configuración Avanzada

```yaml
jobs:
  docker-build:
    uses: cbuelvasc/actions/.github/workflows/docker-build-deploy.yml@v1
    with:
      # Configuración de Build
      build-tool: 'gradle'
      java-version: '21'
      
      # Configuración del Servicio
      service-name: 'payment-service'
      working-directory: './services/payment'
      
      # Configuración Docker
      image-name: 'myregistry.com/payment-service'
      image-tag: 'v1.2.3'
      dockerfile-path: 'docker/Dockerfile'
      
      # Configuración de Registry
      registry-url: 'myregistry.com'
      push-enabled: true
      
      # Cache
      cache-enabled: true
    secrets:
      registry-username: ${{ secrets.CUSTOM_REGISTRY_USER }}
      registry-password: ${{ secrets.CUSTOM_REGISTRY_TOKEN }}
```

### Parámetros de Entrada

| Parámetro | Requerido | Default | Descripción |
|-----------|-----------|---------|-------------|
| `build-tool` | ✅ | - | Herramienta de build (`maven` o `gradle`) |
| `service-name` | ✅ | - | Nombre del servicio |
| `image-name` | ✅ | - | Nombre de la imagen Docker |
| `java-version` | ❌ | `'21'` | Versión de Java |
| `working-directory` | ❌ | `'.'` | Directorio de trabajo |
| `image-tag` | ❌ | `'latest'` | Tag de la imagen |
| `dockerfile-path` | ❌ | `'Dockerfile'` | Ruta al Dockerfile |
| `registry-url` | ❌ | `'docker.io'` | URL del registry |
| `push-enabled` | ❌ | `false` | Habilitar push al registry |
| `cache-enabled` | ❌ | `true` | Habilitar cache |

### Secrets

| Secret | Requerido | Descripción |
|--------|-----------|-------------|
| `registry-username` | ❌ | Usuario del registry Docker |
| `registry-password` | ❌ | Password/token del registry |

### Outputs

| Output | Descripción |
|--------|-------------|
| `build-status` | Estado del build Docker |
| `image-full-name` | Nombre completo de la imagen con tag |
| `image-digest` | Digest SHA de la imagen |

## 🔄 Workflow: CI/CD Pipeline Completo

### Descripción
Pipeline completo que combina build, testing y deployment para automatización end-to-end.

### Características
- ✅ Pipeline secuencial inteligente
- ✅ Build y testing como prerequisito
- ✅ Docker build condicional
- ✅ Resumen ejecutivo del pipeline
- ✅ Comandos de deployment generados automáticamente
- ✅ Soporte para múltiples entornos

### Uso Básico

```yaml
# .github/workflows/pipeline.yml
name: Complete CI/CD Pipeline

on:
  push:
    branches: [main]
  workflow_dispatch:
    inputs:
      environment:
        description: 'Target environment'
        required: true
        default: 'dev'
        type: choice
        options:
        - dev
        - staging
        - prod

jobs:
  pipeline:
    uses: cbuelvasc/actions/.github/workflows/ci-cd-pipeline.yml@v1
    with:
      build-tool: 'maven'
      service-name: 'order-service'
      docker-enabled: true
      image-name: 'my-org/order-service'
      image-tag: ${{ github.sha }}
      push-enabled: ${{ github.ref == 'refs/heads/main' }}
      environment: ${{ inputs.environment || 'dev' }}
    secrets:
      registry-username: ${{ secrets.DOCKER_USERNAME }}
      registry-password: ${{ secrets.DOCKER_PASSWORD }}
```

### Configuración para Múltiples Entornos

```yaml
jobs:
  development:
    if: github.ref == 'refs/heads/develop'
    uses: cbuelvasc/actions/.github/workflows/ci-cd-pipeline.yml@v1
    with:
      build-tool: 'gradle'
      service-name: 'user-service'
      environment: 'dev'
      docker-enabled: true
      image-name: 'dev-registry/user-service'
      image-tag: 'dev-latest'
      push-enabled: true
    secrets:
      registry-username: ${{ secrets.DEV_REGISTRY_USER }}
      registry-password: ${{ secrets.DEV_REGISTRY_TOKEN }}
  
  production:
    if: startsWith(github.ref, 'refs/tags/')
    uses: cbuelvasc/actions/.github/workflows/ci-cd-pipeline.yml@v1
    with:
      build-tool: 'gradle'
      service-name: 'user-service'
      environment: 'prod'
      docker-enabled: true
      image-name: 'prod-registry/user-service'
      image-tag: ${{ github.ref_name }}
      push-enabled: true
      coverage-threshold: '90'  # Mayor cobertura para prod
    secrets:
      registry-username: ${{ secrets.PROD_REGISTRY_USER }}
      registry-password: ${{ secrets.PROD_REGISTRY_TOKEN }}
```

### Parámetros de Entrada

Incluye todos los parámetros de `build-and-test.yml` y `docker-build-deploy.yml`, más:

| Parámetro | Requerido | Default | Descripción |
|-----------|-----------|---------|-------------|
| `docker-enabled` | ❌ | `false` | Habilitar build Docker |
| `environment` | ❌ | `'dev'` | Entorno objetivo |

### Outputs

| Output | Descripción |
|--------|-------------|
| `pipeline-status` | Estado general del pipeline |
| `build-status` | Estado del build y testing |
| `docker-status` | Estado del build Docker |
| `artifact-name` | Nombre del artefacto |
| `artifact-version` | Versión del artefacto |
| `image-full-name` | Imagen Docker completa |

## 💡 Ejemplos Prácticos

### Ejemplo 1: Servicio Simple con Maven

```yaml
# order-service/.github/workflows/ci.yml
name: Order Service CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  ci:
    uses: cbuelvasc/actions/.github/workflows/build-and-test.yml@v1
    with:
      build-tool: 'maven'
      service-name: 'order-service'
      coverage-threshold: '80'
```

### Ejemplo 2: Microservicio con Docker y Deployment

```yaml
# payment-service/.github/workflows/pipeline.yml
name: Payment Service Pipeline

on:
  push:
    branches: [main]
    tags: ['v*']

jobs:
  pipeline:
    uses: cbuelvasc/actions/.github/workflows/ci-cd-pipeline.yml@v1
    with:
      build-tool: 'gradle'
      service-name: 'payment-service'
      working-directory: './services/payment'
      docker-enabled: true
      image-name: 'mycompany/payment-service'
      image-tag: ${{ github.ref_name != 'main' && github.ref_name || 'latest' }}
      push-enabled: true
      environment: ${{ startsWith(github.ref, 'refs/tags/') && 'prod' || 'dev' }}
    secrets:
      registry-username: ${{ secrets.DOCKER_USERNAME }}
      registry-password: ${{ secrets.DOCKER_PASSWORD }}
```

### Ejemplo 3: Pipeline Multi-Servicio

```yaml
# .github/workflows/all-services.yml
name: All Services Pipeline

on:
  push:
    branches: [main]

jobs:
  user-service:
    uses: cbuelvasc/actions/.github/workflows/ci-cd-pipeline.yml@v1
    with:
      build-tool: 'maven'
      service-name: 'user-service'
      working-directory: './user-service'
      docker-enabled: true
      image-name: 'myorg/user-service'
      push-enabled: true
    secrets:
      registry-username: ${{ secrets.DOCKER_USERNAME }}
      registry-password: ${{ secrets.DOCKER_PASSWORD }}
  
  order-service:
    uses: cbuelvasc/actions/.github/workflows/ci-cd-pipeline.yml@v1
    with:
      build-tool: 'gradle'
      service-name: 'order-service'
      working-directory: './order-service'
      docker-enabled: true
      image-name: 'myorg/order-service'
      push-enabled: true
    secrets:
      registry-username: ${{ secrets.DOCKER_USERNAME }}
      registry-password: ${{ secrets.DOCKER_PASSWORD }}
```

## 🔧 Configuración de Secrets

Para usar los workflows que incluyen Docker, configura estos secrets en tu repositorio:

```bash
# En GitHub > Settings > Secrets and variables > Actions

# Para Docker Hub
DOCKER_USERNAME=tu-usuario-dockerhub
DOCKER_PASSWORD=tu-token-dockerhub

# Para registry personalizado
CUSTOM_REGISTRY_USER=tu-usuario
CUSTOM_REGISTRY_TOKEN=tu-token

# Para múltiples entornos
DEV_REGISTRY_USER=dev-user
DEV_REGISTRY_TOKEN=dev-token
PROD_REGISTRY_USER=prod-user
PROD_REGISTRY_TOKEN=prod-token
```

## 📊 Monitoring y Troubleshooting

### Logs y Reportes
- Cada workflow genera un resumen detallado en la pestaña Summary
- Los outputs están disponibles para workflows que consuman estos workflows
- Cache hits/misses se reportan para optimización

### Solución de Problemas Comunes

**Error: "Unable to resolve action"**
```yaml
# ❌ Incorrecto
uses: cbuelvasc/actions/.github/workflows/build-and-test.yml@main

# ✅ Correcto  
uses: cbuelvasc/actions/.github/workflows/build-and-test.yml@v1
```

**Error: "Docker build failed"**
- Verifica que el Dockerfile existe en la ruta especificada
- Confirma que los secrets del registry están configurados
- Revisa los logs del step "Build Docker Image"

**Error: "Coverage below threshold"**
- Ajusta el `coverage-threshold` según tu proyecto
- Revisa la configuración de cobertura en tu build tool
- Considera excluir clases de configuración del cálculo

## 🚀 Próximos Pasos

1. **Integración con tu servicio**: Copia uno de los ejemplos y ajusta los parámetros
2. **Configuración de secrets**: Configura las credenciales necesarias
3. **Testing**: Prueba con un PR o push para validar el funcionamiento
4. **Customización**: Ajusta los parámetros según las necesidades de tu servicio

---

**Autor**: Carmelo Buelvas Comas  
**Última actualización**: Diciembre 2024 
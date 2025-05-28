# GitHub Actions Standard

## General Structure

### 1. Action Metadata
```yaml
name: 'Action Name'
description: 'Clear and concise description of what the action does'
author: 'Carmelo Buelvas Comas'
```

### 2. Branding (Required)
```yaml
branding:
  icon: 'tool-icon'  # See: https://feathericons.com/
  color: 'blue'      # Allowed colors: white, yellow, blue, green, orange, red, purple, gray-dark
```

## Naming Conventions

### Inputs
- Use **kebab-case** for input names: `java-version`, `build-tool`
- Be descriptive but concise
- Include sensible default values
- Clearly document the purpose and valid values

### Outputs
- Use **kebab-case** for output names
- Include clear description of the returned value
- Correctly reference the step that generates the output

### Steps
- Use descriptive names in English
- Logically group operations
- Include validations at the beginning

## Input Structure

```yaml
inputs:
  input-name:
    description: 'Clear description with valid values if applicable'
    required: false|true
    default: 'sensible-default'  # Only if required: false
```

### Standard Inputs for Java/Spring Boot Actions
```yaml
  java-version:
    description: 'Java version to use'
    required: false
    default: '21'
    
  java-distribution:
    description: 'Java distribution (temurin, corretto, microsoft, oracle)'
    required: false
    default: 'temurin'
    
  working-directory:
    description: 'Working directory for the project'
    required: false
    default: '.'
    
  spring-profiles:
    description: 'Spring profiles to activate'
    required: false
    default: 'test'
```

## Output Structure

```yaml
outputs:
  output-name:
    description: 'Clear description of the output value'
    value: ${{ steps.step-id.outputs.value-name }}
```

### Standard Outputs
```yaml
  java-version:
    description: 'Installed Java version'
    value: ${{ steps.java-setup.outputs.version }}
    
  java-home:
    description: 'Java installation path'
    value: ${{ steps.java-setup.outputs.path }}
```

## Steps Structure

### 1. Input Validation (First Step)
```yaml
  steps:
    - name: Validate inputs
      shell: bash
      run: |
        # Required input validations
        # Use exit 1 to fail the action
        # Clear error messages
```

### 2. Tool Setup
```yaml
    - name: Setup Java
      id: java-setup
      uses: actions/setup-java@v4
      with:
        distribution: ${{ inputs.java-distribution }}
        java-version: ${{ inputs.java-version }}
```

### 3. Cache Management
```yaml
    - name: Cache dependencies
      id: cache-step
      if: inputs.cache-enabled == 'true'
      uses: actions/cache@v4
      with:
        path: |
          # Tool-specific paths
        key: cache-key-${{ hashFiles('files') }}
        restore-keys: |
          cache-prefix-
```

### 4. Main Execution
- Steps with descriptive names
- Use conditionals when necessary
- Environment variables configured appropriately

### 5. Report Generation and Outputs
```yaml
    - name: Generate summary
      id: summary-step
      shell: bash
      run: |
        # Logic to generate outputs
        echo "output-name=value" >> $GITHUB_OUTPUT
```

## Best Practices

### Validations
1. **Validate all critical inputs** at the beginning
2. **Descriptive error messages** with valid values
3. **Fail fast** if there are configuration issues

### Cache
1. **Specific cache keys** based on relevant files
2. **Hierarchical restore keys** to maximize hits
3. **Conditionals to enable/disable** cache

### Outputs
1. **All outputs must have descriptions**
2. **Reference existing steps** correctly
3. **Sensible default values** when possible

### Scripts
1. **Use variables to improve readability**
2. **Comments in complex scripts**
3. **Appropriate error handling**

### Conditionals
1. **Use inputs to control behavior**
2. **Clear and easy to understand conditionals**
3. **Avoid complex logic in conditionals**

## Complete File Structure

```yaml
name: 'Action Name'
description: 'Action description'
author: 'Carmelo Buelvas Comas'

inputs:
  # Inputs ordered alphabetically
  # Common inputs first, specific ones after
  
outputs:
  # Outputs ordered alphabetically
  # Main outputs first
  
runs:
  using: 'composite'
  steps:
    - name: Validate inputs
      # Validations
      
    - name: Setup tools
      # Tool setup
      
    - name: Cache management
      # Cache management
      
    - name: Main execution
      # Main logic
      
    - name: Generate outputs
      # Output generation

branding:
  icon: 'appropriate-icon'
  color: 'appropriate-color'
```

## Tools and Versions

### Recommended Actions
- `actions/setup-java@v4` for Java
- `actions/cache@v4` for cache
- `actions/upload-artifact@v4` for artifacts
- `EnricoMi/publish-unit-test-result-action@v2` for test results

### Java Versions
- Default: Java 21
- Default distribution: `temurin`

### Build Tools
- Support for Maven and Gradle
- Use wrappers when available
- Optimized property configuration 
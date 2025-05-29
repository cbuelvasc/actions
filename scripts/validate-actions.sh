#!/bin/bash

# GitHub Actions Validation Script
# Author: Carmelo Buelvas Comas
# Description: Validates all GitHub Actions in the repository

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
TEST_DIR="$REPO_ROOT/test-projects"

# Available actions
ACTIONS=(
    "setup-java-maven-env"
    "setup-java-gradle-env"
    "spring-boot-test-suite"
    "docker-build"
    "cache-manager"
    "test-runner"
)

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "\n${BLUE}=================================${NC}"
    echo -e "${BLUE} GitHub Actions Validator${NC}"
    echo -e "${BLUE}=================================${NC}\n"
}

print_section() {
    echo -e "\n${YELLOW}--- $1 ---${NC}"
}

validate_action_structure() {
    local action_dir="$1"
    local action_name="$2"
    
    print_section "Validating $action_name structure"
    
    # Check if action.yml exists
    if [[ ! -f "$action_dir/action.yml" ]]; then
        log_error "action.yml not found in $action_name"
        return 1
    fi
    log_success "action.yml found"
    
    # Check if README.md exists
    if [[ ! -f "$action_dir/README.md" ]]; then
        log_warning "README.md not found in $action_name"
    else
        log_success "README.md found"
    fi
    
    # Validate YAML syntax
    if command -v yq &> /dev/null; then
        if yq eval '.' "$action_dir/action.yml" > /dev/null 2>&1; then
            log_success "action.yml has valid YAML syntax"
        else
            log_error "action.yml has invalid YAML syntax"
            return 1
        fi
    else
        log_warning "yq not found, skipping YAML validation"
    fi
    
    return 0
}

validate_action_metadata() {
    local action_file="$1"
    local action_name="$2"
    
    print_section "Validating $action_name metadata"
    
    # Check required fields
    local required_fields=("name" "description" "runs")
    
    for field in "${required_fields[@]}"; do
        if command -v yq &> /dev/null; then
            if yq eval ".$field" "$action_file" | grep -q "null"; then
                log_error "Required field '$field' is missing or null"
                return 1
            else
                log_success "Field '$field' is present"
            fi
        fi
    done
    
    # Check branding
    if command -v yq &> /dev/null; then
        if yq eval ".branding" "$action_file" | grep -q "null"; then
            log_warning "Branding information is missing"
        else
            log_success "Branding information is present"
        fi
    fi
    
    return 0
}

validate_action_inputs() {
    local action_file="$1"
    local action_name="$2"
    
    print_section "Validating $action_name inputs"
    
    if command -v yq &> /dev/null; then
        local inputs=$(yq eval '.inputs | keys | .[]' "$action_file" 2>/dev/null || echo "")
        
        if [[ -z "$inputs" ]]; then
            log_warning "No inputs defined for $action_name"
            return 0
        fi
        
        while IFS= read -r input; do
            if [[ -n "$input" ]]; then
                local description=$(yq eval ".inputs.\"$input\".description" "$action_file" 2>/dev/null)
                if [[ "$description" == "null" || -z "$description" ]]; then
                    log_error "Input '$input' is missing description"
                    return 1
                else
                    log_success "Input '$input' has description"
                fi
            fi
        done <<< "$inputs"
    fi
    
    return 0
}

validate_action_outputs() {
    local action_file="$1"
    local action_name="$2"
    
    print_section "Validating $action_name outputs"
    
    if command -v yq &> /dev/null; then
        local outputs=$(yq eval '.outputs | keys | .[]' "$action_file" 2>/dev/null || echo "")
        
        if [[ -z "$outputs" ]]; then
            log_warning "No outputs defined for $action_name"
            return 0
        fi
        
        while IFS= read -r output; do
            if [[ -n "$output" ]]; then
                local description=$(yq eval ".outputs.\"$output\".description" "$action_file" 2>/dev/null)
                local value=$(yq eval ".outputs.\"$output\".value" "$action_file" 2>/dev/null)
                
                if [[ "$description" == "null" || -z "$description" ]]; then
                    log_error "Output '$output' is missing description"
                    return 1
                else
                    log_success "Output '$output' has description"
                fi
                
                if [[ "$value" == "null" || -z "$value" ]]; then
                    log_error "Output '$output' is missing value"
                    return 1
                else
                    log_success "Output '$output' has value"
                fi
            fi
        done <<< "$outputs"
    fi
    
    return 0
}

create_test_projects() {
    print_section "Creating test projects"
    
    mkdir -p "$TEST_DIR"
    
    # Create Maven test project
    local maven_dir="$TEST_DIR/maven-sample"
    mkdir -p "$maven_dir/src/main/java/com/test"
    mkdir -p "$maven_dir/src/test/java/com/test"
    
    # Create basic pom.xml
    cat > "$maven_dir/pom.xml" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         https://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.test</groupId>
  <artifactId>test-app</artifactId>
  <version>1.0.0</version>
  <packaging>jar</packaging>
  
  <properties>
    <maven.compiler.source>21</maven.compiler.source>
    <maven.compiler.target>21</maven.compiler.target>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
  </properties>
  
  <dependencies>
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>4.13.2</version>
      <scope>test</scope>
    </dependency>
  </dependencies>
</project>
EOF
    
    # Create basic Java class
    cat > "$maven_dir/src/main/java/com/test/HelloWorld.java" << 'EOF'
package com.test;

public class HelloWorld {
    public String sayHello() {
        return "Hello, World!";
    }
}
EOF
    
    # Create basic test
    cat > "$maven_dir/src/test/java/com/test/HelloWorldTest.java" << 'EOF'
package com.test;

import org.junit.Test;
import static org.junit.Assert.assertEquals;

public class HelloWorldTest {
    @Test
    public void testSayHello() {
        HelloWorld hello = new HelloWorld();
        assertEquals("Hello, World!", hello.sayHello());
    }
}
EOF
    
    log_success "Test projects created"
}

run_validation() {
    local action_name="$1"
    local action_dir="$REPO_ROOT/$action_name"
    local validation_failed=false
    
    if [[ ! -d "$action_dir" ]]; then
        log_warning "Action directory $action_name not found, skipping"
        return 0
    fi
    
    log_info "Validating action: $action_name"
    
    # Validate structure
    if ! validate_action_structure "$action_dir" "$action_name"; then
        validation_failed=true
    fi
    
    # Validate metadata
    if ! validate_action_metadata "$action_dir/action.yml" "$action_name"; then
        validation_failed=true
    fi
    
    # Validate inputs
    if ! validate_action_inputs "$action_dir/action.yml" "$action_name"; then
        validation_failed=true
    fi
    
    # Validate outputs
    if ! validate_action_outputs "$action_dir/action.yml" "$action_name"; then
        validation_failed=true
    fi
    
    if [[ "$validation_failed" == "true" ]]; then
        log_error "Validation failed for $action_name"
        return 1
    else
        log_success "Validation passed for $action_name"
        return 0
    fi
}

main() {
    print_header
    
    # Check dependencies
    log_info "Checking dependencies..."
    
    local missing_deps=false
    
    if ! command -v git &> /dev/null; then
        log_error "git is required but not installed"
        missing_deps=true
    fi
    
    if ! command -v yq &> /dev/null; then
        log_warning "yq is not installed. Install it for better validation: https://github.com/mikefarah/yq"
    fi
    
    if [[ "$missing_deps" == "true" ]]; then
        log_error "Missing required dependencies"
        exit 1
    fi
    
    # Parse arguments
    local specific_action=""
    local create_test_projects_flag=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --action)
                specific_action="$2"
                shift 2
                ;;
            --create-test-projects)
                create_test_projects_flag=true
                shift
                ;;
            --help)
                echo "Usage: $0 [OPTIONS]"
                echo ""
                echo "Options:"
                echo "  --action ACTION_NAME      Validate specific action"
                echo "  --create-test-projects    Create test projects"
                echo "  --help                    Show this help message"
                echo ""
                echo "Available actions:"
                for action in "${ACTIONS[@]}"; do
                    echo "  - $action"
                done
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                exit 1
                ;;
        esac
    done
    
    # Create test projects if requested
    if [[ "$create_test_projects_flag" == "true" ]]; then
        create_test_projects
    fi
    
    # Run validation
    local total_validations=0
    local failed_validations=0
    
    if [[ -n "$specific_action" ]]; then
        total_validations=1
        if ! run_validation "$specific_action"; then
            failed_validations=1
        fi
    else
        for action in "${ACTIONS[@]}"; do
            total_validations=$((total_validations + 1))
            if ! run_validation "$action"; then
                failed_validations=$((failed_validations + 1))
            fi
        done
    fi
    
    # Print summary
    print_section "Validation Summary"
    
    local passed_validations=$((total_validations - failed_validations))
    
    log_info "Total actions validated: $total_validations"
    log_success "Passed: $passed_validations"
    
    if [[ $failed_validations -gt 0 ]]; then
        log_error "Failed: $failed_validations"
        exit 1
    else
        log_success "All validations passed!"
        exit 0
    fi
}

# Run main function with all arguments
main "$@" 
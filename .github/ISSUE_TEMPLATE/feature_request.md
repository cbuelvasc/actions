---
name: Feature request
about: Suggest an idea for improving our GitHub Actions
title: '[FEATURE] '
labels: ['enhancement', 'needs-triage']
assignees: ['cbuelvasc']
---

## Feature Description
<!-- A clear and concise description of what you want to happen -->

## Motivation
<!-- Is your feature request related to a problem? Please describe the problem -->

## Affected Action(s)
<!-- Which action(s) would this feature enhance or would this be a new action? -->
- [ ] `setup-java-maven-env`
- [ ] `setup-java-gradle-env`
- [ ] `spring-boot-test-suite`
- [ ] `docker-build`
- [ ] `cache-manager`
- [ ] `test-runner`
- [ ] New action: _______________

## Proposed Solution
<!-- Describe the solution you'd like -->

## Alternative Solutions
<!-- Describe any alternative solutions or features you've considered -->

## Use Case
<!-- Describe your specific use case for this feature -->

## Example Usage
<!-- If applicable, provide an example of how this feature would be used -->
```yaml
# Example workflow using the proposed feature
name: Example Usage

on: [push]

jobs:
  example:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Use new feature
        uses: your-org/actions/action-name@main
        with:
          new-parameter: 'example-value'
```

## Acceptance Criteria
<!-- Define what needs to be done for this feature to be considered complete -->
- [ ] Feature implemented and tested
- [ ] Documentation updated
- [ ] Examples provided
- [ ] Backwards compatibility maintained (if applicable)
- [ ] Performance impact assessed

## Additional Context
<!-- Add any other context, mockups, or examples about the feature request here -->

## Implementation Notes
<!-- If you have ideas about how this could be implemented, please share them here --> 
# Writing Documentation Skill - Research

**Researched on:** 2025-12-27
**Context:** Documentation skill for harness plugin

## TypeScript/JavaScript Documentation

### TSDoc vs JSDoc

**Current Standard:** TSDoc is recommended for TypeScript projects

**Key Findings:**
- TSDoc builds on JSDoc with TypeScript-specific enhancements
- JSDoc grammar not rigorously specified; TSDoc fixes compatibility issues
- For TypeScript, don't duplicate types in comments (TypeScript provides them)
- Average users wouldn't notice significant difference between TSDoc and JSDoc

**Tooling:**
- eslint-plugin-jsdoc v61.5.0 (current)
- TypeDoc for documentation generation
- API-Extractor + API-Documenter for enterprise toolchains

**Sources:**
- https://tsdoc.org/
- https://www.typescriptlang.org/docs/handbook/jsdoc-supported-types.html
- https://github.com/gajus/eslint-plugin-jsdoc

## Python Documentation

### Docstring Styles

**Current Options:**
- Google Style: Easier to read for short docstrings, uses indentation
- NumPy Style: Better for long docstrings, uses underlines (data science standard)
- Sphinx/reST: Most formatting options, recommended by PEP 287

**Recommendation:** Google Style for general use (readability + Sphinx compatibility)

**Key Findings:**
- Napoleon extension enables Sphinx to parse Google/NumPy styles
- No one-size-fits-all; consistency within project is key
- PyCharm supports all three styles

**Sources:**
- https://www.sphinx-doc.org/en/master/usage/extensions/napoleon.html
- https://mcginniscommawill.com/posts/2025-03-06-writing-effective-docstrings/

## API Documentation

### OpenAPI Specification

**Current Version:** OpenAPI 3.2.0 (released September 19, 2025)

**Key Findings:**
- v3.2.0 adds hierarchical tags, enhanced security, extended parameters
- Some tools still catching up to 3.1.0 support
- Microsoft OpenAPI.NET v3 supports 3.2.0

**Sources:**
- https://spec.openapis.org/oas/v3.2.0.html
- https://github.com/OAI/OpenAPI-Specification/releases

## Documentation Linting

### JavaScript/TypeScript

**eslint-plugin-jsdoc:**
- Version: 61.5.0 (current)
- Flat config recommended for ESLint v9+
- `jsdoc.configs['flat/recommended-typescript']` for TS projects

**@eslint/markdown:**
- ESLint v9.15.0+ has native Markdown support
- Does not provide formatting (use Prettier)

**Sources:**
- https://github.com/gajus/eslint-plugin-jsdoc
- https://github.com/eslint/markdown

## Documentation Testing

### Python doctest

**Key Findings:**
- Built into Python standard library
- pytest integration: `pytest --doctest-modules`
- Verifies code examples in docstrings actually work
- Limitation: Requires exact output matches

**pytest-doctestplus:**
- Advanced features for scientific Python
- Approximate floating point comparison
- Remote data handling

**Sources:**
- https://docs.python.org/3/library/doctest.html
- https://docs.pytest.org/en/stable/how-to/doctest.html

## Technical Writing Best Practices

### Industry Standards

**Google Developer Style Guide** is the industry reference for technical documentation.

**Core Principles:**
- Active voice (≤10% passive)
- One idea per paragraph
- Cut unnecessary words
- Readability: grade 9 or less (Hemingway)

**Anti-Patterns to Avoid:**
- Overloading with jargon
- Incomplete steps
- Burying key information
- Failing to update
- Lack of examples

**Sources:**
- https://developers.google.com/style
- https://www.documind.chat/blog/technical-writing-best-practices

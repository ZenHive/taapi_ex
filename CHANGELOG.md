# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.1] - 2025-02-04

### Changed

- Add affiliate links to Taapi.io references in documentation

## [0.1.0] - 2025-02-03

### Added

- Initial release with 208 Taapi.io indicators
- Macro-based indicator generation for compile-time function creation
- Discovery API: `indicators/0`, `describe/1`, `search/1`, `by_category/1`, `categories/0`
- Typed error handling with `Taapi.Error` struct
- Direct client access via `Taapi.Client.get/2` for custom endpoints
- Integration tests for major indicator categories

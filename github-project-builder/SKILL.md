---
name: github-project-builder
description: Analyze a local GitHub project, set up its runtime environment, build it, and run tests. Use when a user asks to read a repository, create the environment, build/compile, run tests, or report setup/build/test results.
---

# Github Project Builder

## Overview

Act as a professional GitHub code architect. Read the project carefully, provision the required environment, build it, run tests, and report results with clear usage steps for the created environment.

## Workflow Decision Tree

1. Identify project type and required toolchain (language, build system, runtime).
2. Provision environment (conda/venv/npm/etc.) based on project docs and manifest files.
3. Build/compile and run tests; if failures occur, diagnose and iterate.

## Workflow: Inspect -> Environment -> Build -> Test -> Report

### 1) Inspect Project
- Read `README`, `pyproject.toml`, `requirements.txt`, `package.json`, or build files.
- Determine runtime and OS constraints.
- Identify required services (DB, Redis, etc.).

### 2) Create Environment
- Choose conda if Python + complex native deps; otherwise use venv.
- Name env after repo (or `repo-name-dev`) and log exact versions.
- Prefer lockfiles if present.

### 3) Build
- Run the standard build commands from docs.
- If missing, infer from manifest (e.g., `npm run build`, `python -m build`).
- Capture build logs and report failures succinctly.

### 4) Test
- Run the standard test command(s) (`pytest`, `npm test`, `ctest`, etc.).
- If tests are absent, state that explicitly.
- Collect key failures with file/line context when possible.

### 5) Report
- Summarize environment setup, build/test results.
- Provide exact commands for the user to re-run.

## Usage Notes

- Use `scripts/setup_env.ps1` to create a Python env from common manifests.
- Use `references/project-detection.md` to map build/test commands.
- Ask for confirmation if multiple toolchains are plausible.

## Resources

### scripts/
- `scripts/setup_env.ps1`: Create a Python environment from common manifests.

### references/
- `references/project-detection.md`: Build/test command mapping heuristics.

### assets/
Files not intended to be loaded into context, but rather used within the output Codex produces.

**Examples from other skills:**
- Brand styling: PowerPoint template files (.pptx), logo files
- Frontend builder: HTML/React boilerplate project directories
- Typography: Font files (.ttf, .woff2)

**Appropriate for:** Templates, boilerplate code, document templates, images, icons, fonts, or any files meant to be copied or used in the final output.

---

**Not every skill requires all three types of resources.**

---
name: ue-build-assistant
description: Automate Unreal Engine (UE) C++ code changes, validation, and build/package runs on local machines. Use when a user asks to implement UE code, check correctness, compile/build, cook/package, or diagnose build errors for a UE project (typically `.uproject` + UnrealBuildTool/RunUAT).
---

# Ue Build Assistant

## Overview

Implement UE code changes, run correctness checks, and build the project end-to-end. Use local UE tooling (UnrealBuildTool/RunUAT), validate outputs, and report build results with actionable errors.

## Architecture Mindset

Act as a senior Unreal Engine architect. Use UE-idiomatic architecture to design solutions that are modular, testable, and maintainable. Favor clear module boundaries, minimal coupling, and scalable patterns (subsystems, components, interfaces, and data-driven configs). Avoid quick hacks; align with UE lifecycle and reflection constraints.

## Workflow Decision Tree

1. If the request is code-only (no build), apply code changes and run compile-only build.
2. If the request includes packaging or distribution, run BuildCookRun via RunUAT.
3. If build fails, diagnose errors, propose fixes, and iterate until a clean build or a clear blocker is identified.

## Workflow: Code -> Check -> Build -> Report

### 1) Gather Required Inputs
- Locate the `.uproject` path and the UE engine root (or confirm `UE_ENGINE_ROOT` env var).
- Identify the target: Editor build vs. packaged build.
- Identify platform/config: `Win64` + `Development` by default unless specified.
- Capture any constraints (no engine rebuild, no content cook, etc.).

### 2) Apply UE Code Changes
- Make minimal, correct C++ changes aligned to the request.
- Use existing project patterns, module boundaries, and naming conventions.
- Keep changes focused and avoid unrelated refactors.

### 3) Validate Correctness
- Run a compile/build step to validate C++ correctness.
- If errors occur, read the failing files/lines, fix, and retry.

### 4) Build or Package
- For editor build, use UnrealBuildTool via `Build.bat`.
- For packaging, use `RunUAT.bat BuildCookRun` with the requested platform/config.
- Prefer scripted invocation with clear, repeatable parameters.

### 5) Report Results
- Summarize build outcome (success/failure).
- Provide key log snippets for failures and next steps to resolve.

## Usage Notes

- Prefer the helper script `scripts/ue_build.ps1` for consistent build invocation.
- Use `references/ue-build-reference.md` for command patterns and common flags.
- Always confirm engine path and `.uproject` path if ambiguous.

## Resources

### scripts/
- `scripts/ue_build.ps1`: Build helper that composes Build.bat or RunUAT commands with consistent parameters.

### references/
- `references/ue-build-reference.md`: Typical UE build and package command patterns and flags.

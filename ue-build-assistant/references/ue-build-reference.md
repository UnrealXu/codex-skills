# UE Build Reference (Windows)

## Required Inputs
- `.uproject` full path
- UE engine root (or set `UE_ENGINE_ROOT`)
- Target: `Editor` build vs. packaged build
- Platform/config: `Win64` + `Development` by default

## Common Commands

### Editor build (compile C++)
```
Engine/Build/BatchFiles/Build.bat <ProjectName>Editor Win64 Development -Project="X:\Path\Project.uproject" -WaitMutex -FromMsBuild
```

### Package build (cook + stage + pak)
```
Engine/Build/BatchFiles/RunUAT.bat BuildCookRun -project="X:\Path\Project.uproject" -noP4 -platform=Win64 -clientconfig=Development -build -cook -stage -pak -archive -archivedirectory="X:\Path\Archive"
```

## Typical Failure Triage
- Missing modules: ensure `.Build.cs` dependencies and module names are correct.
- Compiler errors: open reported file/line, fix, re-run build.
- UHT errors: check `UCLASS/USTRUCT` macros and include order.
- Linker errors: verify module exports and build.cs `Public/PrivateDependencyModuleNames`.

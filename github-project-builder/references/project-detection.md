# Project Detection Reference

## Python
- Build: `python -m build` or `pip install -e .`
- Test: `pytest` (fallback)
- Signals: `pyproject.toml`, `requirements.txt`, `setup.py`

## Node.js
- Build: `npm run build`
- Test: `npm test`
- Signals: `package.json`

## CMake
- Build: `cmake -S . -B build` then `cmake --build build`
- Test: `ctest --test-dir build`
- Signals: `CMakeLists.txt`

## .NET
- Build: `dotnet build`
- Test: `dotnet test`
- Signals: `.csproj`, `.sln`

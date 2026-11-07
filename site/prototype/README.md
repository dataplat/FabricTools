# Documentation site prototype

A clickable prototype of the FabricTools documentation site ([issue #3](https://github.com/dataplat/FabricTools/issues/3)). It is generated entirely from `docs/en-US`.

## Run

```powershell
./site/prototype/Build-CommandIndex.ps1   # regenerates commands.js from docs/en-US
start ./site/prototype/index.html         # works from file://, no server needed
```

## What it shows

- **Command Explorer** (`#/`): search by name fragments (`get lake`), filter by **item type** and **verb**. Filters are kept in the URL, e.g. `#/?type=Lakehouse&verb=Get`.
- **Command page** (`#/cmd/<Name>`): syntax, description, examples, a parameter table built from the PlatyPS YAML, and the other commands of the same item type.
- Keyboard: `/` focuses search, arrow keys move through results, Enter opens a command.

## Item type

Item type is the `src/Public/<folder>` that contains the cmdlet (`Core` for cmdlets in `src/Public` itself).
The target design is for `Generate_help_from_built_module` to write it into each doc's frontmatter as `itemType`.
Until that is done, `Build-CommandIndex.ps1` falls back to looking up the folder in `src/Public`.

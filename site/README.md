# Documentation website

Static documentation website for FabricTools ([issue #3](https://github.com/dataplat/FabricTools/issues/3)), published at <https://dataplat.github.io/FabricTools/>.
All content is generated from the PlatyPS help in `docs/en-US`; nothing is written by hand.

## Build and preview locally

```powershell
./site/Build-DocsSite.ps1 -LocalPreview     # writes ./output/site
start ./output/site/index.html              # -LocalPreview makes links work from file://
```

Without `-LocalPreview`, links use clean URLs (`commands/Get-FabricLakehouse/`), which need a web server, for example `python -m http.server -d output/site`.

## What gets generated

| Path | Content |
|---|---|
| `index.html` | Command Explorer: search by name fragments (`get lake`), filter by item type and verb. Filters are kept in the URL, e.g. `#type=Lakehouse&verb=Get`. |
| `commands/<Name>/` | One page per cmdlet: syntax, description, examples, parameter table, inputs/outputs, notes, related commands. The URL is stable, so it can be used for `HelpUri` / `Get-Help -Online`. |
| `assets/commands.js` | Search index (name, verb, item type, synopsis) and the latest released version. |
| `404.html`, `sitemap.xml`, `robots.txt`, `.nojekyll` | GitHub Pages and crawler files. |

Every page is fully rendered at build time. `assets/site.js` only adds search, PowerShell highlighting and copy buttons.

## Data sources

- **Commands**: `docs/en-US/*.md` (PlatyPS v1 markdown).
- **Item type**: the `itemType` frontmatter key. The `generate_docs` and `Generate_help_from_built_module` build tasks set it to the `src/Public/<folder>` that contains the cmdlet (`Core` for cmdlets directly in `src/Public`). Adding a folder adds a new filter automatically.
- **Latest release**: the first versioned heading in `CHANGELOG.md`.

The `Docs` QA tests (`tests/QA/docs.tests.ps1`) check that every help file has the right `itemType`, that every public function is documented, and that the site builds without warnings.

## Deployment

`.github/workflows/docs.yml` builds the site for pull requests (downloadable as the `docs-site` artifact) and deploys it to GitHub Pages on every push to `main` that changes `docs/`, `site/` or `CHANGELOG.md`.
Moving to a custom domain (e.g. fabrictools.io) later only needs the domain set in **Settings > Pages > Custom domain** and `-BaseUrl 'https://fabrictools.io/'` passed to `Build-DocsSite.ps1` in the workflow. All internal links are relative.

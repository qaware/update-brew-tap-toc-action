# update-brew-tap-toc-action

This GitHub action reads the Homebrew tap folder and procduces a table of content.
The list of formulae is then placed in the specified files, eg. your README.md.

## Example

An example workflow can look like.

```yaml
name: Update TOC
run-name: Update TOC 🚀
on:
  push:
    branches:
      - main
    paths:
      - Formula/**/*.rb
      - README.md
jobs:
  update-toc:
    runs-on: ubuntu-latest
    steps:
      - name: Check out repository code
        uses: actions/checkout@v4

      - name: Update TOC
        uses: qaware/update-brew-tap-toc-action@main

      - name: Commit & Push changes
        # Use some action that fits your needs
```

You can pass options.

```yaml
# ...
steps:
  - name: Update TOC
    uses: qaware/update-brew-tap-toc-action@main
    with:
      formula-folder: Formula-cstm
      replace-in: README.md,TOC.md,docs/content.adoc
      replace-marker-start: '// START TOC'
      replace-marker-end: '// END TOC'
```

## Maintainers

* Alexander Eimer ([@aeimer](https://github.com/aeimer))

## Support

This project is made possible with the support of

[![QAware GmbH logo](https://blog.qaware.de/images/icons/logo_qaware.svg)](https://qaware.de)

# AMIV Statuten

## Output Format: PDF

### Installation

- **Windows**: Install [MikTeX](https://miktex.org).
- **Linux**: Install `TeX Live` on your system. (e.g. for Ubuntu, `sudo apt-get install texlive`)

### Generate Output

```bash
pdflatex -output-directory=output amiv-statuten.tex
```

## Output Format: HTML

### Installation

Pandoc is being used to generate the HTML output. Installation instructions are on [GitHub](https://github.com/jgm/pandoc/blob/master/INSTALL.md).

### Generate Output

```bash
pandoc -o output/amiv-statuten.html amiv-statuten.tex 
```
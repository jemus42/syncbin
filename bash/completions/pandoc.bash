# Pandoc bash completion
# Generated dynamically - for offline use
# For most up-to-date completions, use: eval "$(pandoc --bash-completion)"

_pandoc()
{
    local cur prev opts lastc informats outformats highlight_styles
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    # Dynamically get formats if pandoc is available, otherwise use cached list
    if command -v pandoc >/dev/null 2>&1; then
        informats="$(pandoc --list-input-formats 2>/dev/null | tr '\n' ' ')"
        outformats="$(pandoc --list-output-formats 2>/dev/null | tr '\n' ' ')"
        highlight_styles="$(pandoc --list-highlight-styles 2>/dev/null | tr '\n' ' ')"
    else
        informats="commonmark creole docbook docx epub gfm html json latex markdown native odt org rst textile"
        outformats="asciidoc beamer commonmark context docbook docx dzslides epub gfm html html5 json latex man markdown native odt org pdf plain pptx revealjs rst rtf"
        highlight_styles="pygments tango espresso zenburn kate monochrome breezedark haddock"
    fi

    opts="-f -r --from --read -t -w --to --write -o --output --data-dir -M --metadata --metadata-file -d --defaults --file-scope --sandbox -s --standalone --template -V --variable --wrap --ascii --toc --table-of-contents --toc-depth -N --number-sections --number-offset --top-level-division --extract-media --resource-path -H --include-in-header -B --include-before-body -A --include-after-body --no-highlight --highlight-style --syntax-definition --dpi --eol --columns -p --preserve-tabs --tab-stop --pdf-engine --pdf-engine-opt --reference-doc --embed-resources --request-header --no-check-certificate --abbreviations --indented-code-classes --default-image-extension -F --filter -L --lua-filter --shift-heading-level-by --track-changes --strip-comments --reference-links --reference-location --markdown-headings --list-tables --listings -i --incremental --slide-level --section-divs --html-q-tags --email-obfuscation --id-prefix -T --title-prefix -c --css --epub-subdirectory --epub-cover-image --epub-title-page --epub-metadata --epub-embed-font --split-level --chunk-template --epub-chapter-level --ipynb-output -C --citeproc --bibliography --csl --citation-abbreviations --natbib --biblatex --mathml --webtex --mathjax --katex --gladtex --trace --verbose --quiet --fail-if-warnings --log --bash-completion --list-input-formats --list-output-formats --list-extensions --list-highlight-languages --list-highlight-styles -D --print-default-template --print-default-data-file --print-highlight-style -v --version -h --help"

    case "${prev}" in
         --from|-f|--read|-r)
             COMPREPLY=( $(compgen -W "${informats}" -- ${cur}) )
             return 0
             ;;
         --to|-t|--write|-w|-D|--print-default-template)
             COMPREPLY=( $(compgen -W "${outformats}" -- ${cur}) )
             return 0
             ;;
         --email-obfuscation)
             COMPREPLY=( $(compgen -W "references javascript none" -- ${cur}) )
             return 0
             ;;
         --ipynb-output)
             COMPREPLY=( $(compgen -W "all none best" -- ${cur}) )
             return 0
             ;;
         --pdf-engine)
             COMPREPLY=( $(compgen -W "pdflatex lualatex xelatex latexmk tectonic wkhtmltopdf weasyprint pagedjs-cli prince context pdfroff typst" -- ${cur}) )
             return 0
             ;;
         --wrap)
             COMPREPLY=( $(compgen -W "auto none preserve" -- ${cur}) )
             return 0
             ;;
         --track-changes)
             COMPREPLY=( $(compgen -W "accept reject all" -- ${cur}) )
             return 0
             ;;
         --reference-location)
             COMPREPLY=( $(compgen -W "block section document" -- ${cur}) )
             return 0
             ;;
         --top-level-division)
             COMPREPLY=( $(compgen -W "section chapter part" -- ${cur}) )
             return 0
             ;;
         --highlight-style|--print-highlight-style)
             COMPREPLY=( $(compgen -W "${highlight_styles}" -- ${cur}) )
             return 0
             ;;
         --eol)
             COMPREPLY=( $(compgen -W "crlf lf native" -- ${cur}) )
             return 0
             ;;
         --markdown-headings)
             COMPREPLY=( $(compgen -W "setext atx" -- ${cur}) )
             return 0
             ;;
         *)
             ;;
    esac

    case "${cur}" in
         -*)
             COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
             return 0
             ;;
         *)
             local IFS=$'\n'
             COMPREPLY=( $(compgen -X '' -f "${cur}") )
             return 0
             ;;
    esac
}

complete -o filenames -o bashdefault -F _pandoc pandoc

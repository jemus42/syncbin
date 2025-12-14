# Pandoc fish completion
# Dynamically queries pandoc for available formats

# Helper function to get input formats
function __pandoc_input_formats
    pandoc --list-input-formats 2>/dev/null
end

# Helper function to get output formats
function __pandoc_output_formats
    pandoc --list-output-formats 2>/dev/null
end

# Helper function to get highlight styles
function __pandoc_highlight_styles
    pandoc --list-highlight-styles 2>/dev/null
end

# Clear existing completions
complete -c pandoc -e

# Input/output formats
complete -c pandoc -s f -l from -s r -l read -x -a "(__pandoc_input_formats)" -d "Input format"
complete -c pandoc -s t -l to -s w -l write -x -a "(__pandoc_output_formats)" -d "Output format"

# File options
complete -c pandoc -s o -l output -r -d "Output file"
complete -c pandoc -l data-dir -r -d "User data directory"
complete -c pandoc -s M -l metadata -x -d "Set metadata field"
complete -c pandoc -l metadata-file -r -d "YAML metadata file"
complete -c pandoc -s d -l defaults -r -d "Defaults file"

# Document structure
complete -c pandoc -l file-scope -d "Parse each file individually"
complete -c pandoc -l sandbox -d "Run in sandbox mode"
complete -c pandoc -s s -l standalone -d "Produce standalone document"
complete -c pandoc -l template -r -d "Custom template"
complete -c pandoc -s V -l variable -x -d "Set template variable"

# Formatting
complete -c pandoc -l wrap -x -a "auto none preserve" -d "Text wrapping"
complete -c pandoc -l ascii -d "Use ASCII characters only"
complete -c pandoc -l toc -l table-of-contents -d "Include table of contents"
complete -c pandoc -l toc-depth -x -a "1 2 3 4 5 6" -d "TOC depth"
complete -c pandoc -s N -l number-sections -d "Number section headings"
complete -c pandoc -l number-offset -x -d "Starting number for sections"
complete -c pandoc -l top-level-division -x -a "default section chapter part" -d "Top-level division type"

# Media and resources
complete -c pandoc -l extract-media -r -d "Extract media to directory"
complete -c pandoc -l resource-path -r -d "Search path for resources"

# Header/footer includes
complete -c pandoc -s H -l include-in-header -r -d "Include in header"
complete -c pandoc -s B -l include-before-body -r -d "Include before body"
complete -c pandoc -s A -l include-after-body -r -d "Include after body"

# Syntax highlighting
complete -c pandoc -l no-highlight -d "Disable syntax highlighting"
complete -c pandoc -l highlight-style -x -a "(__pandoc_highlight_styles)" -d "Highlighting style"
complete -c pandoc -l syntax-definition -r -d "Syntax definition file"

# Output formatting
complete -c pandoc -l dpi -x -d "DPI for pixel conversion"
complete -c pandoc -l eol -x -a "crlf lf native" -d "Line endings"
complete -c pandoc -l columns -x -d "Line width for wrapping"
complete -c pandoc -s p -l preserve-tabs -d "Preserve tabs"
complete -c pandoc -l tab-stop -x -a "1 2 4 8" -d "Tab stop width"

# PDF options
complete -c pandoc -l pdf-engine -x -a "pdflatex lualatex xelatex latexmk tectonic wkhtmltopdf weasyprint pagedjs-cli prince context pdfroff typst" -d "PDF generation engine"
complete -c pandoc -l pdf-engine-opt -x -d "PDF engine option"

# Reference documents
complete -c pandoc -l reference-doc -r -d "Reference document"
complete -c pandoc -l embed-resources -d "Embed external resources"
complete -c pandoc -l request-header -x -d "HTTP request header"
complete -c pandoc -l no-check-certificate -d "Skip certificate verification"

# Code and text handling
complete -c pandoc -l abbreviations -r -d "Abbreviations file"
complete -c pandoc -l indented-code-classes -x -d "Classes for indented code"
complete -c pandoc -l default-image-extension -x -a "png jpg svg pdf eps" -d "Default image extension"

# Filters
complete -c pandoc -s F -l filter -r -d "External filter"
complete -c pandoc -s L -l lua-filter -r -d "Lua filter"

# Document conversion options
complete -c pandoc -l shift-heading-level-by -x -d "Shift heading levels"
complete -c pandoc -l track-changes -x -a "accept reject all" -d "Track changes mode"
complete -c pandoc -l strip-comments -d "Strip HTML comments"
complete -c pandoc -l reference-links -d "Use reference-style links"
complete -c pandoc -l reference-location -x -a "block section document" -d "Reference link location"
complete -c pandoc -l markdown-headings -x -a "setext atx" -d "Markdown heading style"
complete -c pandoc -l list-tables -d "Use list tables for RST"
complete -c pandoc -l listings -d "Use listings package for LaTeX"

# Slide options
complete -c pandoc -s i -l incremental -d "Incremental lists in slides"
complete -c pandoc -l slide-level -x -a "1 2 3 4 5 6" -d "Heading level for slides"
complete -c pandoc -l section-divs -d "Wrap sections in divs"

# HTML options
complete -c pandoc -l html-q-tags -d "Use q tags for quotes"
complete -c pandoc -l email-obfuscation -x -a "none javascript references" -d "Email obfuscation"
complete -c pandoc -l id-prefix -x -d "Prefix for identifiers"
complete -c pandoc -s T -l title-prefix -x -d "Title prefix"
complete -c pandoc -s c -l css -r -d "CSS stylesheet"

# EPUB options
complete -c pandoc -l epub-subdirectory -x -d "EPUB subdirectory"
complete -c pandoc -l epub-cover-image -r -d "EPUB cover image"
complete -c pandoc -l epub-title-page -x -a "true false" -d "EPUB title page"
complete -c pandoc -l epub-metadata -r -d "EPUB metadata file"
complete -c pandoc -l epub-embed-font -r -d "Embed font in EPUB"
complete -c pandoc -l epub-chapter-level -x -a "1 2 3 4 5 6" -d "EPUB chapter level"

# Chunked HTML
complete -c pandoc -l split-level -x -a "1 2 3 4 5 6" -d "Chunked HTML split level"
complete -c pandoc -l chunk-template -x -d "Chunked HTML template"

# Jupyter
complete -c pandoc -l ipynb-output -x -a "all none best" -d "Jupyter output handling"

# Citations
complete -c pandoc -s C -l citeproc -d "Process citations"
complete -c pandoc -l bibliography -r -d "Bibliography file"
complete -c pandoc -l csl -r -d "CSL style file"
complete -c pandoc -l citation-abbreviations -r -d "Citation abbreviations"
complete -c pandoc -l natbib -d "Use natbib for citations"
complete -c pandoc -l biblatex -d "Use biblatex for citations"

# Math rendering
complete -c pandoc -l mathml -d "Use MathML for math"
complete -c pandoc -l webtex -x -d "Use web service for math"
complete -c pandoc -l mathjax -x -d "Use MathJax for math"
complete -c pandoc -l katex -x -d "Use KaTeX for math"
complete -c pandoc -l gladtex -d "Use gladtex for math"

# Diagnostics
complete -c pandoc -l trace -d "Enable tracing"
complete -c pandoc -l verbose -d "Verbose output"
complete -c pandoc -l quiet -d "Suppress warnings"
complete -c pandoc -l fail-if-warnings -d "Exit with error on warnings"
complete -c pandoc -l log -r -d "Log file"

# Listing commands
complete -c pandoc -l bash-completion -d "Generate bash completion"
complete -c pandoc -l list-input-formats -d "List input formats"
complete -c pandoc -l list-output-formats -d "List output formats"
complete -c pandoc -l list-extensions -x -a "(__pandoc_input_formats)" -d "List extensions for format"
complete -c pandoc -l list-highlight-languages -d "List highlighting languages"
complete -c pandoc -l list-highlight-styles -d "List highlighting styles"

# Print defaults
complete -c pandoc -s D -l print-default-template -x -a "(__pandoc_output_formats)" -d "Print default template"
complete -c pandoc -l print-default-data-file -x -d "Print default data file"
complete -c pandoc -l print-highlight-style -x -a "(__pandoc_highlight_styles)" -d "Print highlight style"

# Help
complete -c pandoc -s v -l version -d "Show version"
complete -c pandoc -s h -l help -d "Show help"

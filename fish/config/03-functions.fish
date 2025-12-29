# Shell Functions
# Custom functions and complex command definitions


# Reload syncbin configuration
function reload
    echo "Updating syncbin at $SYNCBIN..."
    git -C "$SYNCBIN" pull --recurse-submodules origin main
    echo ""
    echo "Running health check..."
    "$SYNCBIN/bin/syncbin-doctor"
    echo ""
    echo "Reloading Fish..."
    exec fish
end


# PDF manipulation
function pdfcombine
    if test (count $argv) -lt 2
        echo "Usage: pdfcombine output.pdf input1.pdf input2.pdf ..."
        return 1
    end
    
    set output $argv[1]
    set inputs $argv[2..-1]
    echo "Output: $output"
    echo "Input: $inputs"
    gs -q -sPAPERSIZE=letter -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile="$output" $inputs
end

# Video compression and conversion
function compavc
    if test (count $argv) -eq 0
        echo "Usage: compavc input.mp4"
        return 1
    end
    
    set input $argv[1]
    set output (string replace -r '\.(mp4|mkv)$' '' "$input")"-comp.mp4"
    ffmpeg -i "$input" -vcodec libx264 -crf 23 "$output"
end

function gif2mp4
    if test (count $argv) -eq 0
        echo "Usage: gif2mp4 input.gif"
        return 1
    end
    
    set input $argv[1]
    set tempgif (mktemp)
    ffmpeg -stream_loop 10 -i "$input" "$tempgif.gif" -y
    ffmpeg -i "$tempgif.gif" -movflags faststart -pix_fmt yuv420p -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" (string replace '.gif' '.mp4' "$input")
    rm -f "$tempgif.gif"
end

function ffsilent
    if test (count $argv) -eq 0
        echo "Usage: ffsilent input.mp4"
        return 1
    end
    
    set input $argv[1]
    set ext (string split -r -m1 . "$input")[2]
    ffmpeg -i "$input" -c copy -an "$input-nosound.$ext"
end

# Image processing
function alpha2white
    if test (count $argv) -eq 0
        echo "Usage: alpha2white image.png"
        return 1
    end
    convert "$argv[1]" -background white -alpha remove -alpha off "$argv[1]"
end

function imgcrop
    if test (count $argv) -eq 0
        echo "Usage: imgcrop image.png"
        return 1
    end
    magick mogrify -bordercolor white -fuzz 2% -trim -format png "$argv[1]"
end

# Git utilities
function git-find-large-files
    git rev-list --objects --all | \
    git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' | \
    sed -n 's/^blob //p' | \
    sort --numeric-sort --key=2 | \
    cut -c 1-12,41- | \
    begin
        if command -v gnumfmt >/dev/null 2>&1
            gnumfmt --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest
        else
            numfmt --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest
        end
    end
end

function git-disk-usage
    git for-each-ref --format='%(refname)' | while read -l branch
        set size (git rev-list --disk-usage=human --objects HEAD.."$branch")
        echo "$size $branch"
    end | sort -h
end

function gitit
    git commit -am "Formatting / typo / trivial change "(date +%Y%m%d%H%M%S) && git push
end

function git-timetravel
    if test (count $argv) -eq 0
        echo "Must provide a valid timestamp in roughly ISO 8601"
        echo "Example: git-timetravel \"2022-10-01 12:00\" main"
        return 1
    end

    set timestamp $argv[1]
    if test (count $argv) -ge 2
        set branch $argv[2]
    else
        set branch (git rev-parse --abbrev-ref HEAD)
        echo "Guessing branch: $branch"
    end

    git checkout (git rev-list -n 1 --first-parent --before="$timestamp" "$branch")
end

# Download utilities
function aria
    aria2c --seed-time=0 --max-concurrent-downloads=5 $argv
end

# LaTeX cleanup
function cleantex
    rm -rf ./*.out ./*.dvi ./*.log ./*.aux ./*.bbl ./*.blg ./*.ind ./*.idx ./*.ilg ./*.lof ./*.lot ./*.toc ./*.nav ./*.snm ./*.vrb ./*.fls ./*.fdb_latexmk ./*.synctex.gz ./*-concordance.tex
end

# R package management
function upr-base
    R -e "update.packages(ask = FALSE)"
end

function upr
    R -e "remotes::update_packages()"
end

# Makefile validation
function checkmake
    rg "^[^\S\t\n\r]" < Makefile
end

# RStudio launcher
function rstudio
    set file
    if test (count $argv) -eq 0
        set file (find . -maxdepth 1 -iname '*.Rproj')
    else
        set file $argv[1]
    end

    echo "Opening $file with RStudio..."
    open -a RStudio.app "$file"
end

# Help function with bat pager
if command -v bat >/dev/null 2>&1
    function help
        $argv --help 2>&1 | bat --plain --language=help
    end
end

# Tmux session management functions
function tmn
    if test (count $argv) -eq 0
        tmux new-session -A -s "$host_short"
    else
        tmux new-session -A -s "$argv[1]"
    end
end

function tma
    set session_name
    if test (count $argv) -eq 0
        set session_name "$host_short"
    else
        set session_name "$argv[1]"
    end

    if tmux list-sessions | grep -q "^$session_name:"
        # Session exists, attach to it
        tmux attach -t "$session_name"
    else
        # Session does not exist, create it and then attach
        tmux new-session -s "$session_name"
    end
end

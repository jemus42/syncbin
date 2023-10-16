
alias R="R --quiet --no-save"
alias tmn="tmux new-session -A -s hpc"
alias tma="tmux attach -t hpc"


function sq () { squeue --clusters=$CLUSTERS --me -l --sort=T $@; }
function sqr () { sq --states="R" $@; }
function sqq () { sq --states="PD" $@; }

alias sqc="sq -h | wc -l"
alias sqrc="sq -h --states=R | wc -l"
alias sqqc="sq -h --states=PD | wc -l"

function sqstat () {

  BLUE='\033[1;34m'
  GREEN='\033[0;32m'
  RED='\033[0;31m'
  NC='\033[0m' # No Color

  echo ""
  echo "Status as of $(date '+%F %T'):"
  echo ""
  echo "${BLUE}$(sqc)${NC} jobs | ${GREEN}$(sqrc)${NC} running | ${RED}$(sqqc)${NC} queued"
  echo ""	
} 

# resource limits https://stackoverflow.com/a/61587377/409362
alias slimits="sacctmgr list associations"

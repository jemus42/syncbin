# HPC-specific overrides and additions
# Note: Git aliases and tmux functions are now in the main configs

# R with HPC-friendly options
alias R="R --quiet --no-save"

# Directory navigation (if not already defined)
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Git aliases specific to HPC workflow
alias gprav="git pull --rebase --autostash -v"

alias tl="tmux list-sessions"

# See https://slurm.schedmd.com/squeue.html
# and https://github.com/mllg/batchtools/blob/1196047ed5115d54bde2923848c1f3ec11fda6d2/R/clusterFunctionsSlurm.R

function sqm () {
  sq --me "$@" -M "${CLUSTERS}"
}

function sq () {
  squeue --noconvert --format='%i %.10P %.8u %.10T %.10M %.10L %l %D %c %11R %.6m %15k' --sort=T "$@"
}

alias sqr="sqm --states=R,S,CG,RS,SI,SO,ST"
alias sqq="sqm --states=PD,CF,RF,RH,RQ,SE"

alias sqrc="sqr --noheader | wc -l"
alias sqqc="sqq --noheader | wc -l"
alias sqc="sqm --noheader | wc -l"

# sacct aliases to check on recently completed or failed jobs
function slac () {
  sacct -M $CLUSTERS -X --format=Comment,JobID,Partition,NodeList,Elapsed,AllocCPUS,State%20,ExitCode,UserCPU,ReqMem,MaxRSS,AveRSS "$@"
}

alias slac1w="slac -S now-1week"
alias slac1d="slac -S now-1day"
alias slac1h="slac -S now-1hour"

function slstat () {
  sstat --format=AveCPU,AveRSS,AveVMSize,MaxRSS,MaxVMSize -j "$@"
}

function nodecount () {
  squeue --me --format='%R' --noheader | sort | uniq -c | sort -bn
}

function partcount () {
  squeue --me --format='%P' --noheader | sort | uniq -c | sort -bn
}

function jobcount () {
  squeue --me --format='%k' --noheader | sort | uniq -c | sort -bn
}

function sqs () {

  # Set colors via ASCII escape sequences by default
  # but this can cause issues so allow escape hatch
  if [[ "${1}" == "bw" ]]
  then
    BLUE=''
    GREEN=''
    RED=''
    NC=''
  else
    BLUE='\033[1;34m'
    GREEN='\033[0;32m'
    RED='\033[0;31m'
    NC='\033[0m' # No Color
  fi

  echo ""
  echo "Status as of $(date '+%F %T (%Z)'):"
  echo ""
  printf "${BLUE}$(sqc)${NC} jobs | ${GREEN}$(sqrc)${NC} running | ${RED}$(sqqc)${NC} queued"
  echo ""
}

function notify_jobs () {
  # Assumes this version of pushover
  # https://github.com/akusei/pushover-bash
  # https://raw.githubusercontent.com/akusei/pushover-bash/main/pushover.sh

  INTERVAL_MINS="${1:-30}" 
  INTERVAL_SECS=$((INTERVAL_MINS * 60))
  echo "Checking in an interval of ${INTERVAL_MINS} minutes"
  
  while [ "$(sqc)" != 0 ]
  do
    echo "Nothing yet! $(date '+%F %T')"
    sleep ${INTERVAL_SECS}
  done

  echo "Done! $(date '+%F %T')"

  test -x "$(command -v pushover)" && pushover -m "Jobs are done on $(hostname)" -T "Cluster"
}

# function install_pushover_bash () {
#   wget https://raw.githubusercontent.com/akusei/pushover-bash/main/pushover.sh -O ~/bin/pushover

#   if [[ ! -f $HOME/.pushover/pushover-config ]]
#   then
#       cat << EOF > $HOME/.pushover/pushover-config
# api_token=
# user_key=
# device=
# url=
# url_title=
# priority=
# title=
# sound=
#       EOF
#   fi
# }

# resource limits https://stackoverflow.com/a/61587377/409362
# alias slimits="sacctmgr list associations"
alias slimits="sacctmgr show assoc account=mallet"

function smax () {
  if [[ -z "$1" ]];
  then
    CLUSTERS="$1"
  fi
  slimits | grep "${CLUSTERS}" | grep "${USER}"
}

function partinfo () {
	sinfo -p mb,wildiris,moran,teton,teton-knl,teton-cascade,teton-hugemem,beartooth,beartooth-bigmem "$@"
}

function btusage () {
	chu_account -Y -a mallet > ~/account_usage.txt && cat ~/account_usage.txt
}

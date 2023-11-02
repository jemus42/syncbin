
alias R="R --quiet --no-save"
# alias tmn="tmux new-session -A -s hpc"
# alias tma="tmux attach -t hpc"

function tmn () {
  if [ -z "${1}" ]
  then
    tmux new-session -A -s hpc
  else
    tmux new-session -A -s "${1}"
  fi
}

function tma () {
  if [ -z "${1}" ]
  then
    tmux attach -t hpc
  else
    tmux attach -t "${1}"
  fi
}


# See https://slurm.schedmd.com/squeue.html
# and https://github.com/mllg/batchtools/blob/1196047ed5115d54bde2923848c1f3ec11fda6d2/R/clusterFunctionsSlurm.R

alias sq="squeue --clusters=$CLUSTERS --me -l --sort=T"
alias sqr="sq --states=R,S,CG,RS,SI,SO,ST"
alias sqq="sq --states=PD,CF,RF,RH,RQ,SE"

alias sqrc="sqr --noheader | wc -l"
alias sqqc="sqq --noheader | wc -l"
alias sqc="sq --noheader | wc -l"

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
  echo "Status as of $(date '+%F %T'):"
  echo ""
  echo "${BLUE}$(sqc)${NC} jobs | ${GREEN}$(sqrc)${NC} running | ${RED}$(sqqc)${NC} queued"
  echo ""
}

function notify_jobs () {
  # Assumes this version of pushover
  # https://github.com/akusei/pushover-bash
  # https://raw.githubusercontent.com/akusei/pushover-bash/main/pushover.sh
  while [ $(sqc) != 0 ]
  do
    echo "Nothing yet! $(date '+%F %T')"
    sleep 1800
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
alias slimits="sacctmgr list associations"

alias smaxrunning="slimits | grep serial | grep ${USER} | awk '{print $6}'"
alias smaxsubmit="slimits | grep serial | grep ${USER} | awk '{print $5}'"

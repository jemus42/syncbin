
alias R="R --quiet --no-save"
alias tmn="tmux new-session -A -s hpc"
alias tma="tmux attach -t hpc"


function sq () { squeue --clusters=$CLUSTERS --me -l --sort=T $@ }
function sqr () { sq --states="R" $@ }
function sqq () { sq --states="PD" $@ }

alias sqc="sq -h | wc -l"
alias sqrc="sq -h --states=R | wc -l"
alias sqqc="sq -h --states=PD | wc -l"

# resource limits https://stackoverflow.com/a/61587377/409362
alias slimits="sacctmgr list associations"

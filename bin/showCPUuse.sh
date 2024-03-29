#! /bin/bash

own=$(id -nu)
cpus=$(lscpu | grep "^CPU(s):" | awk '{print $2}')

echo "CPU usage by user:"
echo ""
echo -e "user\t|\t aggregated usage \t|\t normalized usage"
echo "-------------------------------------------------------------------"

for user in blesch koenen kapar burk wright golchian langbein;
do
    # print other user's CPU usage in parallel but skip own one because
    # spawning many processes will increase our CPU usage significantly
    if [ "$user" = "$own" ]; then continue; fi
    (top -b -n 1 -u "$user" | awk -v user=$user -v CPUS=$cpus -v OFS='\t\t\t' 'NR>7 { sum += $9; } END { if (sum > 0.0) print user, sum, sum/CPUS; }') &
    # don't spawn too many processes in parallel
    sleep 0.05
done
wait

# print own CPU usage after all spawned processes completed
top -b -n 1 -u "$own" | awk -v user=$own -v CPUS=$cpus -v OFS='\t\t\t' 'NR>7 { sum += $9; } END { print user, sum, sum/CPUS; }'

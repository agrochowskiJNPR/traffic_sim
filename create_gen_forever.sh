cat <<EOF >> generate_forever.sh
#!/bin/bash

while true
do
	python generate_new_commands_single_rack.py -i $1
	aos_sim_cli -b sim_traffic.txt
	sleep 10 
done

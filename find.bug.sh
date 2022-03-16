#!/usr/bin/env bash

randrestart0() {
	while true; do
		sleep $(( RANDOM % 10 ))
		docker-compose restart nats-0 2> /dev/null
	done
}
randrestart1() {
	while true; do
		sleep $(( RANDOM % 10 ))
		docker-compose restart nats-1 2> /dev/null
	done
}
randrestart2() {
	while true; do
		sleep $(( RANDOM % 10 ))
		docker-compose restart nats-2 2> /dev/null
	done
}
randrestart0 &
randrestart1 &
randrestart2 &

trap 'kill $(jobs -p)' EXIT

while true; do
	docker-compose exec nats-box sh -c 'nats sub --server=nats-0 --queue=sshportalapi lagoon.sshportal.api > /dev/null & sleep 1; kill %1'
	docker-compose logs nats-0 | grep -F -C 20 '[RS+ $G lagoon.sshportal.api sshportalapi' && break
done
echo found the bug!
echo inspect the logs via: docker-compose logs nats-0

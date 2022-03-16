#!/usr/bin/env bash

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
randrestart1 &
randrestart2 &

while true; do
	docker-compose exec nats-box nats sub --server=nats-0 --queue=sshportalapi lagoon.sshportal.api > /dev/null &
	sleep 1
	docker-compose logs nats-0 | grep -F '[RS+ $G lagoon.sshportal.api sshportalapi' && break
	kill %3
done
kill %1 %2
echo found the bug!
docker-compose logs nats-0 | tail -n 30

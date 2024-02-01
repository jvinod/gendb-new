TARGETS += docker-build-chatdb

docker-build-chatdb:
	docker build -t chatdb .

run-all: stop-all docker-build-chatdb run-db run-chatdb

run-db:
	docker run --net=host -d --name pg-ds-latest aa8y/postgres-dataset:latest

run-db-client:
	docker exec -it pg-ds-latest psql

wait-db:
	echo -n "wating for database "; \
	nc -z localhost 5432 2>/dev/null; \
	while [  $$? -ne 0  ]; do \
		echo -n "..."; \
		sleep 5; \
		nc -z localhost 5432; \
	done; echo; \

run-chatdb: wait-db
	docker run --net=host -it --rm -e OPENAI_API_KEY=${OPENAI_API_KEY} --name chatdb chatdb python ./chatdb.py \
	postgresql+psycopg2://postgres:postgres@localhost:5432/world

run-chatdb-dbg:
	docker run -it --rm -e OPENAI_API_KEY=${OPENAI_API_KEY} --entrypoint /bin/bash --name chatdb chatdb

stop-all:
	-docker stop chatdb && docker rm chatdb
	-docker stop pg-ds-latest && docker rm pg-ds-latest

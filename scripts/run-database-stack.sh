#!/bin/bash
##  Make executable: chmod +x scripts/run-database-stack.sh
### Compose up -d # ./run-database-stack.sh up
### Compose down  # ./run-database-stack.sh down

ACTION=${1:-up}

COMPOSE_FILES=(
  "stacks/database/mariadb.yml"
  "stacks/database/postgres.yml"
  "stacks/database/pgadmin.yml"
  "stacks/database/redis.yml"
)

CMD="docker compose"
for FILE in "${COMPOSE_FILES[@]}"; do
  CMD="$CMD -f $FILE"
done

if [ "$ACTION" = "up" ]; then
  CMD="$CMD up -d"
elif [ "$ACTION" = "down" ]; then
  CMD="$CMD down"
else
  echo "Usage: $0 up|down"
  exit 1
fi

echo "Running: $CMD"
eval $CMD
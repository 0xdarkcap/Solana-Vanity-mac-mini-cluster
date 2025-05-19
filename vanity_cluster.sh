#!/bin/bash

PREFIX=$1
if [ -z "$PREFIX" ]; then
  echo "Usage: $0 <prefix>"
  exit 1
fi

HOSTS=(nock1 nock2 nock3 nock4 nock5 nock6 nock7 nock8 nock9)
REMOTE_SCRIPT="~/vanity_worker.py"
RESULT_FILE="vanity_result_${PREFIX}.txt"

echo "🚀 Starting vanity search for '$PREFIX' across all Mac Minis..."

# Start worker on each node
for HOST in "${HOSTS[@]}"; do
  echo "[*] Launching worker on $HOST"
  ssh "$HOST" "nohup python3 $REMOTE_SCRIPT $PREFIX > /dev/null 2>&1 &"
done

echo "🔎 Monitoring for first match..."

FOUND=0
while [ $FOUND -eq 0 ]; do
  for HOST in "${HOSTS[@]}"; do
    scp "$HOST:$RESULT_FILE" "./$RESULT_FILE" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
      echo "✅ Match found by $HOST!"
      cat "$RESULT_FILE"

      echo "🛑 Terminating all other workers..."
      for OTHER in "${HOSTS[@]}"; do
        ssh "$OTHER" "pkill -f vanity_worker.py"
      done
      FOUND=1
      break
    fi
  done
  sleep 2
done

echo "🎉 Vanity address generation complete!"


#!/bin/bash
set -o errexit -o nounset -o pipefail
command -v shellcheck > /dev/null && shellcheck "$0"

# Choose from https://hub.docker.com/r/cosmwasm/wasmd/tags
REPOSITORY="cosmwasm/wasmd"
VERSION="manual"

TMP_DIR=$(mktemp -d "${TMPDIR:-/tmp}/gaia.XXXXXXXXX")
chmod 777 "$TMP_DIR"
echo "Using temporary dir $TMP_DIR"
WASMD_LOGFILE="$TMP_DIR/wasmd.log"
REST_SERVER_LOGFILE="$TMP_DIR/rest-server.log"
CONTAINER_NAME="wasmd"

# This starts up wasmd
docker volume rm -f wasmd_data
docker run --rm \
  --name "$CONTAINER_NAME" \
  -p 1317:1317 \
  -p 26657:26657 \
  -p 26656:26656 \
  --mount type=bind,source="$(pwd)/template",target=/template \
  --mount type=volume,source=wasmd_data,target=/root \
  "$REPOSITORY:$VERSION" \
  ./run_wasmd.sh /template \
  > "$WASMD_LOGFILE" &

echo "wasmd running and logging into $WASMD_LOGFILE"

sleep 10

if [ "$(docker inspect -f '{{.State.Running}}' "$CONTAINER_NAME")" != "true" ]; then
  echo "Container named '$CONTAINER_NAME' not running. We cannot continue." \
    "This can happen when 'docker run' needs too long to download and start." \
    "It might be worth retrying this step once the image is in the local docker cache."
  exit 1
fi

docker exec "$CONTAINER_NAME" \
  wasmcli rest-server \
  --node tcp://localhost:26657 \
  --trust-node \
  --laddr tcp://0.0.0.0:1317 \
  > "$REST_SERVER_LOGFILE" &

echo "rest server running on http://localhost:1317 and logging into $REST_SERVER_LOGFILE"

HOST="$1"
PORT="$2"

until $(curl --output /dev/null --silent --head --fail http://$HOST:$PORT); do
    printf "Waiting for $HOST:$PORT to be up\n"
    sleep 1
done

# exit when any command fails
set -e

if [ -z "$KOPIA_PASSWORD" ]; then
    echo "Environment variable KOPIA_PASSWORD not set! It is required!" 1>&2
    exit 1
fi

# Check if repository exists; if not, create it
if [ -f /backup/kopia.repository.f ]; then
    echo "Found kopia repository in /backup"
else 
    echo "Didn't find a kopia repository in /backup -- Initializing"
    kopia repository create filesystem --path /backup
fi

kopia repository connect filesystem --path /backup 
kopia server start --ui --insecure --address="http://0.0.0.0:51515"

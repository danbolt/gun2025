# Uploads Linux playtest build to itch via butler

# The machine doing this will need `BUTLER_API_KEY` set via an environment variable.

if [ ! -e automation/linux/butler ]; then
    echo 'butler was not found! Exiting.'
    exit 1
fi

if [ ! -e build/linux/7dfps-2025.x86_64 ]; then
    echo 'Linux build was not found! Exiting.'
    exit 1
fi

automation/linux/butler push build/linux danbolt/7dfps-2025:linux-amd64

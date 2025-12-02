# Uploads Linux playtest build to itch via butler

# The machine doing this will need `BUTLER_API_KEY` set via an environment variable.

if [ ! -e automation/linux/butler ]; then
    echo 'butler was not found! Exiting.'
    exit 1
fi

if [ ! -e build/windows/7dfps-2025.exe ]; then
    echo 'Windows build was not found! Exiting.'
    exit 1
fi

automation/linux/butler push build/windows danbolt/7dfps-2025:windows

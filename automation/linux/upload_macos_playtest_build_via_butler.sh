# Uploads Linux playtest build to itch via butler

# The machine doing this will need `BUTLER_API_KEY` set via an environment variable.

if [ ! -e automation/linux/butler ]; then
    echo 'butler was not found! Exiting.'
    exit 1
fi

if [ ! -e build/macos/7dfps-2025.app ]; then
    echo 'macOS build was not found! Exiting.'
    exit 1
fi

automation/linux/butler push build/macos danbolt/7dfps-2025:mac

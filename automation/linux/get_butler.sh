# Gets butler from itch.io

# Copy/pasted from:
# https://itch.io/docs/butler/installing.html

if [ -e automation/linux/butler ]; then
    echo 'butler already downloaded. Exiting.'
    exit 0
fi

# -L follows redirects
# -O specifies output name
curl -L -o automation/linux/butler.zip https://broth.itch.ovh/butler/linux-amd64/LATEST/archive/default
if [ $? -ne 0 ]; then
	exit 1
fi
unzip -o automation/linux/butler.zip -d automation/linux
# GNU unzip tends to not set the executable bit even though it's set in the .zip
chmod +x automation/linux/butler
# just a sanity check run (and also helpful in case you're sharing CI logs)
./automation/linux/butler -V

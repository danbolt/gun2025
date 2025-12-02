# Gets Godot from official the official sources

godot_binary_name='Godot_v4.5.1-stable_linux.x86_64'
godot_zip_url='https://github.com/godotengine/godot-builds/releases/download/4.5.1-stable/Godot_v4.5.1-stable_linux.x86_64.zip'

if [ -e automation/linux/$godot_binary_name ]; then
    echo $godot_binary_name' already downloaded. Exiting.'
    exit 0
fi

curl -L -o automation/linux/godot.zip $godot_zip_url
if [ $? -ne 0 ]; then
	exit 1
fi
unzip automation/linux/godot.zip -d automation/linux

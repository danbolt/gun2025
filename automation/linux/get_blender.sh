# Gets Blender from its website

blender_tar_name='blender-4.5.1-linux-x64.tar.xz'
blender_tar_url='https://ftp.halifax.rwth-aachen.de/blender/release/Blender4.5/blender-4.5.1-linux-x64.tar.xz'

blender_unzipped_dir="blender/blender-5.0.0-linux-x64"

godot_binary_name='Godot_v4.5-stable_linux.x86_64'

# Install prerequisite xorg stuff
#sudo apt update --assume-yes && sudo apt install xorg blender xz-utils xvfb --assume-yes


if [ ! -e $blender_unzipped_dir ]; then
	tar xf automation/linux/$blender_tar_name -C blender
else
	echo "Blender already unzipped"
fi

blender_path="${PWD}/${blender_unzipped_dir}/blender"
echo "Blender downloaded to: ${blender_path}"

echo "Updating editor settings"

automation/linux/$godot_binary_name -v -e --quit --headless

echo "EDITOR SETTINGS BEFORE ---------------------------------"
cat ~/.config/godot/editor_settings-4.5.tres
echo "-------------------------------------------------------"

# Remove the old blender path
sed -i '/.*rpc_port.*/d' ~/.config/godot/editor_settings-4.5.tres
sed -i '/.*rpc_server_uptime.*/d' ~/.config/godot/editor_settings-4.5.tres
sed -i '/.*blender_path.*/d' ~/.config/godot/editor_settings-4.5.tres

# Add the blender path to the one we downloaded
echo "filesystem/import/blender/blender_path = \"${blender_path}\"" >> ~/.config/godot/editor_settings-4.5.tres
echo "filesystem/import/blender/rpc_port = 6011" >> ~/.config/godot/editor_settings-4.5.tres
echo "filesystem/import/blender/rpc_server_uptime = 500" >> ~/.config/godot/editor_settings-4.5.tres

echo "EDITOR SETTINGS AFTER ---------------------------------"
cat ~/.config/godot/editor_settings-4.5.tres
echo "-------------------------------------------------------"

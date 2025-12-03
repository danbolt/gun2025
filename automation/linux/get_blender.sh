# Gets Blender from its website

blender_tar_name='blender-5.0.0-linux-x64.tar.xz'
blender_tar_url='https://ftp.halifax.rwth-aachen.de/blender/release/Blender5.0/blender-5.0.0-linux-x64.tar.xz'

blender_unzipped_dir="blender/blender-5.0.0-linux-x64"

godot_binary_name='Godot_v4.5.1-stable_linux.x86_64'

# Install prerequisite xorg stuff
#sudo apt update --assume-yes && sudo apt install xorg blender xz-utils xvfb --assume-yes

if [ ! -e automation/linux/$blender_tar_name ]; then
    curl -L -o automation/linux/$blender_tar_name $blender_tar_url
else
	echo "Blender already downloaded"
fi

if [ ! -e $blender_unzipped_dir ]; then
	tar xf automation/linux/$blender_tar_name -C blender
else
	echo "Blender already unzipped"
fi

blender_path="${PWD}/${blender_unzipped_dir}/blender"
echo "Blender downloaded to: ${blender_path}"


# Exports the windows playtest build

godot_binary_name='Godot_v4.5.1-stable_linux.x86_64'
export_templates_folder_name='4.5.1.stable'

if [ ! -e automation/linux/$godot_binary_name ]; then
    echo $godot_binary_name' Not found! Exiting.'
    exit 1
fi

if [ ! -e ~/.local/share/godot/export_templates/$export_templates_folder_name ]; then
    echo 'Export templates not found! exiting'
    exit 1
fi

sha_head=$(git rev-parse --short HEAD)

mkdir -p build/windows

automation/linux/$godot_binary_name --headless --export-debug "7dfps-2025-windows" build/windows/7dfps-2025.exe

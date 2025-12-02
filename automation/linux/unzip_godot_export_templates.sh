# Unzips the Godot export templates

export_templates_name='Godot_v4.5.1-stable_export_templates.tpz'
export_templates_folder_name='4.5.1.stable'

if [ -e ~/.local/share/godot/export_templates/$export_templates_folder_name ]; then
    echo $export_templates_name' already unzipped. Exiting.'
    exit 0
fi

# For some reason, we have to put export templates in a specific folder.
# I wish I could have specified this on export.
mkdir -v -p ~/.local/share/godot/export_templates/
mkdir -v -p ~/.local/share/godot/export_templates/$export_templates_folder_name

unzip -n export_templates/$export_templates_name -d  ~/.local/share/godot/export_templates/$export_templates_folder_name
mv ~/.local/share/godot/export_templates/$export_templates_folder_name/templates/* ~/.local/share/godot/export_templates/$export_templates_folder_name
rm -r ~/.local/share/godot/export_templates/$export_templates_folder_name/templates

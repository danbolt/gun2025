# Gets Godot export templates from official the official sources

export_templates_name='Godot_v4.5.1-stable_export_templates.tpz'
export_templates_url='https://github.com/godotengine/godot/releases/download/4.5.1-stable/Godot_v4.5.1-stable_export_templates.tpz'

if [ -e export_templates/$export_templates_name ]; then
    echo $export_templates_name' already downloaded. Exiting.'
    exit 0
fi

curl -L -o export_templates/$export_templates_name $export_templates_url
if [ $? -ne 0 ]; then
	exit 1
fi

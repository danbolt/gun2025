# Does everything on one workstation, assuming butler is properly set up

automation/linux/clean_old_builds.sh
automation/linux/export_linux_playtest.sh 
if [ $? -ne 0 ]; then
	echo "Error building the Linux version"
	exit 1
fi
automation/linux/export_windows_playtest.sh 
if [ $? -ne 0 ]; then
	echo "Error building the Windows version"
	exit 1
fi
automation/linux/export_macos_playtest.sh 
if [ $? -ne 0 ]; then
	echo "Error building the macOS version"
	exit 1
fi
automation/linux/upload_linux_playtest_build_via_butler.sh
automation/linux/upload_windows_playtest_build_via_butler.sh
automation/linux/upload_macos_playtest_build_via_butler.sh

echo -e "🎉 We're done! 🎉"

#!/bin/bash
#3 April 2025 v1.0


# Create a directory where all files used by desktop shortcuts created by Cormorant will be stored
mkdir -p "$HOME/.cormorant"

# Run yad and capture its output
inputData=$(yad --title="Cormorant" --class="Cormorant" --window-icon="/home/dominik/.cormorant/cormorant.png" --center --form \
    --field="App Name" \
    --field=" ":LBL \
    --field="Icon File":FL \
    --field="File to run":FL \
    --field="Description(optional)":TXT \
    --field="Copy files insted of moving":CHK \
    --field="no WMClass":CHK \
    --field="If WMClass is not checked, will Cormorant will launch the app and ask you to click on it to get it's WMClass for ehanced user experience\nIf creation of the shortcut fails, try again with this field checked":LBL)

# Check if user clicked Cancel (empty output)
if [ -z "$inputData" ]; then
    echo "User canceled the operation."
    exit 1
fi

# Read the data

IFS="|" read -r -a blabla <<< "$inputData"

appImageName="${blabla[0]}"
iconPath="${blabla[2]}"
appImagePath="${blabla[3]}"
descriptionText="${blabla[4]}\nShortcut created with Cormorant."

# Move the files somewhere where they'll less likely to be tampered with, and to have them in one place

appImageFilename=$(basename "$appImagePath")
iconFilename=$(basename "$iconPath")

# default option
if [[ "${blabla[5]}" == "FALSE" ]]; then
    mv "$appImagePath" "$HOME/.cormorant/"
    mv "$iconPath" "$HOME/.cormorant/"
fi

# If copy option was chosen
if [[ "${blabla[5]}" == "TRUE"]]; then
    cp "$appImagePath" "$HOME/.cormorant/"
    cp "$iconPath" "$HOME/.cormorant/"
fi

staticAppImagePath="$HOME/.cormorant/$appImageFilename"
staticIconPath="$HOME/.cormorant/$iconFilename"

chmod a+x "$staticAppImagePath"

# Check if user requested an WMClass to be specified for enhanced user experience
if [[ "${blabla[6]}" == "FALSE" ]]; then
# Validate the AppImage file
if [ ! -f "$staticAppImagePath" ] || [[ ! "$staticAppImagePath" =~ \.AppImage$ ]]; then
    echo "Error: '$appImagePath' is not a valid AppImage file."
    exit 1
fi
# Ensure the AppImage is executable
if [ ! -x "$staticAppImagePath" ]; then
    echo "Making '$staticAppImagePath' executable..."
    chmod a+x "$staticAppImagePath"
fi
# Check if xprop is installed
if ! command -v xprop >/dev/null 2>&1; then
    echo "Error: 'xprop' is not installed. Install it with 'sudo apt install x11-utils'."
    exit 1
fi

# Launch the AppImage in the background
"$staticAppImagePath" &
APP_PID=$!  # Store the process ID
# Give the app a moment to start
sleep 2

notify-send -t 5000 "Click the AppImage opened by Cormorant"
WM_CLASS=$(xprop WM_CLASS | awk -F'"' '{print $4}')

if [ -z "$WM_CLASS" ]; then
    echo "Error: Failed to detect WM_CLASS. Did you click the window?"
    exit 1
fi

# Kill the app
kill $APP_PID 2>/dev/null


# Create a .desktop file content
desktopFile=$(cat <<EOF
[Desktop Entry]
Name=$appImageName
Exec=$staticAppImagePath
Type=Application
Icon=$staticIconPath
StartupWMClass=$WM_CLASS
Description=$descriptionText
EOF
)
fi

# If user decided to not have WMClass specyfied (for various reasones)
if [[ "${blabla[6]}" == "TRUE" ]]; then

# Create a .desktop file content
desktopFile=$(cat <<EOF
[Desktop Entry]
Name=$appImageName
Exec=$staticAppImagePath
Type=Application
Icon=$staticIconPath
Description=$descriptionText
EOF
)
fi

# Accually create a .desktop file
echo "$desktopFile" > "$HOME/.local/share/applications/${appImageName}.desktop"
chmod a+x "$HOME/.local/share/applications/${appImageName}.desktop"

update-desktop-database "$HOME/.local/share/applications/"

notify-send -t 5000 "$appImageName.desktop file was created"

exit 0

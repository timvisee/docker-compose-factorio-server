#!/bin/bash

# Define some constants
FACTORIO_BIN=/opt/factorio/bin/x64/factorio
MOUNT_DIR=/factorio
CONFIG_DIR=$MOUNT_DIR/config
SAVES_DIR=$MOUNT_DIR/saves
MODS_DIR=$MOUNT_DIR/mods
SERVER_SETTINGS_FILE=$CONFIG_DIR/server-settings.json
MAP_GEN_SETTINGS_FILE=$CONFIG_DIR/map-gen-settings.json
MAP_SETTINGS_FILE=$CONFIG_DIR/map-settings.json
MAP_FILE=$SAVES_DIR/map.zip

echo "Initializing Factorio server..."

# Make sure the mount directory is mounted
if [ ! -d "$MOUNT_DIR" ]; then
    echo "Factorio directory not mounted, quitting."
    echo "Please mount to the '/factorio' directory to start the server."
    exit 1
fi

# Make sure the desired directories and configurations are available
if [ ! -d "$CONFIG_DIR" ]; then
    echo "Creating config directory..."
    mkdir "$CONFIG_DIR"
fi
if [ ! -f "$SERVER_SETTINGS_FILE" ]; then
    echo "Creating server settings file..."
    cp /opt/factorio/data/server-settings.example.json $SERVER_SETTINGS_FILE
fi
if [ ! -f "$MAP_GEN_SETTINGS_FILE" ]; then
    echo "Creating map generator settings file..."
    cp /opt/factorio/data/map-gen-settings.example.json $MAP_GEN_SETTINGS_FILE
fi
if [ ! -f "$MAP_SETTINGS_FILE" ]; then
    echo "Creating map settings file..."
    cp /opt/factorio/data/map-settings.example.json $MAP_SETTINGS_FILE
fi
if [ ! -d "$SAVES_DIR" ]; then
    echo "Creating saves directory..."
    mkdir "$SAVES_DIR"
fi
if [ ! -d "$MODS_DIR" ]; then
    echo "Creating mods directory..."
    mkdir "$MODS_DIR"
fi

# Link the saves and mods folder to the user mounted volume
if [ ! -e "/opt/factorio/saves" ]; then
    echo "Linking saves directory..."
    ln -s /factorio/saves /opt/factorio/saves
fi
if [ ! -e "/opt/factorio/mods" ]; then
    echo "Linking mods directory..."
    ln -s /factorio/mods /opt/factorio/mods
fi

# Generate a map if it doesn't exist
if [ ! -f "$MAP_FILE" ]; then
    echo "Map doesn't exist, generating..."

    # Generate the map
    $FACTORIO_BIN --create $MAP_FILE --server-settings $SERVER_SETTINGS_FILE --map-gen-settings $MAP_GEN_SETTINGS_FILE --map-settings $MAP_SETTINGS_FILE
fi

# Start the server, with the latest available save
echo "Starting Factorio server..."
exec $FACTORIO_BIN --start-server-load-latest --server-settings $SERVER_SETTINGS_FILE --map-gen-settings $MAP_GEN_SETTINGS_FILE --map-settings $MAP_SETTINGS_FILE
echo "Factorio server stopped!"

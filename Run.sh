#!/bin/bash

errors() {
    local error_code=$?
    if [ $error_code -eq 0 ]; then
        echo -e "\nExecuted succesfuly"
    else
        echo "Some error ocured..."
    fi
}


# Set the output binary name
OUTPUT_BINARY="game"

# Set scripts location
SCRIPTS_LOCATION="scripts"

# Set bin location
BIN_FILES_LOCATION="bin"

# Compile the source file
./"$SCRIPTS_LOCATION"/compile.sh

# Check if the compilation was successful
if [ $? -eq 0 ]; then
    if [ -f "$BIN_FILES_LOCATION/$OUTPUT_BINARY" ]; then
        echo -e "\nRunning the program with args: $@\n"
        ./"$BIN_FILES_LOCATION/$OUTPUT_BINARY" "$@"
        errors
    else
        echo "Error: Compiled binary '$BIN_FILES_LOCATION/$OUTPUT_BINARY' not found!"
        exit 1
    fi
else
    echo "Compilation failed. The program will not be run."
    exit 1
fi

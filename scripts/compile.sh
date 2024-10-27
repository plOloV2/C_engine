#!/bin/bash

comp_time() {
    local start=${EPOCHREALTIME/./}
    "$@"
    local exit_code=$?
    echo >&2 "Took ~$(( (${EPOCHREALTIME/./} - start)/1000 )) ms."
    return ${exit_code}
}

check_dependencies() {
    for file in "${DEPEN_FILES[@]}"; do
        if [[ ! -f "$LIB_FILES_LOCATION/$file" ]]; then
            echo "Error: Dependency $file not found in $LIB_FILES_LOCATION."
            return 1
        fi
    done
    return 0
}

# Set file locations
SOURCE_FILES_LOCATION="src"
BIN_FILES_LOCATION="bin"
LIB_FILES_LOCATION="lib"

# Set compiling flags for gcc
FLAGS=(-fopenmp -lglfw -lvulkan)

# Set the source file and output binary names
SOURCE_FILE="main.c"
DEPEN_FILES=()
OUTPUT_BINARY="game"

# Check source file is present
if [ ! -f "$SOURCE_FILES_LOCATION/$SOURCE_FILE" ]; then
    echo "Error: Source file '$SOURCE_FILE' not found!"
    exit 1
fi

# Check dependencies
if check_dependencies; then
    echo "All dependencies are present. Compiling..."

    mkdir -p "$BIN_FILES_LOCATION"

    # Compile the source file
    echo "Compiling program with flags: ${FLAGS[@]}"
    comp_time gcc "$SOURCE_FILES_LOCATION/$SOURCE_FILE" -o "$BIN_FILES_LOCATION/$OUTPUT_BINARY" "$LIB_FILES_LOCATION/"*.h "${FLAGS[@]}"
else
    echo "Compilation aborted due to missing dependencies."
    exit 1
fi

# Check if the compilation was successful
if [ $? -eq 0 ]; then
    echo "Compilation successful. Output binary is: $OUTPUT_BINARY"
else
    echo "Compilation failed."
    exit 1
fi

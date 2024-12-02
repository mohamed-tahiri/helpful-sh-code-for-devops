#!/bin/bash

# Function to check version compatibility
check_version() {
    local PHP_VERSION=$1
    local MIN_VERSION=$2
    local MAX_VERSION=$3

    if [[ "$(printf '%s\n' "$PHP_VERSION" "$MIN_VERSION" | sort -V | head -n1)" != "$MIN_VERSION" ]]; then
        echo "❌ PHP version $PHP_VERSION is too low. Minimum required: $MIN_VERSION."
        exit 1
    fi

    if [[ "$(printf '%s\n' "$PHP_VERSION" "$MAX_VERSION" | sort -V | tail -n1)" != "$MAX_VERSION" ]]; then
        echo "❌ PHP version $PHP_VERSION is too high. Maximum supported: $MAX_VERSION."
        exit 1
    fi

    echo "✅ PHP version $PHP_VERSION is compatible with Drupal $DRUPAL_VERSION."
}

# Check if required arguments are provided
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <PHP_VERSION> <DRUPAL_VERSION>"
    echo "Example: $0 8.1 10.1"
    exit 1
fi

# Input arguments
PHP_VERSION=$1
DRUPAL_VERSION=$2

# Define compatibility ranges
declare -A COMPATIBILITY_RANGES
COMPATIBILITY_RANGES["9.5"]="7.4.0 8.1.99"
COMPATIBILITY_RANGES["10.0"]="8.1.0 8.2.99"
COMPATIBILITY_RANGES["10.1"]="8.1.0 8.3.99"

# Check compatibility for the provided Drupal version
if [[ -n "${COMPATIBILITY_RANGES[$DRUPAL_VERSION]}" ]]; then
    RANGE=${COMPATIBILITY_RANGES[$DRUPAL_VERSION]}
    MIN_VERSION=$(echo $RANGE | cut -d' ' -f1)
    MAX_VERSION=$(echo $RANGE | cut -d' ' -f2)

    echo "ℹ️ Checking PHP version $PHP_VERSION for Drupal $DRUPAL_VERSION..."
    check_version "$PHP_VERSION" "$MIN_VERSION" "$MAX_VERSION"
else
    echo "❌ Compatibility range for Drupal $DRUPAL_VERSION is not defined."
    exit 1
fi


#!/bin/bash

# Function to check compatibility
check_sylius_compatibility() {
    local PHP_VERSION=$1
    local SYLIUS_VERSION=$2

    # Define compatibility ranges for Sylius
    case $SYLIUS_VERSION in
        1.12.*)
            MIN_PHP="8.1"
            MAX_PHP="8.2"
            ;;
        1.11.*)
            MIN_PHP="8.0"
            MAX_PHP="8.1"
            ;;
        1.10.*)
            MIN_PHP="7.4"
            MAX_PHP="8.0"
            ;;
        1.9.*)
            MIN_PHP="7.3"
            MAX_PHP="7.4"
            ;;
        *)
            echo "⚠️ Unsupported Sylius version: $SYLIUS_VERSION"
            exit 1
            ;;
    esac

    # Check minimum version
    if [[ "$(printf '%s\n' "$PHP_VERSION" "$MIN_PHP" | sort -V | head -n1)" != "$MIN_PHP" ]]; then
        echo "❌ PHP version $PHP_VERSION is too low for Sylius $SYLIUS_VERSION. Minimum required: $MIN_PHP."
        exit 1
    fi

    # Check maximum version
    if [[ "$(printf '%s\n' "$PHP_VERSION" "$MAX_PHP" | sort -V | tail -n1)" != "$MAX_PHP" ]]; then
        echo "❌ PHP version $PHP_VERSION is too high for Sylius $SYLIUS_VERSION. Maximum supported: $MAX_PHP."
        exit 1
    fi

    echo "✅ PHP version $PHP_VERSION is compatible with Sylius $SYLIUS_VERSION."
}

# Check arguments
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <PHP_VERSION> <SYLIUS_VERSION>"
    echo "Example: $0 8.1 1.12.0"
    exit 1
fi

# Input arguments
PHP_VERSION=$1
SYLIUS_VERSION=$2

# Check compatibility
check_sylius_compatibility "$PHP_VERSION" "$SYLIUS_VERSION"


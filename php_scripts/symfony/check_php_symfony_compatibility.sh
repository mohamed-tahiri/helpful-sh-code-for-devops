#!/bin/bash

# Function to check compatibility
check_symfony_compatibility() {
    local PHP_VERSION=$1
    local SYMFONY_VERSION=$2

    # Define compatibility ranges for Symfony
    case $SYMFONY_VERSION in
        6.3.*)
            MIN_PHP="8.1"
            MAX_PHP="8.3"
            ;;
        6.2.*)
            MIN_PHP="8.0.2"
            MAX_PHP="8.2"
            ;;
        6.1.*)
            MIN_PHP="8.0.2"
            MAX_PHP="8.2"
            ;;
        6.0.*)
            MIN_PHP="8.0.2"
            MAX_PHP="8.1"
            ;;
        5.4.*)
            MIN_PHP="7.2.5"
            MAX_PHP="8.1"
            ;;
        5.3.*)
            MIN_PHP="7.2.5"
            MAX_PHP="8.0"
            ;;
        *)
            echo "⚠️ Unsupported Symfony version: $SYMFONY_VERSION"
            exit 1
            ;;
    esac

    # Check minimum version
    if [[ "$(printf '%s\n' "$PHP_VERSION" "$MIN_PHP" | sort -V | head -n1)" != "$MIN_PHP" ]]; then
        echo "❌ PHP version $PHP_VERSION is too low for Symfony $SYMFONY_VERSION. Minimum required: $MIN_PHP."
        exit 1
    fi

    # Check maximum version
    if [[ "$(printf '%s\n' "$PHP_VERSION" "$MAX_PHP" | sort -V | tail -n1)" != "$MAX_PHP" ]]; then
        echo "❌ PHP version $PHP_VERSION is too high for Symfony $SYMFONY_VERSION. Maximum supported: $MAX_PHP."
        exit 1
    fi

    echo "✅ PHP version $PHP_VERSION is compatible with Symfony $SYMFONY_VERSION."
}

# Check arguments
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <PHP_VERSION> <SYMFONY_VERSION>"
    echo "Example: $0 8.1 6.3.0"
    exit 1
fi

# Input arguments
PHP_VERSION=$1
SYMFONY_VERSION=$2

# Check compatibility
check_symfony_compatibility "$PHP_VERSION" "$SYMFONY_VERSION"


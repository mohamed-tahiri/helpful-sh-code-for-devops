#!/bin/bash

# Function to check compatibility
check_prestashop_compatibility() {
    local PHP_VERSION=$1
    local PS_VERSION=$2

    # Define compatibility ranges for PrestaShop
    case $PS_VERSION in
        8.*)
            MIN_PHP="7.4"
            MAX_PHP="8.2"
            ;;
        1.7.*)
            MIN_PHP="5.6"
            MAX_PHP="8.1"
            ;;
        1.6.*)
            MIN_PHP="5.2"
            MAX_PHP="7.0"
            ;;
        *)
            echo "⚠️ Unsupported PrestaShop version: $PS_VERSION"
            exit 1
            ;;
    esac

    # Check minimum version
    if [[ "$(printf '%s\n' "$PHP_VERSION" "$MIN_PHP" | sort -V | head -n1)" != "$MIN_PHP" ]]; then
        echo "❌ PHP version $PHP_VERSION is too low for PrestaShop $PS_VERSION. Minimum required: $MIN_PHP."
        exit 1
    fi

    # Check maximum version
    if [[ "$(printf '%s\n' "$PHP_VERSION" "$MAX_PHP" | sort -V | tail -n1)" != "$MAX_PHP" ]]; then
        echo "❌ PHP version $PHP_VERSION is too high for PrestaShop $PS_VERSION. Maximum supported: $MAX_PHP."
        exit 1
    fi

    echo "✅ PHP version $PHP_VERSION is compatible with PrestaShop $PS_VERSION."
}

# Check arguments
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <PHP_VERSION> <PS_VERSION>"
    echo "Example: $0 7.4 1.7.8"
    exit 1
fi

# Input arguments
PHP_VERSION=$1
PS_VERSION=$2

# Check compatibility
check_prestashop_compatibility "$PHP_VERSION" "$PS_VERSION"


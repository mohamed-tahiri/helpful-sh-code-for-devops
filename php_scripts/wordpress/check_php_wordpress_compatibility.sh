#!/bin/bash

# Function to check compatibility
check_wordpress_compatibility() {
    local PHP_VERSION=$1
    local WP_VERSION=$2

    # Define compatibility ranges for WordPress
    case $WP_VERSION in
        6.*)
            MIN_PHP="7.4"
            MAX_PHP="8.3"
            ;;
        5.*)
            MIN_PHP="5.6"
            MAX_PHP="8.1"
            ;;
        4.*)
            MIN_PHP="5.2.4"
            MAX_PHP="7.4"
            ;;
        *)
            echo "⚠️ Unsupported WordPress version: $WP_VERSION"
            exit 1
            ;;
    esac

    # Check minimum version
    if [[ "$(printf '%s\n' "$PHP_VERSION" "$MIN_PHP" | sort -V | head -n1)" != "$MIN_PHP" ]]; then
        echo "❌ PHP version $PHP_VERSION is too low for WordPress $WP_VERSION. Minimum required: $MIN_PHP."
        exit 1
    fi

    # Check maximum version
    if [[ "$(printf '%s\n' "$PHP_VERSION" "$MAX_PHP" | sort -V | tail -n1)" != "$MAX_PHP" ]]; then
        echo "❌ PHP version $PHP_VERSION is too high for WordPress $WP_VERSION. Maximum supported: $MAX_PHP."
        exit 1
    fi

    echo "✅ PHP version $PHP_VERSION is compatible with WordPress $WP_VERSION."
}

# Check arguments
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <PHP_VERSION> <WP_VERSION>"
    echo "Example: $0 8.1 6.3"
    exit 1
fi

# Input arguments
PHP_VERSION=$1
WP_VERSION=$2

# Check compatibility
check_wordpress_compatibility "$PHP_VERSION" "$WP_VERSION"


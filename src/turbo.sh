#!/bin/bash

version='1.0'

function print_help {
    printf "Usage: $(basename $0) [OPTION]\n"
    printf "Enable or disable Intel Turbo Boost Technology. Please run this script as root.\n\n"
    printf "Mandatory arguments to long options are mandatory for short options too.\n"
    printf "  -d, --disable\t\tenable turbo boost\n"
    printf "  -e, --enable\t\tenable turbo boost\n"
    printf "  -h, --help\t\tdisplay this help and exit\n"
    printf "  -s, --status\t\tprint current turbo boost statust\n"
    printf "  -v, --version\t\toutput version information and exit\n"
}

function print_version {
    printf "Version:\t$version\n"
    printf "Copyright:\t(c) 2015 Jakub Leško.\n"
    printf "License:\tThe MIT License (MIT).\n"
}

function print_status {
    turbo_status=$(cat /sys/devices/system/cpu/intel_pstate/no_turbo)

    if [[ $turbo_status -eq 1 ]]
    then
        printf "INFO: Intel Turbo boost is disabled.\n"
    else
        printf "INFO: Intel Turbo boost is enabled.\n"
    fi
}

function check_user {
    user=$(whoami)

    if [[ $user != 'root' ]]
    then
        printf "ERROR: Root permissions are missing!\n" >&2
        exit 1
    fi
}

if [[ $# -eq 0 ]]
then
    printf "WARNING: Missing argument(s)!\n\n" >&2
    print_help
    exit 1
fi

case $1 in
    '-e' | '--enable')
        check_user
        echo -n 0 > /sys/devices/system/cpu/intel_pstate/no_turbo
        print_status
        ;;
    '-d' | '--disable')
        check_user
        echo -n 1 > /sys/devices/system/cpu/intel_pstate/no_turbo
        print_status
        ;;
    '-s' | '--status')
        print_status
        ;;
    '-h' | '--help')
        print_help
        ;;
    '-v' | '--version')
        print_version
        ;;
    *)
        printf "WARNING: Unknown argument(s)!\n\n" >&2
        print_help
        exit 1
esac

#!/bin/bash

if [ "$1" == "-h" -o "$1" == "--help" ]; then
    echo "USAGE: $0 [--skip-codegen]"
    exit 0
fi

if [ "$1" != "--skip-codegen" ]; then
    pub run build_runner build || exit 1
fi

pub run test lib/main.dart || exit 1

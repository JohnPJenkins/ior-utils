#!/bin/bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd "$script_dir"

../replace_many.sh FILE_PER_PROC 0 1 < ior_example.conf | \
    ../replace_many.sh XFER_SIZE 8 16 32

#!/bin/bash

# Assume some initial values for demonstration
param1="$1"
param2="$2"
param3="$3"

echo "Before shift: param1=$param1, param2=$param2, param3=$param3"

# Shift 2 positions to the left
shift 2

echo "After shift: param1=$1, param2=$2, param3=$3"

# usage
# ./script.sh value1 value2 value3

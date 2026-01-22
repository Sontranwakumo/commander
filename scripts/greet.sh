#!/bin/bash
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"
parse_args "$@"
name=${name:-"Người dùng"}
[ "${lang:-vi}" = "en" ] && echo "Hello, $name! Welcome to Commander system." || echo "Xin chào, $name! Chào mừng đến với hệ thống Commander."

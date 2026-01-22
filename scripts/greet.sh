#!/bin/bash

# Script chào hỏi người dùng
# Sử dụng: ./greet.sh name="Tên" lang="vi"

# Parse arguments
for arg in "$@"; do
  key=$(echo $arg | cut -d'=' -f1)
  value=$(echo $arg | cut -d'=' -f2 | tr -d '"')
  eval "$key=$value"
done

# Default values
name=${name:-"Người dùng"}
lang=${lang:-"vi"}

if [ "$lang" = "en" ]; then
  echo "Hello, $name! Welcome to Commander system."
else
  echo "Xin chào, $name! Chào mừng đến với hệ thống Commander."
fi

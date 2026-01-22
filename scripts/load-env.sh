load_env() {
  while IFS= read -r line || [ -n "$line" ]; do
    line="${line%%#*}" && line="${line#"${line%%[![:space:]]*}"}" && line="${line%"${line##*[![:space:]]}"}"
    [[ "$line" =~ ^[a-zA-Z_][a-zA-Z0-9_]*= ]] && export "$line"
  done < "$1"
}

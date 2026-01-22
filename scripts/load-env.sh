
load_env() {
    local file="$1"
    [ ! -f "$file" ] && { echo "File không tồn tại: $file"; return 1; }
    while IFS= read -r line || [ -n "$line" ]; do
        # Xóa khoảng trắng đầu/cuối bằng Bash nội tại
        line="${line#${line%%[![:space:]]*}}"
        line="${line%${line##*[![:space:]]}}"

        # Skip dòng rỗng hoặc comment
        [[ -z "$line" || "$line" == \#* ]] && continue

        # Cắt bỏ phần comment phía sau
        keyval="${line%%#*}"
        # Xóa khoảng trắng sau khi cắt comment
        keyval="${keyval%${keyval##*[![:space:]]}}"

        if [[ "$keyval" =~ ^[a-zA-Z_][a-zA-Z0-9_]*= ]]; then
            export "$keyval"
        fi
    done < "$file"
}

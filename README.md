# Commander - Hệ thống thực thi lệnh custom

Hệ thống cho phép thực hiện các lệnh custom của hệ thống thông qua một câu lệnh duy nhất.

## Cài đặt

### Bước 1: Cài đặt dependencies
```bash
npm install
```

### Bước 2: Thêm vào PATH trong .zshrc

Mở file `.zshrc` trong thư mục home của bạn:
```bash
nano ~/.zshrc
# hoặc
vim ~/.zshrc
# hoặc
code ~/.zshrc  # nếu dùng VS Code
```

Thêm dòng sau vào cuối file `.zshrc`:
```bash
# Commander - Custom command executor
export PATH="$PATH:/Users/artteiv/Desktop/Workspace/commander"
```

**Lưu ý:** Thay `/Users/artteiv/Desktop/Workspace/commander` bằng đường dẫn tuyệt đối đến thư mục dự án của bạn.

Sau đó, reload cấu hình zsh:
```bash
source ~/.zshrc
```

Hoặc đơn giản mở terminal mới. Bây giờ bạn có thể sử dụng lệnh `commander` từ bất kỳ đâu!

### Cách khác: Sử dụng npm link (tùy chọn)
```bash
npm link  # Tạo symlink global
```

## Cấu trúc dự án

```
commander/
├── index.js          # File main xử lý lệnh
├── config.json       # File cấu hình các lệnh
├── package.json      # Dependencies và bin command
├── scripts/          # Thư mục chứa các file shell
│   ├── greet.sh
│   ├── backup.sh
│   └── deploy.sh
└── README.md
```

## Cách sử dụng

### Pattern chung
```bash
commander <doSomething> <flag> ...
```

### Ví dụ

#### 1. Lệnh greet (chào hỏi)
```bash
commander greet --name "Nguyễn Văn A" --lang vi
commander greet --name "John Doe" --lang en
```

#### 2. Lệnh backup (sao lưu)
```bash
commander backup --source "/path/to/source" --destination "/path/to/backup"
commander backup --source "/path/to/source"  # Sử dụng destination mặc định
```

#### 3. Lệnh deploy (triển khai)
```bash
commander deploy --env prod --version "1.0.0"
commander deploy --env dev
```

### Xem danh sách lệnh
```bash
commander --help
```

### Xem chi tiết một lệnh
```bash
commander <command> --help
```

## Cấu hình

File `config.json` chứa cấu hình cho tất cả các lệnh:

```json
{
  "commands": {
    "commandName": {
      "script": "scripts/script.sh",
      "description": "Mô tả lệnh",
      "flags": {
        "flagName": {
          "required": true/false,
          "default": "giá trị mặc định",
          "description": "Mô tả flag"
        }
      }
    }
  }
}
```

## Thêm lệnh mới

1. Tạo file shell script trong thư mục `scripts/`
2. Thêm cấu hình vào `config.json` trong phần `commands`
3. Đảm bảo file script có quyền thực thi: `chmod +x scripts/your-script.sh`

## Lưu ý

- Các file shell script phải có quyền thực thi
- Flags bắt buộc phải được cung cấp khi gọi lệnh
- Scripts nhận flags dưới dạng `key="value"` và tự parse

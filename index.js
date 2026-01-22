#!/usr/bin/env node

import { Command } from 'commander';
import { readFileSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';
import { execSync } from 'child_process';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Đọc file config
function loadConfig() {
  try {
    const configPath = join(__dirname, 'config.json');
    const configContent = readFileSync(configPath, 'utf-8');
    return JSON.parse(configContent);
  } catch (error) {
    console.error('Lỗi khi đọc file config:', error.message);
    process.exit(1);
  }
}

// Thực thi script shell
function executeScript(scriptPath, flags, commandConfig) {
  try {
    const fullPath = join(__dirname, scriptPath);

    // Tạo chuỗi arguments từ flags
    const args = Object.entries(flags)
      .map(([key, value]) => {
        // Kiểm tra nếu là boolean flag
        const flagConfig = commandConfig.flags?.[key];
        const isBoolean = flagConfig?.boolean === true;

        if (isBoolean) {
          // Boolean flag: chỉ truyền tên flag nếu giá trị là true
          if (value === true) {
            return key;
          }
          return '';
        } else {
          // Flag có value
          if (value !== undefined && value !== null) {
            return `${key}="${value}"`;
          }
          return '';
        }
      })
      .filter(arg => arg !== '')
      .join(' ');

    // Thực thi script với các flags
    const command = args ? `${fullPath} ${args}` : fullPath;
    execSync(command, {
      stdio: 'inherit',
      cwd: __dirname
    });
  } catch (error) {
    console.error(`Lỗi khi thực thi script: ${error.message}`);
    process.exit(1);
  }
}

// Validate flags theo config
function validateFlags(commandConfig, providedFlags) {
  const errors = [];
  const validatedFlags = {};

  // Kiểm tra flags bắt buộc
  if (commandConfig.flags) {
    for (const [flagName, flagConfig] of Object.entries(commandConfig.flags)) {
      if (flagConfig.required && !providedFlags[flagName]) {
        errors.push(`Flag '--${flagName}' là bắt buộc`);
      } else if (providedFlags[flagName]) {
        validatedFlags[flagName] = providedFlags[flagName];
      } else if (flagConfig.default !== undefined) {
        validatedFlags[flagName] = flagConfig.default;
      }
    }
  }

  if (errors.length > 0) {
    console.error('Lỗi validation:');
    errors.forEach(error => console.error(`  - ${error}`));
    process.exit(1);
  }

  return validatedFlags;
}

// Main program
const config = loadConfig();
const program = new Command();

program
  .name('commander')
  .description('Hệ thống thực thi lệnh custom')
  .version('1.0.0');

// Đăng ký các lệnh từ config
for (const [commandName, commandConfig] of Object.entries(config.commands)) {
  const cmd = program
    .command(commandName)
    .description(commandConfig.description || `Thực thi lệnh ${commandName}`);

  // Thêm các flags từ config
  if (commandConfig.flags) {
    for (const [flagName, flagConfig] of Object.entries(commandConfig.flags)) {
      // Bỏ qua flag rỗng hoặc không hợp lệ
      if (!flagName || flagName.trim() === '') {
        continue;
      }

      // Kiểm tra nếu là boolean flag (không cần value)
      const isBoolean = flagConfig.boolean === true;

      // Tạo option string với short flag nếu có
      let flagOption;
      if (isBoolean) {
        // Boolean flag không cần value
        if (flagConfig.short) {
          flagOption = `-${flagConfig.short}, --${flagName}`;
        } else {
          flagOption = `--${flagName}`;
        }
        cmd.option(flagOption, flagConfig.description || '');
      } else {
        // Flag có value
        if (flagConfig.short) {
          flagOption = flagConfig.required
            ? `-${flagConfig.short}, --${flagName} <value>`
            : `-${flagConfig.short}, --${flagName} [value]`;
        } else {
          flagOption = flagConfig.required
            ? `--${flagName} <value>`
            : `--${flagName} [value]`;
        }
        cmd.option(flagOption, flagConfig.description || '');
      }
    }
  }

  // Action để thực thi script
  cmd.action((options) => {
    const validatedFlags = validateFlags(commandConfig, options);
    executeScript(commandConfig.script, validatedFlags, commandConfig);
  });
}

// Xử lý lệnh không tồn tại
program.on('command:*', () => {
  console.error(`Lệnh không hợp lệ: ${program.args.join(' ')}`);
  console.error('Sử dụng --help để xem danh sách lệnh có sẵn');
  process.exit(1);
});

// Parse arguments
program.parse(process.argv);

// Hiển thị help nếu không có lệnh nào được cung cấp
if (!process.argv.slice(2).length) {
  program.outputHelp();
}

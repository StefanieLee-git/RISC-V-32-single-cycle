#!/bin/bash
INPUT="resource/sum.hex"
OUTPUT="resource/sum_standard.hex"

echo "Converting hex file format..."

# 创建标准格式的hex文件
{
  # 添加起始地址
  echo "@0000"
  
  # 处理原始文件，提取所有数据
  awk '
  # 跳过文件头
  /^v3\.0/ { next }
  # 处理数据行
  /^[0-9A-Fa-f]+:/ {
    # 去掉地址部分（冒号前的部分）
    gsub(/^[^:]*:/, "")
    # 按空格分割数据
    n = split($0, data, " ")
    for (i = 1; i <= n; i++) {
      # 确保每个数据是8位十六进制数
      if (length(data[i]) > 0) {
        # 如果数据长度不是8，进行填充
        len = length(data[i])
        if (len < 8) {
          printf "%0*d%s\n", 8-len, 0, data[i]
        } else if (len > 8) {
          # 如果超过8位，取后8位
          print substr(data[i], len-7, 8)
        } else {
          print data[i]
        }
      }
    }
  }
  ' "$INPUT"
} > "$OUTPUT"

echo "Conversion complete. New file: $OUTPUT"
echo "Line count: $(wc -l < "$OUTPUT")"
echo "First 10 lines:"
head -10 "$OUTPUT"

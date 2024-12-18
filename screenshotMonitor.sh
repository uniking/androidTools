#!/bin/bash

# 确保 adb 已经启动
adb start-server

# 检查设备是否已连接
if ! adb devices | grep -q "device$"; then
  echo "未检测到设备，请确保设备已连接并启用调试模式。"
  exit 1
fi

echo "脚本启动中，每5分钟截屏一次，输入 'q' 退出。"

while true; do
  # 当前时间作为文件名
  TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
  SCREENSHOT_NAME="/sdcard/screenshot_$TIMESTAMP.png"
  LOCAL_NAME="screenshot_$TIMESTAMP.png"

  # 截屏
  echo "正在截屏..."
  adb exec-out screencap -p > $LOCAL_NAME

  if [ $? -eq 0 ]; then
    echo "截屏成功，保存到 $LOCAL_NAME"
  else
    echo "截屏失败，请检查设备连接！"
    exit 1
  fi

  # 等待 5 分钟或检查退出指令
  echo "等待 5 分钟，期间输入 'q' 可以退出。"
  for ((i=1; i<=300; i++)); do
    read -t 1 -n 1 INPUT
    if [[ $INPUT == "q" ]]; then
      echo "退出脚本。"
      exit 0
    fi
  done
done


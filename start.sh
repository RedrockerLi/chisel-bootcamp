#!/bin/bash
# Chisel Bootcamp 一键启动脚本

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONDA_BASE="/home/redrocker/anaconda3"

# 激活 conda 环境
source "$CONDA_BASE/bin/activate" chisel

# 切换到 bootcamp 目录
cd "$SCRIPT_DIR"

echo "=================================="
echo "  Chisel Bootcamp 启动中..."
echo "=================================="

# 清理旧进程
OLDPID=$(pgrep -f "jupyter-notebook.*8888" 2>/dev/null)
if [ -n "$OLDPID" ]; then
    echo "[INFO] 检测到已有 Jupyter (PID: $OLDPID)，正在停止..."
    kill "$OLDPID" 2>/dev/null
    sleep 2
fi

# 启动 Jupyter Notebook
echo "[INFO] 启动 Jupyter Notebook..."
jupyter notebook --ip=0.0.0.0 --port=8888 &
JPID=$!

# 等待启动
sleep 3

# 获取 token
TOKEN=$(jupyter notebook list 2>/dev/null | grep -oP 'token=\K[a-zA-Z0-9]+' | head -1)
URL="http://127.0.0.1:8888/tree?token=${TOKEN}"

echo ""
echo "  Jupyter 已启动！"
echo "  URL: $URL"
echo ""

# 等待 Jupyter 进程
wait $JPID

# 使用更精简的 Ubuntu 基础镜像
FROM ubuntu:22.04

# 避免安装过程中的交互提示
ENV DEBIAN_FRONTEND=noninteractive

# 切换 APT 软件源为国内镜像源（阿里云）
RUN sed -i 's|http://archive.ubuntu.com/ubuntu/|http://mirrors.aliyun.com/ubuntu/|g' /etc/apt/sources.list

# 安装基础依赖
RUN apt-get update && apt-get install -y \
    git \
    curl \
    sudo \
    software-properties-common \
    python3 \
    python3-pip \
    g++ \
    gcc \
    build-essential \
    npm \
    unzip \
    clang-format

# 安装 Neovim 0.9.0
RUN add-apt-repository ppa:neovim-ppa/unstable -y && \
    apt-get update && \
    apt-get install -y neovim

# 创建配置目录并克隆仓库
RUN mkdir -p /root/.config/nvim && \
    git clone https://github.com/HuangJunLin8/nvim /root/.config/nvim

# 预安装插件（静默模式）
RUN nvim --headless "+Lazy! sync" +qa

# 设置默认终端类型（防止警告）
ENV TERM=xterm-256color

# 容器启动时进入 Neovim
CMD ["nvim"]

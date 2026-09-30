# 1. 基础镜像：ROS 2 Humble 基础版（CI 环境推荐轻量版，加快构建）
FROM ros:humble-ros-base

# 2. 设置环境变量，防止 apt 安装时交互卡死
ENV DEBIAN_FRONTEND=noninteractive

# 3. 安装系统基础工具和 Python 测试框架
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    wget \
    python3-pip \
    python3-pytest \
    python3-pytest-cov \
    # 无头仿真必备：虚拟屏幕
    xvfb \
    && rm -rf /var/lib/apt/lists/*

# 4. 安装轮式机器人核心 ROS 2 依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Gazebo 仿真器
    ros-humble-gazebo-ros-pkgs \
    # 机器人模型和状态发布
    ros-humble-robot-state-publisher \
    ros-humble-xacro \
    ros-humble-joint-state-publisher \
    # 导航和建图（轮式机器人标配）
    ros-humble-nav2-bringup \
    ros-humble-slam-toolbox \
    # 常用传感器和工具
    ros-humble-teleop-twist-keyboard \
    ros-humble-laser-filters \
    ros-humble-depthimage-to-laserscan \
    # 调试工具（在本地拉起容器看 RViz 时有用）
    ros-humble-rviz2 \
    && rm -rf /var/lib/apt/lists/*

# 5. 设置工作空间
WORKDIR /ws

# 6. 确保进入容器时自动加载 ROS 2 环境
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc

# 7. 默认命令
CMD ["bash"]
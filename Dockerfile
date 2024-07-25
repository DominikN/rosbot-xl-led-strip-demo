FROM ros:humble-ros-base AS pkg-builder

SHELL ["/bin/bash", "-c"]

COPY ./ros2_ws /ros2_ws

WORKDIR /ros2_ws

RUN source /opt/ros/${ROS_DISTRO}/setup.bash && \
    colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release && \
    rm -rf build log src

FROM husarnet/ros:humble-ros-core

RUN apt update && apt install -y \
        libgl1-mesa-glx \
        libglib2.0-0 \
        python3-pip && \
    pip3 install opencv-python

COPY --from=pkg-builder /ros2_ws /ros2_ws


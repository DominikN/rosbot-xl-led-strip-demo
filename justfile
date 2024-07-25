set dotenv-load

[private]
default:
    @just --list --unsorted

[private]
alias flash := flash-firmware
[private]
alias start := start-rosbot
[private]
alias teleop := run-teleop

# flash the proper firmware for STM32 microcontroller in ROSbot XL
flash-firmware: _install-yq _run-as-user
    #!/bin/bash
    echo "Stopping all running containers"
    docker ps -q | xargs -r docker stop

    echo "Flashing the firmware for STM32 microcontroller in ROSbot"
    docker run \
        --rm -it \
        --device /dev/ttyUSBDB \
        --device /dev/bus/usb/ \
        --volume ./led-firmware.bin:/ros2_ws/install/rosbot_xl_utils/share/rosbot_xl_utils/firmware/firmware-v1.4.0.bin \
        $(yq .services.rosbot.image compose.yaml) \
        ros2 run rosbot_xl_utils flash_firmware --port /dev/ttyUSBDB

# start containers on a physical ROSbot XL
start-rosbot: _run-as-user
    #!/bin/bash
    docker compose down
    docker compose pull
    docker compose build
    docker compose up

# run teleop_twist_keybaord (inside rviz2 container)
run-teleop:
    #!/bin/bash
    docker compose exec rosbot /bin/bash -c "/ros_entrypoint.sh ros2 run teleop_twist_keyboard teleop_twist_keyboard"

debug-port:
    #!/bin/bash
    lsof -i :8888

_run-as-root:
    #!/bin/bash
    if [ "$EUID" -ne 0 ]; then
        echo -e "\e[1;33mPlease re-run as root user to install dependencies\e[0m"
        exit 1
    fi

_run-as-user:
    #!/bin/bash
    if [ "$EUID" -eq 0 ]; then
        echo -e "\e[1;33mPlease re-run as non-root user\e[0m"
        exit 1
    fi

_install-yq:
    #!/bin/bash
    if ! command -v /usr/bin/yq &> /dev/null; then
        if [ "$EUID" -ne 0 ]; then
            echo -e "\e[1;33mPlease run as root to install dependencies\e[0m"
            exit 1
        fi

        YQ_VERSION=v4.35.1
        ARCH=$(arch)

        if [ "$ARCH" = "x86_64" ]; then
            YQ_ARCH="amd64"
        elif [ "$ARCH" = "aarch64" ]; then
            YQ_ARCH="arm64"
        else
            YQ_ARCH="$ARCH"
        fi

        curl -L https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_${YQ_ARCH} -o /usr/bin/yq
        chmod +x /usr/bin/yq
        echo "yq installed successfully!"
    fi




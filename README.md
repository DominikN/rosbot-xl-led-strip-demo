# rosbot-xl-led-strip-demo

A demo project showing how to use LED strip on ROSbot XL from ROS 2.

> [!NOTE]
> To simplify the execution of this project, we are utilizing [just](https://github.com/casey/just).
>
> Install it with:
>
> ```bash
> curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | sudo bash -s -- --to /usr/bin
> ```

We're using [rosbot_xl_firmware release with PoC support for LED strips](https://github.com/husarion/rosbot_xl_firmware/releases/tag/v1.4.1). This firmware provides a new `/led_strip` topic of type `sensor_msgs/msg/Image`.

```bash
husarion@rosbotxl:~/rosbot-xl-led-strip-demo$ ros2 topic info /led_strip -v
Type: sensor_msgs/msg/Image

Publisher count: 1

Node name: led_strip_publisher
Node namespace: /
Topic type: sensor_msgs/msg/Image
Endpoint type: PUBLISHER
GID: 01.0f.40.ec.3c.00.5d.38.01.00.00.00.00.00.11.03.00.00.00.00.00.00.00.00
QoS profile:
  Reliability: RELIABLE
  History (Depth): UNKNOWN
  Durability: VOLATILE
  Lifespan: Infinite
  Deadline: Infinite
  Liveliness: AUTOMATIC
  Liveliness lease duration: Infinite

Subscription count: 1

Node name: stm32_node
Node namespace: /
Topic type: sensor_msgs/msg/Image
Endpoint type: SUBSCRIPTION
GID: 01.0f.eb.bc.53.00.75.da.01.00.00.00.00.00.02.04.00.00.00.00.00.00.00.00
QoS profile:
  Reliability: BEST_EFFORT
  History (Depth): UNKNOWN
  Durability: VOLATILE
  Lifespan: Infinite
  Deadline: Infinite
  Liveliness: AUTOMATIC
  Liveliness lease duration: Infinite
```

All you need to do is to publish 18 x 1 (there are 18 LEDs in the strip) RGB image on this topic.

In this demo project there is also a sample ROS 2 `led_strip_publisher` node showing how use the `/led_strip` topic.

## Flashing the firmware

Open a terminal in ROSbot XL and run:

```bash
just flash
```

## Running the Demo in Docker

Open a terminal in ROSbot XL and run:

```bash
just flash
```

You should see a rainbow animation on the LED strip.

## Running teleop

You can also drive the robot around manually with:

```bash
just teleop
```
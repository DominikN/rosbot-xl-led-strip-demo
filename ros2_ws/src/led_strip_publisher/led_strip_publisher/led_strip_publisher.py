import rclpy
from rclpy.node import Node
from sensor_msgs.msg import Image
import numpy as np
import cv2

class LEDStripPublisher(Node):

    def __init__(self):
        super().__init__('led_strip_publisher')
        self.publisher_ = self.create_publisher(Image, '/led_strip', 10)
        self.current_position = 0
        self.rainbow_image = self.create_rainbow_image()
        timer_period = 0.1  # seconds
        self.timer = self.create_timer(timer_period, self.timer_callback)

    def create_rainbow_image(self):
        # Create an 18x1 image with 3 channels (RGB)
        image = np.zeros((1, 18, 3), dtype=np.uint8)

        # Create a rainbow pattern
        for i in range(18):
            hue = int(255 * (i / 18.0))
            image[0, i] = cv2.cvtColor(np.uint8([[[hue, 255, 255]]]), cv2.COLOR_HSV2BGR)[0][0]

        return image

    def timer_callback(self):
        # Shift the rainbow pattern
        shifted_image = np.roll(self.rainbow_image, self.current_position, axis=1)

        # Convert to ROS Image message
        msg = Image()
        msg.header.stamp = self.get_clock().now().to_msg()
        msg.height = 1
        msg.width = 18
        msg.encoding = 'rgb8'
        msg.is_bigendian = False
        msg.step = 18 * 3
        msg.data = shifted_image.flatten().tolist()

        # Publish the image
        self.publisher_.publish(msg)
        self.get_logger().info('Publishing LED strip image')

        # Update position
        self.current_position += 1
        if self.current_position >= 18:
            self.current_position = 0

def main(args=None):
    rclpy.init(args=args)

    led_strip_publisher = LEDStripPublisher()

    rclpy.spin(led_strip_publisher)

    # Destroy the node explicitly
    led_strip_publisher.destroy_node()
    rclpy.shutdown()

if __name__ == '__main__':
    main()

from setuptools import setup

package_name = 'led_strip_publisher'

setup(
    name=package_name,
    version='0.0.0',
    packages=[package_name],
    py_modules=[
        'led_strip_publisher.led_strip_publisher',
    ],
    install_requires=['setuptools'],
    zip_safe=True,
    maintainer='husarion',
    maintainer_email='dominik.nwk@gmail.com',
    description='A ROS 2 package to publish a rainbow LED strip image.',
    license='Apache License 2.0',
    tests_require=['pytest'],
    entry_points={
        'console_scripts': [
            'led_strip_publisher = led_strip_publisher.led_strip_publisher:main',
        ],
    },
)

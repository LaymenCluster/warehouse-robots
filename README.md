# Overview
The project is based on multiple-wheeled robots in a warehouse set up to move packages from one location to another. It involves localizing and mapping the wheeled robots using a camera placed on the ceiling. Then, the robots are controlled to follow a particular path and reach their respective destinations.

# Scope
We used MATLAB, a proprietary product from MathWorks, in our project. We also used AprilTag, a visual fiducial system explicitly used for robotics and AR applications. MATLAB is on par or faster in execution than regular Python code as it is based on Objective-C. Our project is limited to a single camera and thus bounded to a specific area to control the robots. A smartphone is used as a camera, but a high-definition Wi-Fi webcam can replace this. The driver code performs poorly in low light conditions and low resolution. This can be improved by using higher resolution and with better computational capability. The software can still perform well with slight changes to camera angles. However, this can be improved through image transformation techniques. Our work does not include automatic charging stations or package delivery extensions and is only limited to the simultaneous movement of multiple robots.

# Methodology
### Software system overview

![software](https://user-images.githubusercontent.com/71921860/178108444-d50b01de-7f86-44bc-a689-401824123ec4.png)

The main driver code is executed with the camera and robots switched ON. The software connects to the Wi-Fi camera and detects the April tags. The output is a matrix of values, which is converted to the positions and orientations of the robots. This will be used to calculate the instructions to steer the robots in the right path. After every loop, the software checks if all the robots have reached their final destinations. Any robot that goes beyond the field of vision of the camera is detected and stopped.

### Hardware system overview
Each robot is equipped with a microcontroller called “NodeMCU”, which has both Wi-Fi capability and controller architecture. A supply of 5V is required by the microcontroller for its functioning. The motor driver needs 12V to power the motors. However, a voltage drop of 1.5V is observed at the output terminals of the motor driver due to the inefficiency of the MOSFET. The remaining voltage is supplied to the motors with the help of PWM to control the wheel’s speed.

![Hardware1](https://user-images.githubusercontent.com/71921860/178108606-ab4724fe-9cfa-406b-b53c-a074e09f7d34.png)

Each robot receives an instruction from the central system through UDP Protocol. The values are ‘0’, ‘1’, & ‘2’ for movement of wheels and ‘4’ & ’5’ for direction of rotation of wheels. Multiple robots can be controlled at the same time as the bits are streamed across the same port but for different IP addresses for each robot.

![Hardware2](https://user-images.githubusercontent.com/71921860/178108616-534c2df4-4604-4846-8767-97e0f350a17f.png)

# Programming
### MATLAB Programming
#### Camera Module
We used a smartphone as a camera module for its ease of operation and usability. An Android application called “IP Webcam” is downloaded and installed on the smartphone. The smartphone is connected to the same Wi-Fi network that the central system is connected to. Now, the IP address is noted from the smartphone, and the Instrument control toolbox is used to connect the device over Wi-Fi. The toolbox also allows for other cameras and allows us to obtain the properties of those cameras. A snapshot of the video is taken for every single loop during the execution.

#### AprilTag Detection
MATLAB’s Robotics System toolbox consists of a function called “readAprilTag” which takes in an image containing the AprilTags and gives out the tag ID and coordinates of the tags. The coordinates are of size 2x4x3 for 3 tags and must be converted to get the centroid and orientation of the tags.

#### Controller Function
The controller function takes the current position and orientation as well as the current goal of the robot adjusts for the global map’s orientation and produces instructions to correct the current orientation to the desired orientation. The controller works as a proportional controller and is chosen due to the slow rate of the robot’s movements.

#### Collision Avoidance
The collision function takes in the position information from the detection function and calculates the distance between each robot to another. For a certain threshold, a collision is registered, and the final destinations are diverted in a manner that the robots orbit around each other at 90 degrees to the direction of the collision vector. The robots will orbit in a clockwise direction to avoid each other and move out of their orbits as soon as the robots don’t cross each other’s paths. In case of inaccuracy in the movement of robots and if the robots are crossing a threshold beyond which the collision is unavoidable, the function produces a stop flag and stops the robots for human intervention to separate the robots.

#### Screen Overlay
The image is taken and all the infographics such as paths, avoidance goals, final goals, positions, number frames, error handling information, and collision boundaries are overlayed on the image. This helped us to debug and find faults during execution. Graphical output also allows us to monitor all the robots from the central system without the need to monitor them in the field.

### Arduino Programming
#### UDP Receive
Arduino IDE contains a library called “WiFiUdp” which enables NodeMCU to use the UDP protocol and communicate with the central system. UDP offers fast communication, and the nodes connect through a port. It also offers login-based connection thus unauthorized connection attempts can be eliminated. First, a packet size is defined, and the information is transmitted in the form of stream packets. The packets are received and decoded into binary form. The packets are then stored in a variable for further access.

#### Controller Function
The instruction from the packet is converted from a string to an integer. Conditional statements are used to determine which state the robot’s wheel must be set. The instructions ‘4’ and ‘5’ sets the robot’s wheel to rotate in the forward or backward direction. ‘0’ is for moving both wheels and ‘1’ and ‘2’ are used to rotate only one wheel. By rotating only one wheel, the robot can turn in either direction. This is the basis of differential drive-based robots which have been used in our project. ‘3’ is used for stopping the wheels. The receiving of packets and checking of conditional statements are looped indefinitely as long as the power supply is uninterrupted.

# Setup
![a1](https://user-images.githubusercontent.com/71921860/178108893-19d28bc1-0dbc-4268-a501-d7e7e74d2411.png)
![a3](https://user-images.githubusercontent.com/71921860/178108910-02fd678f-5d7f-4c50-9719-2518cb674d65.png)
![a2](https://user-images.githubusercontent.com/71921860/178108929-cc916a97-42ce-4734-97f8-530d1888f7a6.png)
![3](https://user-images.githubusercontent.com/71921860/178108933-87633275-8c06-4aa7-8ee0-9dd61e942328.jpeg)

# Output
The following link helps you to understand the output:

https://user-images.githubusercontent.com/71921860/178108985-fe5fd57a-3757-4483-b260-be58c9b8941c.mp4

The following shows the output with other planners and a servo motor to store and deliver a package:

Single bot-

https://github.com/LaymenCluster/warehouse-robots/assets/71921860/42f44d24-217a-49b7-a34c-c93eb0d16375

Multiple bots-

https://github.com/LaymenCluster/warehouse-robots/assets/71921860/a7f1335d-04ce-468c-a417-1d693dcee883

# Limitations
The current implementation guarantees that the routes will be conflict and traffic jam-free. A limitation of the algorithm is that collisions are always solved by orbiting around each other in a clockwise direction. It is important to emphasize that in the current version, the algorithm runs at a specific step rate to compensate for the lack of sensors on the robot. With the addition of sensors like encoders, precise movement of the robots can be realized, and the execution can be accelerated at the expense of additional costs incurred. One possible solution is to add stoppages to one of the robots during a collision, for a specific time interval, or to reduce its speed. Other components of the storage activities, such as high production rates, large quantities of missions, restricted moving areas, a large number of mobile elements in the environment, and application characteristics - e.g., attendance and mounting applications will be in demand. This can be further extended to run with multiple cameras mounted on the ceiling to cover a large space or an entire factory. The algorithm can be extended to detect more than 100 robots at the same time with multiple cameras. Other applications such as disaster management and law enforcement patrolling can also be further explored based on coordinated swarm robots with an aerial vehicle.

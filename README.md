# Warehouse Robots — Localization, Mapping and Coordination

## Overview
This project implements a multi-robot system for package transport in a warehouse environment. Each robot is a wheeled mobile platform equipped with a NodeMCU microcontroller and is tracked using a camera-based AprilTag detection system. The central MATLAB application performs perception (AprilTag detection and pose estimation), global planning, collision avoidance, and issues motion commands to robots via UDP.

## Scope
The implementation relies on the MATLAB Robotics System Toolbox (a proprietary MathWorks product) and the AprilTag visual fiducial system. MATLAB was used for rapid prototyping of perception, mapping, and control algorithms. The system demonstrates real-time multi-robot localization and coordinated navigation using low-cost hardware components.

## System Architecture

### Software Overview
The MATLAB application is the central coordinator. It connects to an IP camera (a smartphone running an IP webcam app), processes video frames to detect AprilTags, estimates robot poses, generates paths, resolves collision risks, and sends motion commands to robots over UDP.

![software](https://user-images.githubusercontent.com/71921860/178108444-d50b01de-7f86-44bc-a689-401824123ec4.png)

High-level software responsibilities:
- Acquire video frames from the camera.
- Detect AprilTags and compute tag IDs and poses.
- Maintain a global map and robot states.
- Run path-planning and collision-avoidance routines.
- Send control packets to robots using UDP.

### Hardware Overview
Each robot includes:
- NodeMCU microcontroller (ESP8266) for Wi‑Fi communication and motor control.
- 5V power supply for the microcontroller and drive electronics.
- Differential drive wheels and steering mechanism as required.

Robots receive single-byte commands from the central system indicating wheel and steering actions (example values used: `0`, `1`, `2` for motion states and `4`, `5` for rotation/direction control). Communication is performed over UDP for low-latency command delivery.

![Hardware1](https://user-images.githubusercontent.com/71921860/178108606-ab4724fe-9cfa-406b-b53c-a074e09f7d34.png)
![Hardware2](https://user-images.githubusercontent.com/71921860/178108616-534c2df4-4604-4846-8767-97e0f350a17f.png)

## Implementation Details

### MATLAB Modules

- Camera Module
  - A smartphone running an IP Webcam application provides an MJPEG/HTTP video stream consumed by MATLAB.
  - Frames are periodically fetched and preprocessed for AprilTag detection.

- AprilTag Detection
  - Uses MATLAB’s Robotics System Toolbox function (readAprilTag) to identify tag IDs and to compute tag coordinates and poses in the camera frame.
  - Tag poses are converted to the global map reference to localize robots.

- Controller Function
  - A trajectory-following controller computes wheel commands from the robot's current pose and orientation relative to the goal.
  - Controller outputs are converted to discrete motion instructions compatible with the NodeMCU firmware.

- Collision Avoidance
  - The system continuously computes pairwise distances between robots.
  - If robots approach a configurable safety threshold, the planner adjusts paths or issues avoidance maneuvers to prevent collisions.

- Screen Overlay
  - The live camera feed is augmented with visual overlays showing robot positions, planned paths, goals, collision boundaries, and debug/error information for monitoring.

### NodeMCU / Arduino Firmware

- UDP Receive
  - NodeMCU devices use the WiFiUdp library (Arduino IDE) to receive UDP packets from the central controller.
  - Packets contain concise control commands to minimize latency and processing overhead on the embedded device.

- Command Interpreter
  - Incoming command strings are parsed and converted to integers.
  - Conditional logic sets motor and steering states based on command values (e.g., movement state, rotation direction).

## Setup
Images of the physical setup and test environment:

![a1](https://user-images.githubusercontent.com/71921860/178108893-19d28bc1-0dbc-4268-a501-d7e7e74d2411.png)
![a3](https://user-images.githubusercontent.com/71921860/178108910-02fd678f-5d7f-4c50-9719-2518cb674d65.png)
![a2](https://user-images.githubusercontent.com/71921860/178108929-cc916a97-42ce-4734-97f8-530d1888f7a6.png)
![3](https://user-images.githubusercontent.com/71921860/178108933-87633275-8c06-4aa7-8ee0-9dd61e942328.jpeg)

## Demonstrations / Output
Recorded demonstrations:

- Overview video:
  
  https://user-images.githubusercontent.com/71921860/178108985-fe5fd57a-3757-4483-b260-be58c9b8941c.mp4

- Single robot demonstration:
  
  https://github.com/LaymenCluster/warehouse-robots/assets/71921860/42f44d24-217a-49b7-a34c-c93eb0d16375

- Multiple robot demonstration:
  
  https://github.com/LaymenCluster/warehouse-robots/assets/71921860/a7f1335d-04ce-468c-a417-1d693dcee883

The repository also contains experiment variants showing integration with alternative planners and a servo-based payload handling mechanism for picking up and delivering packages.

## Limitations and Future Work
Current constraints and known limitations:
- Collision resolution in the present implementation uses orbiting maneuvers when robots conflict; this approach may not be optimal in dense scenarios.
- The system assumes reliable Wi‑Fi connectivity and low packet loss; UDP does not guarantee delivery and may require additional robustness mechanisms for production use.
- The perception pipeline depends on visible AprilTags; occlusions or poor lighting may degrade localization accuracy.

Recommended improvements:
- Implement more sophisticated multi-agent coordination strategies (e.g., prioritized planning or centralized scheduling) to avoid orbiting behaviors.
- Add packet acknowledgment or lightweight heartbeat to improve command reliability.
- Integrate sensor fusion (e.g., IMU + wheel odometry) to complement vision-based localization.
- Extend the planner to support dynamic obstacle handling and more complex task allocation.

# Smart-Power-Monitoring-System
Power Distribution is wide spread and the fault detection has become very difficult mostly in rural areas. Generally, it takes hours of time and man power to locate an electrical failure and find a solution to enable the power during power failures. Moreover, there are many electrical employees died of electrocution in the recent years. In this project, we are developing a Graphical interface that displays the status of power supply in each area, location of the power cut and gives control over the whole supply in that area. Our system also suggests the reason for the power cut by using Machine Learning algorithms to learn from its mistakes and improve its accuracy over a period of time. We not only detect the location of the power cut but also build a mechanism to remotely control the electrical supply. Our aim is to solve different problems involved in electrical failure like wire cuts, Transformer fuse blown-outs, internal system failures etc. We build an electro-mechanical system that detects the power failure, an Automatic Circuit Contactor and Breaker mechanism that is used to control the power remotely and an application for the employee to monitor and control the network. We use PYNQ as a platform to MAIN CONTROL UNIT in the electrical network and ATMEL microcontrollers to detect the power failures and transmit the information to the main serving device at the power station using nrf24L01 Transceivers. 

## Features :
#### * Can be Integrated with both Overhead and Under Ground Grid
#### * Early Problem Prediction and Pre-Notifier
#### * Problem Detection and Pole Tracking
#### * Anti Power Theft
#### * Grid Diagnosis using Machine Learning
#### * Power Report
#### * Self-Maintenance
#### * Application Controllable (Mobile App)
#### * Auto Switch Gear
#### * Transformer Switching


##### Application Preview 
![spmosmain](https://user-images.githubusercontent.com/23277604/51226310-e3c8d000-1974-11e9-813a-09e4c7d344c7.png)
![spmos](https://user-images.githubusercontent.com/23277604/51226328-fa6f2700-1974-11e9-960e-4d78bf9ac1bf.png)




#### Auto circuit Breaker
![acb](https://user-images.githubusercontent.com/23277604/51228572-18418980-197f-11e9-90c5-7b56258a3538.png)

#### Pynq Control Unit
![pynq](https://user-images.githubusercontent.com/23277604/51228287-de23b800-197d-11e9-855d-6c7037529f3b.png)

#### Control Unit
![spmos control](https://user-images.githubusercontent.com/23277604/51228945-83d82680-1980-11e9-9fec-aa07cc703cf8.png)

PYNQMASTER.ipynb must be include in the Pynq image file at :: PYNQ    boards/base/notebooks/microblaze/PYNQMASTER.ipynb


to see youtube Video :https://youtu.be/fQm5ON-TGN0

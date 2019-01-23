# DROWSY-DRIVER
This is an Attention Score based algorithm based on Blinking Rate and Yawning of the  Driver, based on which it warns him as well as takes the control of the vehicle if the Attention score fall below certain level. This is acheived on hardware level by using  CAN protocol to control Vehicle autonomously. 

Eye state classification using OpenCV and DLib to estimate Percentage Eye Closure as well Yawn detection using DLib and OpenCV.

Uses DLib facial landmark detector to find the major and minor axes of eyes, as well as mouth. The aspect ratio of major to minor axes is used to determine whether eye/mouth is open; which allows for eye-state classification and yawning detection. Requires a pre-trained DLib facial landmark detector model in a .dat file.

**alertness_driverAssist.ipynb** : 
	jupyter notebook code to run on PYNQ-Z2

**drowsy_driver_m1.py** : 
	code for model 1 to execute on CPU

**shape_predictor_68_face_landmarks.dat** : 
	Required a pre-trained DLib facial landmark detector model

## PLEASE REFER TO [WIKI DOCUMENTAION](https://github.com/reyanshsolis/safety_driving_assist/wiki) OF THIS PROJECT

# Result Output : 
![](https://github.com/reyanshsolis/safety_driving_assist/blob/master/drowsy_driver/output.gif?raw=true)


## Setup and Dependecies
### [INSTALLATION AND GETTING STARTED GUIDE](https://github.com/reyanshsolis/safety_driving_assist/wiki/Getting-Started-and-Setup-Guide)

![](https://github.com/reyanshsolis/myFolder/blob/master/IMG_20190113_214914.jpg?raw=true)	![](https://github.com/reyanshsolis/myFolder/blob/master/IMG_20190113_214828%20(1).jpg?raw=true)
### The Project has Two Models : 

### Model 1 :  [Pseudo Code](https://github.com/reyanshsolis/safety_driving_assist/wiki/Model-1-:-Pseudo-Code)
(WARNING Signals Part can be implemented by *anyone on any Car with Music System*) (Automous Braking can be implemented on any Bot, however it requires CAN-bus interface for a real Car)
*   Attention Score is determined on the basis of alertness judged by blinking eyes pattern and yawing rate. 
WARNING SIGNALS (ALERT SOUND and HAZARD INDICATORS) are activated when Attention Score falls before a certain WARNING LEVEL.
If Driver is still remains asleep,Attention score keeps falling and our [Autonomous Braking Algorithm](https://github.com/reyanshsolis/safety_driving_assist/wiki/Autonomous-Braking-Algorithm) is deployed to stop the vehicle and minimize the damage.

### Model 2:    (This Requires the Car to have [CAN-bus Interface](https://docs.google.com/document/d/1V-D0zt91xsXkLREZtW8yMn8hd-8KXD2_wTG5CpZry_M/edit?usp=sharing) for Autonomous Braking to work and Odometry sensors to return velocity)
It includes several improvements over first model.
*   Attention Score Penality rate takes **vehicle's velocity factor** into consideration, as the Attention Penality for closing eyes/yawning at high speed must be greater than that in low speed because of the higher level of required altertness at high speed. Example: Closing Eyes for 1sec at High Speed is much more significant than closing it at very low speed.
[ATTENTION SCORE ALGORITHM : MODEL 2](https://github.com/reyanshsolis/safety_driving_assist/wiki/Model-2-:-Pseudo-Code)

*   Improvised Braking Algorithm including factors such as Traffic and nearest object distance into cosideration with velocity of car, braking distance (including reaction time of driver and alertness level).
[BRAKING ALGORITHM : MODEL 2](https://github.com/reyanshsolis/safety_driving_assist/wiki/Autonomous-Braking-Algorithm)

### Model 3 and 4 explained in [Model 2 Pseudo Code Explanation](https://github.com/reyanshsolis/safety_driving_assist/wiki/Model-2-:-Pseudo-Code)

### Detailed Explanation of entire Code: [Detailed_Code_Explanation](https://github.com/reyanshsolis/safety_driving_assist/wiki/Detailed-Code-Explanation)

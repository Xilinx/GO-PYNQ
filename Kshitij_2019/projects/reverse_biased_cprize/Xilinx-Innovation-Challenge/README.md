# Xilinx-Innovation-Challenge
# Team reverse_biased

# AUTOMATED-APPLIANCE SWITCHINGS(HOME AUTOMATION)
This is the code submission and video submission of our proposed project in `Xilinx Innovation Challenge` during Kshitij,2019 at IIT Kharagpur.

### Code Requirements:
1) OpenCV 2 or 3
2) Python 3.6
3) PYNQ-Z2 board - for hardware implementation and the computational unit. Also accelerates many functions of the code hence ensuring better FPS ,thus allowing for real-time application
4) USB WebCam(Logitech used here)

### Description:
This project uses OpenCV Python library to take in video-frames and process them , to detect the Hand-Gesture shown by the user
counting the number of fingers shown . Based on this , this can be implemented on Hardware to maybe `switch ON` T.V if the user shows 4 fingers
and `switch OFF` if user shows 4 fingers ; using `USB Webcam`
PYNQ-Z2 board is used for Accelerating the code for faster execution.

### Logic used for Image Processing:
Based on a fixed background we perform a background subtraction , blur the image and then find out the Binarised image of hand . Then
we perform Contour Detection and apply Convex Hull algorithm to determine the count of fingers.

### Procedure:

Execute `handgesture.py`(on PC) or `gesture.py`(on Board) and for the first 2 seconds keep the webcam faced towards a fixed background maybe a wall or something.
Once the working code has displayed `Background Captured!` then you can move on to bring your hand in front of the webcam , and the code will
process the image displaying the number of fingers shown.
![](images/simplescreenrecorder-2019-01-13_06.05.45.gif)
![](images/screenshot.png)
### Contributors:
##### 1) [Sumegh Roychowdhury](https://github.com/Sumegh-git/)
##### 2) [Sombit Dey](https://github.com/sombitd)

### Video Submission:
[Drive Link](https://drive.google.com/open?id=1d2Te67uuXUNkqjz2b3YCmYVUTbkFCApd)

# Program to determine the alertness of a driver while driving.  
# Please visit the Wiki Documentation of this Project : 
# https://github.com/reyanshsolis/safety_driving_assist/wiki
# Code, Algorithm, Pseudo Code and SETUP is explained in the wiki documentation
# github Repository link : https://github.com/reyanshsolis/safety_driving_assist

import cv2
import dlib
import time
import imutils
import argparse
import numpy as np
from threading import Thread
from collections import OrderedDict
from imutils.video import VideoStream
from imutils.video import FileVideoStream
from scipy.spatial import distance as dist

SHAPE_PREDICTOR_PATH = "/home/rey/shape_predictor_68_face_landmarks.dat"

# Compute the ratio of eye landmark distances to determine 
# if a person is blinking

def eye_aspect_ratio(eye):
    # compute the euclidean distances between the two sets of
    # vertical eye landmarks (x, y)-coordinates
    vertical_A = dist.euclidean(eye[1], eye[5])
    vertical_B = dist.euclidean(eye[2], eye[4])
    
    # compute the euclidean distance between the horizontal
    # eye landmark (x, y)-coordinates
    horizontal_C = dist.euclidean(eye[0], eye[3])
    
    # compute the eye aspect ratio
    ear = (vertical_A + vertical_B) / (2.0 * horizontal_C)
    
    # return the eye aspect ratio
    return ear

# Funtion to get generate landmarks on face 
# from a pre-trained model predictor

def get_landmarks(im):
    rects = detector(im, 1)

    if len(rects) > 1:
        return "error"
    if len(rects) == 0:
        return "error"
    return np.matrix([[p.x, p.y] for p in predictor(im, rects[0]).parts()])

# Copy the landmarks on the image frame and return
def annotate_landmarks(im, landmarks):
    im = im.copy()
    for idx, point in enumerate(landmarks):
        pos = (point[0, 0], point[0, 1])
        cv2.putText(im, str(idx), pos,
                    fontFace=cv2.FONT_HERSHEY_SCRIPT_SIMPLEX,
                                    fontScale=0.4,color=(0, 0, 255))
        cv2.circle(im, pos, 3, color=(0, 255, 255))
    return im

# Compute and put landmarks on the top lip
def top_lip(landmarks):
    top_lip_pts = []
    for i in range(50,53):
        top_lip_pts.append(landmarks[i])
    for i in range(61,64):
        top_lip_pts.append(landmarks[i])
    top_lip_all_pts = np.squeeze(np.asarray(top_lip_pts))
    top_lip_mean = np.mean(top_lip_pts, axis=0)
    return int(top_lip_mean[:,1])

# Compute and put landmarks on the bottom lip
def bottom_lip(landmarks):
    bottom_lip_pts = []
    for i in range(65,68):
        bottom_lip_pts.append(landmarks[i])
    for i in range(56,59):
        bottom_lip_pts.append(landmarks[i])
    bottom_lip_all_pts = np.squeeze(np.asarray(bottom_lip_pts))
    bottom_lip_mean = np.mean(bottom_lip_pts, axis=0)
    return int(bottom_lip_mean[:,1])

# Find the distance between the top and bottom lips
def mouth_open(image):
    landmarks = get_landmarks(image)
    
    if landmarks == "error":
        return image, 0

    image_with_landmarks = annotate_landmarks(image, landmarks)
    top_lip_center = top_lip(landmarks)
    bottom_lip_center = bottom_lip(landmarks)
    lip_distance = abs(top_lip_center - bottom_lip_center)
    return image_with_landmarks, lip_distance

# Constant for the eye aspect ratio to indicate drowsiness 
EYE_AR_THRESH = 0.25
# Constant for the number of consecutive frames the 
#eye (closed) must be below the threshold
EYE_AR_CONSEC_FRAMES = 10
# Initialize the frame counter
FRAME_COUNTER = 0
# Boolean to indicate if the alarm is going off
IS_ALARM_ON = False
#yawning distance threshold 
YAWN_DIST = 32
#Maximum Positive Attention Score : 

AttentionScoreMax = 80000
AttentionScore = AttentionScoreMax
#Warning Level
WarningLevel = 50000
autoBrakeLevel = 3000
#error frame 
error_frame_thres = 2
YAWN_MIN_FRAME_COUNT = 10
CAL_AVG_EAR=0
ear_flag=0
avg_ear_sum=0

# Funtion printing alert warning on screen and return attenion score of driver
# Compare the attention score and threshold attention level  
def warningAlert():
    print (" WARNING ALERT !!! ")
    output_text = "WARNING! ALERT !" + str(AttentionScore)
    cv2.putText(frame,output_text,(50,100),
        cv2.FONT_HERSHEY_COMPLEX, 2,(0,0,255),2)
    return

def autoBrakeAlert():
    print (" AUTO BRAKE !!! ")
    output_text = "AUTO BRAKE " + str(AttentionScore)
    cv2.putText(frame,output_text,(50,250),
        cv2.FONT_HERSHEY_COMPLEX, 2,(0,0,255),4)
    return

def checkWarning():
    if(AttentionScore < WarningLevel):
        warningAlert()
    if(AttentionScore < autoBrakeLevel):
        autoBrakeAlert()
    return

# Take a bounding predicted by dlib and convert it
# to the format (x, y, w, h) as normally handled in OpenCV
def rect_to_bb(rect):
    x = rect.left()
    y = rect.top()
    w = rect.right() - x
    h = rect.bottom() - y
    
    # return a tuple of (x, y, w, h)
    return (x, y, w, h)

# The dlib face landmark detector will return a shape object 
# containing the 68 (x, y)-coordinates of the facial landmark regions.
# This fucntion converts the above object to a NumPy array.
def shape_to_np(shape, dtype = 'int'):
    # initialize the list of (x, y)-coordinates
    coords = np.zeros((68, 2), dtype = dtype)
    
    # loop over the 68 facial landmarks and convert them
    # to a 2-tuple of (x, y)-coordinates
    for i in range(0, 68):
        coords[i] = (shape.part(i).x, shape.part(i).y)
        
    # return the list of (x, y)-coordinates
    return coords

# define a dictionary that maps the indexes of the facial
# landmarks to specific face regions
FACIAL_LANDMARKS_IDXS = OrderedDict([
    ("mouth", (48, 68)),
    ("right_eyebrow", (17, 22)),
    ("left_eyebrow", (22, 27)),
    ("right_eye", (36, 42)),
    ("left_eye", (42, 48)),
    ("nose", (27, 35)),
    ("jaw", (0, 17))
])

# initialize dlib's face detector (HOG-based)
detector = dlib.get_frontal_face_detector()

# create the facial landmark predictor
predictor = dlib.shape_predictor(SHAPE_PREDICTOR_PATH)

# grab the indexes of the facial landmarks for the left and
# right eye, respectively
(leStart, leEnd) = FACIAL_LANDMARKS_IDXS['left_eye']
(reStart, reEnd) = FACIAL_LANDMARKS_IDXS['right_eye']

# Streaming from a web-cam
vs = VideoStream(src = 1).start()
fileStream = False

fourcc = cv2.VideoWriter_fourcc(*'XVID')
out = cv2.VideoWriter('output.avi',fourcc,20.0,(640,480))
result = cv2.VideoWriter('result.avi',fourcc,20.0,(640,480))

time.sleep(1.0)

# Variables for yawn detection and frame count are initialized 

yawns = 0
yawn_status = False 
# loop over frames from the video stream
FRAME_COUNTER_YAWN =0
FRAME_COUNTER_EYES =0
yawns = 0
cv2.namedWindow("Frame", cv2.WND_PROP_FULLSCREEN)#cv2.WINDOW_NORMAL)
# Loop for reading frames and implementing algorithms in it
while True:
    global frame 
    frame = vs.read()
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    rects = detector(gray, 0)
    image_landmarks, lip_distance = mouth_open(frame)
    out.write(frame)
    #Printing attention score and distance between lips
    prev_yawn_status = yawn_status  
    print ("lip distance: ", lip_distance)
    print ("AttentionScore: ", AttentionScore)
    
    # Master code for yawn detection and attention scoring
    # along with time of yawning
    if (lip_distance > YAWN_DIST and ear_flag == 2):
        #start_time = time.time()
        FRAME_COUNTER_YAWN +=1
        yawn_status == True
        print ("Frame Count: ", FRAME_COUNTER)

        # Attention scorer part
        if(FRAME_COUNTER_YAWN > YAWN_MIN_FRAME_COUNT):
                AttentionScore -=2*FRAME_COUNTER
                cv2.putText(frame, "Subject is Yawning",(50,450),
                    cv2.FONT_HERSHEY_COMPLEX, 1,(0,0,255),2)
                checkWarning()
            
    else:
        yawn_status == False
        if (AttentionScore < AttentionScoreMax):
            AttentionScore +=100
            checkWarning()

                 
    if prev_yawn_status == True and yawn_status == False:
        yawns += 1
        FRAME_COUNTER_YAWN = 0

    cv2.imshow('Live Landmarks', image_landmarks )
    
    ##Checking Drowsiness of Driver : 

    for rect in rects:
        # determine the facial landmarks for the face region, then
        # convert the facial landmark (x, y)-coordinates to a NumPy array
        shape = predictor(gray, rect)
        shape_np = shape_to_np(shape)
        
        # extract the left and right eye coordinates, then use the
        # coordinates to compute the eye aspect ratio for both eyes
        leftEye = shape_np[leStart:leEnd]
        rightEye = shape_np[reStart:reEnd]
        leftEAR = eye_aspect_ratio(leftEye)
        rightEAR = eye_aspect_ratio(rightEye)
        
        # average the eye aspect ratio together for both eyes
        avgEAR = (leftEAR + rightEAR) / 2.0
        
        # compute the convex hull for the left and right eye, then
        # visualize each of the eyes
        leftEyeHull = cv2.convexHull(leftEye)
        rightEyeHull = cv2.convexHull(rightEye)
        cv2.drawContours(frame, [leftEyeHull], -1, (0, 255, 0), 1)
        cv2.drawContours(frame, [rightEyeHull], -1, (0, 255, 0), 1)
        

        #Configures Eyes Aspect Ratio according to the driver's 
        #eyes by taking avg. of 100 frames
        if(CAL_AVG_EAR < 100):
            cv2.putText(frame, "CONFIGURING E.A.R.", (20, 60),
             cv2.FONT_HERSHEY_SIMPLEX, 2, (255, 0, 0), 4)
            ear_flag=1
            avg_ear_sum+=avgEAR
            CAL_AVG_EAR +=1
        else:
            if(CAL_AVG_EAR == 100):
                CAL_AVG_EAR = 200
                avgEAR = 0.95*(avg_ear_sum/100)
                ear_flag=2

        if (avgEAR < EYE_AR_THRESH and ear_flag == 2):
            FRAME_COUNTER_EYES += 1
            
            # if the eyes were closed for a sufficient number of
            # then sound the alarm
            if FRAME_COUNTER_EYES >= EYE_AR_CONSEC_FRAMES:
                cv2.putText(frame, 'DROWSINESS ALERT!!!', (10, 30),
                 cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 0, 255), 2)
                AttentionScore-=40*FRAME_COUNTER_EYES
                if(AttentionScore <=0):
                    AttentionScore=0
                checkWarning()
            
        # check to see if the eye aspect ratio is below the blink
        # threshold, and if so, increment the blink frame counter
        else:
            FRAME_COUNTER_EYES = 0
            IS_ALARM_ON = False
            
        # draw the computed eye aspect ratio for the frame
        cv2.putText(frame, "EAR: {:.2f}".format(avgEAR), (300, 30),
         cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 0, 255), 2)
        output_text = " Attention Score " + str(AttentionScore)
        cv2.putText(frame,output_text,(30,300),
            cv2.FONT_HERSHEY_COMPLEX, 1,(0,255,127),2)
        
    # show the frame
    cv2.imshow('Frame', frame)
    result.write(frame)

    key = cv2.waitKey(1) & 0xFF
    
# Cleanup
cv2.destroyAllWindows()
vs.stop()
out.release()

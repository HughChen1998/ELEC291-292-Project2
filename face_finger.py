from __future__ import division
import numpy as np
import matplotlib.pyplot as plt
import math
import cv2
import time, threading
import copy
from collections import deque
import argparse

import tkinter as tk
from PIL import ImageTk
from PIL import Image
import serial
import serial.tools.list_ports
import imutils
import pygame
import pyaudio

import os
from os import path

from time import ctime
import time
from gtts import gTTS

import sys
#import pyttsx
import speech_recognition as sr
import subprocess
#subprocess.check_output(['ls','-l']) #all that is technically needed...
from subprocess import call
import matplotlib.animation as animation
import sys, time, math
from time import sleep

ogg = 0
peeking = 0
once = 1
yes = 0
do_bit = 1;
PORT = 'COM5'
try:
 ser.close();
except:
 print();
try:
 ser = serial.Serial(PORT, 115200, timeout=100)
except:
 print ('Serial port %s is not available' % PORT);
 portlist=list(serial.tools.list_ports.comports())
 print('Trying with port %s' % portlist[0][0]);
 ser = serial.Serial(portlist[0][0], 115200, timeout=100)
ser.isOpen()
secret = ""
instruction  = ""
secret_num = 0

bright=128
# parameters
cap_region_x_begin=0.5  
cap_region_y_end=0.8

cap_region_x_end2=0.8  
cap_region_y_begin2=0.5 

threshold = 60  
blurValue = 41  
bgSubThreshold = 50
#bgModel = cv2.BackgroundSubtractorMOG2(0, bgSubThreshold)
bgModel = cv2.createBackgroundSubtractorMOG2()
starter = 1

ap = argparse.ArgumentParser()
ap.add_argument("-v", "--video",
	help="")   #This is sketchy!!!!!!!!!!!!
ap.add_argument("-b", "--buffer", type=int, default=32,
	help="max buffer size")
args = vars(ap.parse_args())
MIN = np.array([0, 48, 80], dtype = "uint8")
MAX = np.array([20, 255, 255], dtype = "uint8")

pts_right = deque(maxlen=args["buffer"])
pts_left = deque(maxlen=args["buffer"])
pts_top = deque(maxlen=args["buffer"])
counter = 0
(dX_L, dY_L) = (0, 0)
(dX_R, dY_R) = (0, 0)
(dX_T, dY_T) = (0, 0)
direction = ""
finger_count = 0


pygame.init()
chunk = 1024
FORMAT = pyaudio.paInt16
CHANNELS = 1
RATE = 44100
RECORD_SECONDS = 5



on_or_off = 0
class spinning_bastard(object):
    global on_or_off, ser, starter
    def __init__(self, master, filename, **kwargs):
        self.master = master
        self.filename = filename
        self.canvas = tk.Canvas(master, width=500, height=500)
        self.canvas.grid(row = 5, column = 3)


        self.lab = tk.Label(master, width=20, text = "finger genture", font=("Helvetica", 15), fg="blue")
        self.lab.grid(row = 1, column = 3)

        self.lab2 = tk.Label(master, width=20, text = "tracking gesture", font=("Helvetica", 15), fg="blue")
        self.lab2.grid(row = 2, column = 3)

        
        self.update = self.draw().__next__
        master.after(100, self.update)

    def draw(self):
        global on_or_off, starter
        image = Image.open(self.filename)
        angle = 0

        

        while True:
            if starter == 1:
                starter = 0
                sound_play("finish him.ogg")
            check_colour()
            check_colour_8()
            tkimage = ImageTk.PhotoImage(image.rotate(angle))
            canvas_obj = self.canvas.create_image(
                250, 250, image=tkimage)
            self.master.after_idle(self.update)
            yield
            self.canvas.delete(canvas_obj)
            self.canvas.configure(bg = "black")
            if on_or_off == 1:
                angle += 10
                angle %= 360

def is_empty(any_structure):
    if len(any_structure):
        return 0
    else:
        return 1
cap = cv2.VideoCapture(0)

def click(word):
    if peeking == 1:
        ser.write(str(word).encode('ascii'))
        on_or_off = 1

def click2(word):
    if finger_count == 1:
        on_or_off = 1
        ser.write(str(word).encode('ascii'))
def click3(word):
    on_or_off = 1
    ser.write(str(word).encode('ascii'))
#-----------------------------------the function below is copied-------------------------------------------

def removeBG(frame, bgModel):
    f = bgModel.apply(frame)
    # kernel = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (3, 3))
    # res = cv2.morphologyEx(fgmask, cv2.MORPH_OPEN, kernel)

    k = np.ones((3, 3), np.uint8)
    f = cv2.erode(f, k, iterations=1)
    returnn = cv2.bitwise_and(frame, frame, mask=f)
    return returnn

#-----------------the function above is copied----------------------------------------------------------
#detect_hand (cap)
def peek():
    global peeking
    if peeking == 0:
        peeking = 1
    else:
        peeking = 0

def fingers():
    global finger_count
    if finger_count == 0:
        finger_count = 1
    else:
        finger_count = 0
#while 1:
def camera():
    global on_or_off, bgSubThreshold, blurValue, threshold, cap_region_y_end, cap_region_x_begin, bgModel, counter, direction, pts_right, pts_left, pts_top, dX_L, dY_L, dX_R, dY_R, dX_T, dY_T, do_bit
    lst = []
    bgModel = cv2.createBackgroundSubtractorMOG2(0, 0)
    #bgModel = cv2.bgsegm.createBackgroundSubtractorGMG()
    ret, img = cap.read()
    if do_bit:
        
        cv2.imwrite('n.png', img )
        do_bit = 0
    #bgModel = bg.apply(img)
    cv2.putText(img,"this is here", (0, 0), cv2.FONT_HERSHEY_SIMPLEX, 2, 2)
    #cv2.rectangle(img, (300,300), (100,100), (0,255,0),0)
    #crop = img[100:300, 100:300]
    #---------------------------\
    
    threshold = cv2.getTrackbarPos('trh1', 'trackbar')
    img = cv2.bilateralFilter(img, 5, 50, 100)  # smoothing filter
    img = cv2.flip(img, 1)  # flip the frame horizontally
    cv2.rectangle(img, (int(cap_region_x_begin * img.shape[1]), 0),
                 (img.shape[1], int(cap_region_y_end * img.shape[0])), (255, 0, 0), 2)
    
    img2 = removeBG(img,bgModel)
    img2 = img[0:int(cap_region_y_end * img.shape[0]),
                int(cap_region_x_begin * img.shape[1]):img.shape[1]]  # may need to get rif of this
    #img2 = removeBG(img2,bgModel)
    img33 = img[0:int( cap_region_x_end2 *img.shape[0]), 0:int(cap_region_y_begin2 * img.shape[1])]
                  # may need to get rif of this
    
    #cv2.imshow('mask', img2)
     #--------------------------------------
    
    hsv = cv2.cvtColor(img33, cv2.COLOR_BGR2HSV)
    imgray = cv2.cvtColor(img2, cv2.COLOR_BGR2GRAY)
    gray = cv2.cvtColor(img33, cv2.COLOR_BGR2GRAY)
    #ret, thresh = cv2.threshold(imgray, 127, 255, 0)
    #--------------------------------------------------------------------------------------------------
    blur = cv2.GaussianBlur(imgray, (35, 35), 0)
    blur_tip = cv2.GaussianBlur(gray, (35, 35), 0)
    cv2.imshow('blur', blur)
    #cv2.imshow('blur_tip', blur_tip)
    #cv.threshold(blur,127,255,cv.THRESH_BINARY)
    #ret, thresh = cv2.threshold(blur, 127, 255, cv2.THRESH_BINARY)
    #thresh = cv2.adaptiveThreshold(blur,255,cv2.ADAPTIVE_THRESH_MEAN_C,\
    #        cv2.THRESH_BINARY,11,2)
    #thresh = cv2.adaptiveThreshold(imgray,255,cv2.ADAPTIVE_THRESH_GAUSSIAN_C,\
    #        cv2.THRESH_BINARY,11,2)
    _, thresh = cv2.threshold(blur, 127, 255,
                               cv2.THRESH_BINARY_INV+cv2.THRESH_OTSU)
    cv2.imshow('threshold hold value', thresh)




    #this is the the other one-----------------------------------------------------------------------
    thresh2 = cv2.threshold(blur_tip, 45, 255, cv2.THRESH_BINARY_INV)[1]
    #_, thresh2 = cv2.threshold(gray, 127, 255,
    #                           cv2.THRESH_BINARY_INV+cv2.THRESH_OTSU)

    mask = cv2.inRange(hsv, MIN, MAX)
    mask = cv2.erode(mask, None, iterations=2)
    mask = cv2.dilate(mask, None, iterations=2)



    
    cv2.imshow('NEW_TRESHHOLD', thresh2)
     
    # find contours in thresholded image, then grab the largest
    # one


    cnts = cv2.findContours(thresh2.copy(), cv2.RETR_EXTERNAL,
            cv2.CHAIN_APPROX_SIMPLE)
    #cnts = cv2.findContours(thresh2.copy(), cv2.RETR_EXTERNAL,
    #        cv2.CHAIN_APPROX_SIMPLE)
    cnts = cnts[0] if imutils.is_cv2() else cnts[1]
    
    
    lst = list(cnts)
    if lst:
        c = max(cnts, key=cv2.contourArea)
        extTop = tuple(c[c[:, :, 1].argmin()][0])
        extLeft = tuple(c[c[:, :, 0].argmin()][0])
        extRight = tuple(c[c[:, :, 0].argmax()][0])
        #print("top coordinate is: " + str(int(extTop[0]))+ ", " + str(int(extTop[1]))+str(c))
    else:
        extTop = tuple([0,0])
        extLeft = tuple([0,0])
        extRight = tuple([0,0])
        #c = 0
    
    
    # get the coutours
    #-------------------------------

    #--------------------------------------------------------------------------------------------------

    #=======this is for the motion tracking=========================
    pts_left.appendleft(extLeft)
    pts_right.appendleft(extRight)
    pts_top.appendleft(extTop)
    for i in np.arange(1, len(pts_left)):
		# if either of the tracked points are None, ignore
		# them
        if pts_left[i - 1] is None or pts_left[i] is None or pts_right[i - 1] is None or pts_right[i] is None:
            continue
        if counter >= 10 and i == 1 and len(pts_left) == args["buffer"]and len(pts_right) == args["buffer"]:
	    # coordinates and re-initialize the direction
	    # text variables
            #print("reached")
            dX_L = pts_left[-10][0] - pts_left[i][0]
            dY_L = pts_left[-10][1] - pts_left[i][1]
            dX_R = pts_right[-10][0] - pts_right[i][0]
            dY_R = pts_right[-10][1] - pts_right[i][1]
            (dirX_L, dirY_L) = ("", "")
            (dirX_R, dirY_R) = ("", "")
 
			# ensure there is significant movement in the
			# x-direction
            if np.abs(dX_L) > 20:
                dirX_L = "East" if np.sign(dX_L) == 1 else "West"
                
			# ensure there is significant movement in the
			# y-direction
            if np.abs(dY_L) > 20:
                dirY_L = "North" if np.sign(dY_L) == 1 else "South"
                
			# handle when both directions are non-empty
            if dirX_L != "" and dirY_L != "":
                direction = "{}-{}".format(dirY_L, dirX_L)
            else:
                direction = dirX_L if dirX_L != "" else dirY_L
                # otherwise, compute the thickness of the line and
		# draw the connecting lines
                thickness = int(np.sqrt(args["buffer"] / float(i + 1)) * 2.5)
                cv2.line(img, pts_left[i - 1], pts_left[i], (0, 0, 255), thickness)
 

            if np.abs(dX_R) > 20:
                dirX_R = "East" if np.sign(dX_R) == 1 else "West"
 
			# ensure there is significant movement in the
			# y-direction
            if np.abs(dY_R) > 20:
                dirY_R = "North" if np.sign(dY_R) == 1 else "South"
 
			# handle when both directions are non-empty
            if dirX_R != "" and dirY_R != "":
                direction = "{}-{}".format(dirY_R, dirX_R)
 
			# otherwise, only one direction is non-empty
            else:
                direction = dirX_R if dirX_R != "" else dirY_R
                # otherwise, compute the thickness of the line and
		# draw the connecting lines
                thickness = int(np.sqrt(args["buffer"] / float(i + 1)) * 2.5)
                cv2.line(img, pts_right[i - 1], pts_right[i], (0, 0, 255), thickness)
            if ((np.sign(dX_R) == -1 and np.sign(dX_L) == 1)) and (np.abs(dX_R) > 20 or np.abs(dX_L) > 20) :
                cv2.putText(img, "LEFT TURNING", (10, 30), cv2.FONT_HERSHEY_SIMPLEX,
                0.65, (0, 0, 255), 3)
                click('L')
                on_or_off = 1
            elif (np.sign(dX_R) == 1 and np.sign(dX_L) == -1) and (np.abs(dX_R) > 20 or np.abs(dX_L) > 20) :
                cv2.putText(img, "RIGHT TURNING", (10, 30), cv2.FONT_HERSHEY_SIMPLEX,
                0.65, (0, 0, 255), 3)
                click('R')
                on_or_off = 1
                counter += 1
    #===============motion tracking===================================================
    
    image, contours, hierarchy = cv2.findContours(thresh.copy(), \
               cv2.RETR_TREE, cv2.CHAIN_APPROX_NONE)

    # find contour with max area
    cnt = max(contours, key = lambda x: cv2.contourArea(x))

    # create bounding rectangle around the contour (can skip below two lines)
    x, y, w, h = cv2.boundingRect(cnt)
    cv2.rectangle(img2, (x, y), (x+w, y+h), (0, 0, 255), 0)

    # finding convex hull
    hull = cv2.convexHull(cnt)

    # drawing contours
    drawing = np.zeros(img2.shape,np.uint8)
    cv2.drawContours(drawing, [cnt], 0, (0, 255, 0), 0)
    cv2.drawContours(drawing, [hull], 0,(0, 0, 255), 0)

    #-----------the other one------------------
    #drawing2 = np.zeros(img33.shape,np.uint8)
    if lst:
        cv2.drawContours(img, [c], -1, (0, 255, 255), 2)
    cv2.circle(img, extTop, 8, (0, 0, 255), -1)
    cv2.circle(img, extLeft, 8, (0, 0, 255), -1)
    cv2.circle(img, extRight, 8, (0, 255, 0), -1)
    #cv2.imshow('finger_tip', drawing2)

    #------------------------------------------

    # finding convex hull
    hull = cv2.convexHull(cnt, returnPoints=False)

    # finding convexity defects
    defects = cv2.convexityDefects(cnt, hull)

    #-----------------------learn from this?--------------------------------
    count_defects = 0
    cv2.drawContours(thresh, contours, -1, (0, 255, 0), 3)

    # applying Cosine Rule to find angle for all defects (between fingers)
    # with angle > 90 degrees and ignore defects
    try:
        for i in range(defects.shape[0]):
            s,e,f,d = defects[i,0]

            start = tuple(cnt[s][0])
            end = tuple(cnt[e][0])
            far = tuple(cnt[f][0])

            # find length of all sides of triangle
            a = math.sqrt((end[0] - start[0])**2 + (end[1] - start[1])**2)
            b = math.sqrt((far[0] - start[0])**2 + (far[1] - start[1])**2)
            c = math.sqrt((end[0] - far[0])**2 + (end[1] - far[1])**2)

            # apply cosine rule here
            angle = math.acos((b**2 + c**2 - a**2)/(2*b*c)) * 57

            # ignore angles > 90 and highlight rest with red dots
            if angle <= 90:
                count_defects += 1
                cv2.circle(img2, far, 1, [0,0,255], -1)
            #dist = cv2.pointPolygonTest(cnt,far,True)

            # draw a line from start to end i.e. the convex points (finger tips)
            # (can skip this part)
            cv2.line(img2,start, end, [0,255,0], 2)
            #cv2.circle(crop_img,far,5,[0,0,255],-1)
    except:
        print("this is skipped")
    #---------------------------------------------------
    #im2, contours, hierarchy = cv2.findContours(thresh, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
    #cv2.drawContours(img, contours, -1, (0,255,0), 3)
    #im2 = cv2.fastNlMeansDenoisingMulti(img, 2, 5, None, 4, 7, 35)
    # define actions required
    if count_defects == 1:
        cv2.putText(img,"Forward", (50, 50), cv2.FONT_HERSHEY_SIMPLEX, 2, 2)
        click2('U')
        
    elif count_defects == 2:
        
        click2('D')
        
        cv2.putText(img, "back", (20, 20), cv2.FONT_HERSHEY_SIMPLEX, 1, 2)
    elif count_defects == 3:
        
        click2('L')
        cv2.putText(img,"turn left", (20, 20), cv2.FONT_HERSHEY_SIMPLEX, 2, 2)
    elif count_defects == 4:
       
        click2('R')
        cv2.putText(img,"turn right", (20, 20), cv2.FONT_HERSHEY_SIMPLEX, 2, 2)
    else:
        
        cv2.putText(img,"So Cool", (20, 20),\
                    cv2.FONT_HERSHEY_SIMPLEX, 2, 2)

    # show appropriate images in windows
    cv2.imshow('Gesture', img)
    all_img = np.hstack((drawing, img2))
    #all_img = np.hstack((drawing2, img33))
    cv2.imshow('Contours', all_img)




    cv2.imshow('img',img)
    k = cv2.waitKey(30) & 0xff

    if k == 27:
        cap.release()
        cv2.destroyAllWindows()
    threading.Timer(0.05, camera).start()
def on_off ():
    global on_or_off
    if on_or_off == 0:
        on_or_off = 1
    else:
        on_or_off = 0

#====================sounds================================
def sound_play(name):
    pygame.mixer.init()
    pygame.mixer.music.load(name)
    pygame.mixer.music.play()
def Pause_music():
    pygame.mixer.music.pause()

def UNPause_music():
    pygame.mixer.music.unpause()
def go_away(music):
    pygame.mixer.music.stop()
#=============================================================
def voice():
        
        #voicer = tkinter.Tk()
        #voicer.title("listening")
        #voicer.geometry("500x600")
            
            #AUDIO_FILE = path.join(path.dirname(path.realpath(__file__)), "test.flac")
        r = sr.Recognizer()
            
            #with sr.AudioFile(AUDIO_FILE) as source:
        with sr.Microphone(device_index = 1, sample_rate = 44100, chunk_size = 512) as source:
                #r.adjust_for_ambient_noise(source, 0.5)
                #r.dynamic_energy_threshold = True
             audio = r.listen(source, timeout = 2)
                
                #audio = r.record(source) # read the entire audio file

        try:
                if (r.recognize_google(audio, language="en")) == "forward":
                    click3('O')
                    
                elif (r.recognize_google(audio, language="en")) == "left":
                    click3('P')
                    
                elif (r.recognize_google(audio, language="en")) == "right":
                    click3('X')
                    
                elif (r.recognize_google(audio, language="en")) == "back":
                    click3('N')
                    
                elif (r.recognize_google(audio, language="en")) == "stop":
                    click3('S')
                    
                print("You said " + r.recognize_google(audio, language="en"))
                #voicer.destroy()
                
        except sr.UnknownValueError:
                    print("cannot understand")
                    #speak("I cannot understand you!")
                    #tkinter.messagebox.showinfo("What did you say?", "Could not understand audio")
                    #voicer.destroy()
       
                    #voicer.destroy()
        #leaving = tkinter.Button(voicer, height = "5", width = "20", text = "Quit", command=lambda voicer=voicer:quiting(voicer))
        #leaving.pack()
        #voicer.mainloop()
        #voicer.after(1000, callback_voice)
camera()

root = tk.Tk()
root.configure(bg = "black")
def reading():
    global once, yes, ogg
    start = ser.readline().decode('ascii').strip('\r\n')
    if(not (start == '1' or start == '10' )):
        secret_num = int(ser.readline().decode('ascii').strip('\r\n'))
        lab.config(text=start)
    else:
        secret_num = int(start)
    
    print(secret_num)
    if(secret_num == 10 and once == 1):
        once = 0
        sound_play("fatality_theme.ogg")
        yes = 1
    if yes == 1:
        yes = 0
        
        sound_play("hugh_fatality.ogg")
    root.after(50, reading)
        
    #threading.Timer(1000, reading).start()
def check_colour():
    if peeking == 1:
         button7.configure(fg = "green")
    else:
        button7.configure(fg = "gray")
    
def check_colour_8():
    if finger_count == 1:
         button8.configure(fg = "blue")
    else:
        button8.configure(fg = "gray")
    #window.after(100, check_colour)
def reader ():
    global ogg
    if ogg == 1:
        ogg = 0
    else:
        ogg = 1
#==================================================================================================================
lab1 = tk.Label(root, width=20,text = "Command", font=("Helvetica", 15), fg="black")
lab1.grid(row = 1, column = 6)

lab = tk.Label(root, width=20, font=("Helvetica", 20), fg="blue")
lab.grid(row = 2, column = 6)
lab.config(text="0")

button1 = tk.Button(root, height = "5", width = "15", text = "on_off", command = on_off)
button1.grid(row = 1, column = 0)

button2 = tk.Button(root, height = "5", width = "10", text = "⯇", font=30,command=lambda root=root:click('L'))
button2.grid(row = 3, column = 0)

button3 = tk.Button(root, height = "5", width = "10", text = "⯅",  font=30,command=lambda root=root:click('U'))
button3.grid(row = 2, column = 1),

button4 = tk.Button(root, height = "5", width = "10", text = "⯈",font=30, command=lambda root=root:click('R'))
button4.grid(row = 3, column = 2)

button5 = tk.Button(root, height = "5", width = "10", text = "⯆",font=30, command=lambda root=root:click('D'))
button5.grid(row = 4, column = 1)

button6 = tk.Button(root, height = "5", width = "10", text = "⯀", font=30, command = lambda root=root:click('S'))
button6.grid(row = 3, column = 1)

button7 = tk.Button(root, height = "3", width = "6", text = "⚫", font=30, command = peek)
button7.grid(row = 2, column = 4)

button8 = tk.Button(root, height = "3", width = "6", text = "⚫", font=30, command = fingers)
button8.grid(row = 1, column = 4)

button9 = tk.Button(root, height = "5", width = "20", text = "voice", command = voice)
button9.grid(row = 4, column = 3)

button10 = tk.Button(root, height = "5", width = "20", text = "read it", command = reading)
button10.grid(row = 3, column = 6)


Pause = tk.Button(root, height = "5", width = "15", text = "Pause sound", command = Pause_music)
Pause.grid(row = 4, column = 5)
unPause = tk.Button(root, height = "5", width = "15", text = "Unpause sound", command = UNPause_music)
unPause.grid(row = 4, column = 6)

app = spinning_bastard(root,b'C:\Users\zhika\Desktop\ELEC 291\Project 1/image.png')

#reading()

root.mainloop()

cap.release()
cv2.destroyAllWindows()

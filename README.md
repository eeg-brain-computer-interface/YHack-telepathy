YHack-telepathy
===============

Attempt to detect p300 event related potential as a brain gesture for paralyzed patients to communicate through computers.

##Progress
Calibration system is complete. From the calibration system, there is a machine learning process that uses the calibration data as a training set, and should become able to distinguish between events when the brain signal has and has not occured.

Currently the feature extraction is incomplete, and the machine learning algorithm is missing regularization to prevent overfitting.

##How to run

###Calibration system
####Requirements
* MatLab (with Signal Processing Toolkit)
* EEGLab
* PsychToolbox
* Python
* Muse EEG Headband SDK

####Instructions
* Pair Muse with computer by bluetooth
* Run in terminal: muse-io --preset 14 --dsp --osc.udp://localhost:5000
  (you will need an extra --device DEVICENAME option if you are using a loaned Muse at a hackathon, rather than a commercial Muse)
* Wear Muse
* Run stroop\_test\_demo.m in MatLab, and follow the displayed instructions

###Machine learning system

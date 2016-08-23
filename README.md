# Behavioral Tasks


# Purpose

The following programs are designed to collect data on various elements of human learning and decision making utilizing reaching-based behavioral tasks:

##Task 1

Task 1 collects data on how humans' decisions and forage strategies in reaching-based behavioral tasks are affected by reward, reaching distance, probability of reward, and precision. This task involves human subjects using a controller to forage among two circular target areas for the reward-yielding one. The five used probabilities are randomly shuffled and changed for each block of the experiment. The reach for the left target area is also shuffled (different for each half of trials per session).

##Task 2

Task 2 is designed to collect data on whether humans learn faster by reaching outward or inward as well as their strategies. This task involves human subjects using a wheel computer mouse to move outward from a start area onto a specific ring area—on which the subjects move inwards to begin the next trial (resets mouse position to center). If subjects first move beyond the correct ring area, then inwards, the test subject must return inside the correct ring area then reach outwards again.
The ring area grows outwards for 4 blocks, then shrinks inwards for 3 blocks.
 
# Configuration of Task 1

## Using Ultrasonic sensors

###Ultrasonic configuration
Ensure the ultrasonic rig has one ultrasonic sensor facing forward and one facing leftwards
Check that the Ultrasonic sensors are connected to the Arduino pins set forth in comm/commtest.ino
(Or you can change the pin configuration in comm/commtest.ino)

	#define tp1 3//trigger pin of forward facing sensor
	#define ep1 2//echo pin of forward facing sensor
	#define tp2 5//trigger pin of leftward facing sensor
	#define ep2 4//echo pin of leftward facing sensor
In doing so, then upload comm/commtest.ino onto the Arduino (check bluetooth ports)	

###Task 1 variables
Then, go to task1/task1.pde and set `ultrasonicmode = 1` on line 88 to enable ultrasonic sensing.  
For the other variables in lines 88-108, namely, `utgd, utgdx,usd, x0u, y0u`, modify them according to rig specifications.  
When using ultrasonic sensors, the code will automatically convert the metric rig parameters as well as test subject's x and y coordinates in centimeters,
into display(monitor) values for screen display purposes.  Nonetheless, all csv data outputted by the code will remain in metric measurements.  
The documentation of the variables is provided within task 1's code.

## Using Computer Mouse

### Task1 variables
Since ultrasonic sensors will not be used, set `ultrasonicmode = 0` on line 88.  
All that is further required is that the user press the 'play' button on the processing sketch.

##Graphics
If you want to have some graphics, set `graphics = 1`
Doing so will replace the cursor with an animated mouse and provide animations for right and wrong reaches

<img src="https://github.com/bnhwa/datapak/blob/master/docs/maus1.png " width="400" height="250" />
<img src="https://github.com/bnhwa/datapak/blob/master/docs/maus2.png " width="400" height="250" />

#Task 1
###STEP 1

At the beginning of each task, test subjects are prompted by the computer to provide their unique identifiers.
<img src="https://github.com/bnhwa/datapak/blob/master/docs/t1typename.png " width="400" height="250" />

###STEP 2
<img src="https://github.com/bnhwa/datapak/blob/master/docs/t1practice1.png " width="400" height="250" />

Subjects begin by using their controllers to move onto the start/collection area, which initiates a practice round of 10 trials in which two target areas are shown.

###STEP 3
<img src="https://github.com/bnhwa/datapak/blob/master/docs/t1practice2.png " width="400" height="250" />

Subjects then are prompted to move and select between the two probabalistically determined reward areas (shown above).

###STEP 4
<img src="https://github.com/bnhwa/datapak/blob/master/docs/t1practice4.png " width="400" height="250" />

When subjects move onto the correct area, that and both area flashes and dissapears respectively.
Then, subjects are prompted to move back towards the start/collection area.  When the subject is back on the start area, the next trial begins and the aforementioned steps repeat. However, following the practice round, target areas are no longer visible; though, when the subject moves on the correct target area, that area flashes briefly.

<img src="https://github.com/bnhwa/datapak/blob/master/docs/t1half.png " width="400" height="250" />

Moreover, as mentioned earlier, for the second half of trials, the left target area moves switches to another reach.

##Task 2

###Step 1
<img src="https://github.com/bnhwa/datapak/blob/master/docs/t2practice1.png " width="400" height="250" />

First, subjects begin by using their computer mouses to move onto the start area, triggering the practice round. For the practice rounds and trials alike, once the player is on the correct area, the player holds the up button, while keeping the mouse still. While this is being done, a bar will extend, denoting the length of minimum time needed to press the up key. If the up key is held down continually and the bar disappears, the subject is not over the correct area. Otherwise, if the subject is on the correct area and satisfies the aforementioned conditions, that ring will flash briefly.

##Step 2
<img src="https://github.com/bnhwa/datapak/blob/master/docs/t2practice2.png " width="400" height="250" />
<img src="https://github.com/bnhwa/datapak/blob/master/docs/t2practice3.png " width="400" height="250" />
<img src="https://github.com/bnhwa/datapak/blob/master/docs/t2practice4.png " width="400" height="250" />
<img src="https://github.com/bnhwa/datapak/blob/master/docs/t2practice5.png " width="400" height="250" />
<img src="https://github.com/bnhwa/datapak/blob/master/docs/t2practice6.png " width="400" height="250" />
<img src="https://github.com/bnhwa/datapak/blob/master/docs/t2practice7.png " width="400" height="250" />

Then, as denoted by the screen text, the subject will be prompted to move either inward or outward, fullfilling the aforementioned conditions.

##Step 3
<img src="https://github.com/bnhwa/datapak/blob/master/docs/t2trial.png " width="400" height="250" />

However, following the practice round, the rings are no longer visible; though, when the subject moves on the correct ring and fullfills the necessary conditions, that ring will ring flash briefly

#Data analysis code
##Information
`datainit.m` provides data analysis for task 1 (2 target task)
##Configuration
The required functions are stored in data_anal/necessary functions/
please add them to the MATLAB search path
In doing so, then change the variables in data_anal, e.g.,

	
    filepath = '/Users/hwab/Dropbox (HHMI)/2015-16 experiment/task1/DataBuffer/trialdata/';
	% GET DIRECTORY FOR TASK 1 trialdata
	filepathp = '/Users/hwab/Dropbox (HHMI)/2015-16 experiment/task1/DataBuffer/positiondata/';
	opalt = 0;%include opal model alongside user choice probability over time
	acv = 0.1;%ac value
	trajec = 1;% get user choice/right or wrong from offline trajectory sorter
	
`filepath` is the directory for `task1/DataBuffer/trialdata`
`filepathp` is the directory for `task1/DataBuffer/positiondata`
setting `opalt` to 1 adds opal model simulation to user choice over time(trials) graph; setting it to 0 turns it off
`acv` is the initial ac value for the OPAL model simulation
setting `trajec = 1' gets test subject choice data (their choice /rightorwrong) from the trajectory analysis
setting `trajec = 0' gets test subject choice data (their choice /rightorwrong)from task 1's online sorter
	
Do not mix up versions of the task; example data
# Behavioral Tasks


# Purpose

The following programs are designed to collect data on various elements of human learning and decision making utilizing reaching-based behavioral tasks:

##Task 1

Task 1 collects data on how humans' decisions in reaching-based behavioral tasks are affected by reward, reaching distance, probabalistic inferral, and precision. This task involves human subjects using a computer mouse to move between a start/collection area and two probabalistically determined circular target areas. The five used probabilities are randomly shuffled initially and changed for each block of the experiment. For the first half of trials, two target areas are horizontally and vertically equidistant from the start/collection area. For the remainder of trials however, the left target area is moved vertically further from its original position.


##Task 2

Task 2 is designed to collect data on whether humans learn faster by reaching outward or inward based. This task involves human subjects using a computer mouse to move outward from a start area onto 3 of equally spaced rings and back. Once on the correct ring area (which becomes invisible after the practice round) the player holds the up button, while keeping the mouse still. While this is being done, a bar will extend, denoting the length of minimum time needed to press the up key. If the up key is held down continually and the bar disappears, the subject is not over the correct area. Once the subject is on the correct ring area and meets the aforementioned conditions, the ring flashes, and the subject must move inward or outward, denoted by the text on the screen.  The spacing between rings is taken from a set of 3 existing distances, which are shuffled randomly and changed every block of trials.
 
# Usage
<img src="https://github.com/bnhwa/datapak/blob/master/docs/t1typename.png " width="400" height="250" />
If utilizing ultrasonic sensors, first upload comm/commtest.ino to the arduino
Ensure that 
Go to task1/task1.pde and change the variable "ultrasonicmode" to 1

At the beginning of each task, test subjects are prompted by the computer to provide their names.

##Task 1

###STEP 1
<img src="https://github.com/bnhwa/datapak/blob/master/docs/t1practice1.png " width="400" height="250" />

First, subjects begin by using their controllers to move onto the start/collection area, which initiates a practice round in which two target areas are shown.

###STEP 2
<img src="https://github.com/bnhwa/datapak/blob/master/docs/t1practice2.png " width="400" height="250" />

Subjects then are prompted to move and select between the two probabalistically determined reward areas (shown above).

###STEP 3
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

The required functions are stored in data_anal/necessary functions/
please add them to the MATLAB search path
In doing so, 
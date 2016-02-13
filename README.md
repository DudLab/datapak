# Behavioral Tasks


# Purpose

The following programs are designed to collect data on various elements of human learning and decision making utilizing reaching-based behavioral tasks:

##Task 1

Task 1 collects data on how humans' decisions in reaching-based behavioral tasks are affected by reward, reaching distance, probabalistic inferral, and precision. This task involves human subjects using a computer mouse to move between a start/collection area and two probabalistically determined circular target areas. The five used probabilities are randomly shuffled initially and changed for each block of the experiment. For the first half of trials, two target areas are horizontally and vertically equidistant from the start/collection area. For the remainder of trials however, the left target area is moved vertically further from its original position.

Within this task, subjects begin by moving onto the start/collection area. Then, subjects are to choose between two reward boxes, which have set probabilities of bearing the reward.  The five projectsbabilities, which are randomly assorted, change for each block.  Following the halfway point of 250 trials, the left reward area moves further away from the start area. 

##Task 2
<img src="https://github.com/bnhwa/datapak/blob/master/docs/t1practice1.png " width="400" height="250" />
Task 2 is designed to collect data on whether humans learn faster by reaching outward or inward based.

# Usage
![t1typename.png](t1typename1.png =400x250)

At the beginning of each task, test subjects are prompted by the computer to provide their names.

##Task 1

###STEP 1
![t1practice1.png](t1practice1.png =400x250)

First, subjects begin by using their computer mouses to move onto the start/collection area, which initiates a practice round in which two target areas are shown.

![t1practice2.png](t1practice1.png =400x250)
Subjects then are prompted to move and select between the two probabalistically determined reward areas (shown above).

When subjects move onto the correct area, that and both area flashes and dissapears respectively.
Then, subjects are prompted to move back towards the start/collection area.  This action then initiates the next trial, in which the aforementioned steps repeat.

However, following the practice round, target areas are no longer visible; however, when the target moves on the correct target area, that area periodically flashes.

Moreover, as mentioned above, for the second half of trials, the left target area moves vertically further from its original position.


##Preview Usage

Execution of the program consists of the program name and a single argument: the time desired length of the camera preview (in seconds). Additionally, the user can exit at any time by entering `Ctrl + c`

    mouse-preview 60

##Recorder Usage

Execution of the program consists of the program name and respectve arguments: time to record before trigger event (in seconds), time to record after (in seconds), and directory of the file to be saved into. An example is shown below:

    sudo mouse-record 2 2 /home/pi/Desktop

Also, as mentioned before, the program will end when a `KeyboardInterrupt`(Ctrl + c) is entered into the terminal.


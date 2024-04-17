# Olympic Swimming Simulation

This program creates a graphic simulation of the swimming races of the Tokyo 2020 Summer Olympics. It creates
the simulation by reading a special type of file ending in .swm. To run the program, the user must call the
run function, which takes in a tick interval, pixels per meter, and a path leading to a directory of .swm files.
The recommended tick interval is 1/30, the recommended pixels per meter is 25, and there are template .swm files
in the races folder, so the recommended way to call the function is '(run 1/30 25 "races")'. Upon calling the
run function, the directory is opened and the user can select a race by pressing the corresponding letter. The
race begins when the mouse is clicked. The playback speed can be adjusted by pressing the 1, 2, 4, and 8 keys to
set the speed to 1x, 2x, 4x, and 8x speed, respectively.

The user can also create their own race templates. To do so, create a .swm file within the races folder and enter
the following information in the following format:
  gender:w or m
  distance:int representing number of meters, pool is 50 meters across (must be multiple of 50)
  stroke:Freestyle, Backstroke, Breaststroke, or Butterfly
  event:event name
  date:d|m|y
  result:1|lname|fname|3-letter country abbreviation|height|list of splits
  ...
  result:n|lname|fname|3-letter country abbreviation|height|list of splits

The lines can come in any order. The simulator supports up to eight results, i.e. swimmers. The list of splits
represents the time taken to get across the pool for each 50 meter section of the race. Splits should be
separated by commas (but no space), e.g. "26.36,29.86". If the race is only 50 meters, the splits will only
contain one number. See the .swm files for more details.

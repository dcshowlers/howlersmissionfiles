# howlersmissionfiles
The files and scripts used for our training mission.  These also make our livery for the VNAO ready room work.  If you are looking for the livery files to sync with your ready room for the squadron, please visit https://github.com/dcshowlers/readyroomfiles

SETUP:
1.  Create a folder in your C:\Users\yourusername\Saved Games\DCS\Logs\ folder called Stats
2.  move the roster.csv and greenieBoardMaker.R files to that folder
3.  Install R from https://www.r-project.org/
4.  Feel free to use the HowlersLSOScript.lua in your own missions, our training mission is provided to see an example of its use.

USE (GREENIE BOARD CREATION):
1.  Edit the roster.csv with a simple list of pilot names.  These names must appear exactly as the users callsigns in MP DCS or their landings will be filtered out.
2.  When the mission is complete, run the R script, it will create a PNG file in the output directory of the current month's greenie board.  
3.  None of the data in the LSO grading file is ever deleted, it is all parsed each time the R script is run.  This enables you to add pilots or create other scoring metrics.

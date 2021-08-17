# howlersmissionfiles
The files and scripts used for our training mission.  These also make our livery for the VNAO ready room work.  If you are looking for the livery files to sync with your ready room for the squadron, please visit https://github.com/dcshowlers/readyroomfiles

SETUP for VERSION 1.0.2:
1.  Create a folder in your C:\Users\yourusername\Saved Games\DCS\Logs\ folder called Stats
2.  move the roster.csv, lsoscores.lua and greenieBoardMaker.R files to that folder
3.  Install R from https://www.r-project.org/
4.  Within R, install the following packages: flextable, officer, gridExtra, webshot (This can be done with the command install.packages("PACKAGE NAME").)
5.  Feel free to use the HowlersLSOScript.lua in your own missions, a demo mission is provided to see an example of its use.
6.  The LSO Script requires that missionscripting.lua be de-sanitized so that it can write to the output file.

USE (GREENIE BOARD CREATION):
1.  Edit the roster.csv with your list of pilot names.  These names must appear exactly as the users callsigns in MP DCS or their landings will be filtered out.  The order that they appear in the list is the order that they will appear on the greenie board.
2.  When the mission is complete, run the R script, it will create a PNG file in the output directory of the current month's greenie board.  
3.  None of the data in the LSO grading file is ever deleted, it is all parsed each time the R script is run.  This enables you to add pilots or create other scoring metrics.  It also enables you to add landings that the system missed.

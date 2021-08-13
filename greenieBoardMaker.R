# Bunny's Greenie Board Maker
# version 1.0
# takes data from Bunny's LSO Score Recording Script

library(flextable)
library(officer)
library(gridExtra)
library(webshot)

setwd("C:/Users/mtill/Saved Games/DCS.openbeta_server/Logs/Stats")
inputFile <- "lsoscores.lua"
squadronName <- "The Howlers'"

greenie_score <- function(grade) {
  # scoring information
  # _OK_ = 5
  # OK = 4
  # FAIR = 3
  # NO GRADE = 2
  # WAVE OFF = 0
  # CUT = 0
  # BOLTER = 2.5
  # NIGHT =
  
  if (grade=="_OK_") {
    print(5)
  } else if (grade=="OK") {
    print(4)
  } else if (grade=="(OK)") {
    print(3)
  } else if (grade=="C") {
    print(0)
  } else if (grade=="---") {
    print(2)
  } else if (grade=="B") {
    print(2.5)
  } else {
    print(0)
  }
}

grade_finder<- function(grade) {
  if (grepl("GRADE:OK",grade, fixed=TRUE)) {
    print("OK")
  } else if (grepl("GRADE:_OK_",grade, fixed=TRUE)){
    print("_OK_")
  } else if (grepl("GRADE:C ",grade,fixed=TRUE)){
    print("C")
  } else if (grepl("GRADE:WO ",grade,fixed=TRUE)){
    print("WO")
  } else if (grepl("GRADE:--- ",grade,fixed=TRUE)){
    print("---")
  } else if (grepl("GRADE:(OK) ",grade,fixed=TRUE)){
    print("(OK)")
  } else if (grepl("GRADE:B ",grade,fixed=TRUE)){
    print("B")
  } else {
    print(0)  
  }
}

substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}

# change this to fit your needs
workingDir = "/Users/mtill/Saved Games/DCS/Logs/Stats"
data<-read.csv(inputFile)
#data <- data[nrow(data):1,] #sort from newest to oldest
gbd<-read.csv("roster.csv")
gbd$Average<-0
gbd$Traps<-0
for (k in 1:30) {
  gbd[,k+3] <-0
}

currentMonth <- substr(date(),5,7)
currentYear <- substrRight(date(),4)

# steps
# for all lines in data (working backwards, or not) [DONE]
# see if pilot is one of the pilots on the greenie board [DONE]
# in order from 1-20, put a score/type (string) in each field [DONE]
# when done, create an average score for each pilot (a function might work well here) [DONE]
# create a chart showing this with formatting [DRAFT]
# output the chart as a jpeg/png
# need to somehow make it a monthly chart [DONE]
# add a header to the chart

for (i in 1:nrow(data)) {
  pilotRow <- match(data$pilot[i], gbd$Pilot)
  flightMonth <- substr(data$date[i],5,7)
  if ((is.na(pilotRow) == FALSE) && (flightMonth == currentMonth) ) {
    #it is a real pilot
    #add one to pilot traps
    gbd$Traps[pilotRow] <- gbd$Traps[pilotRow] + 1     
    #put the score in the right place
    score <- grade_finder(data$grade[i])
    lsoPoints <- greenie_score(score)
    gbd$Average[pilotRow] <- gbd$Average[pilotRow] + lsoPoints 
    aircraftType <- toString(data$platform[i])
    gbd[pilotRow,gbd$Traps[pilotRow] + 3] <- score
  }
  
}

for (j in 1:nrow(gbd)) {
  gbd$Average[j] <- gbd$Average[j]/gbd$Traps[j]
}

#fill out the table with blank space
currentRows <- nrow(gbd)
if (currentRows < 12) {
  gbd[(currentRows+1):12,] <- " "
}

ok_Color = "green"
okColor = "green"
cutColor = "red"
fColor = "yellow"
ngColor = "orange"
bolterColor = "blue"
woColor = "purple"

title <- paste(squadronName," Greenie Board")
subtitle <- paste("for the month of",currentMonth,currentYear,sep=" ")

gbdTable<-flextable(gbd)

#cut and WO color are not working
bgcolormatrix <- ifelse(gbd == "OK", okColor, ifelse(gbd == "_OK_", okColor, ifelse(gbd == "C", cutColor, ifelse(gbd == "F", fColor, ifelse(gbd == "---", ngColor, ifelse(gbd == "WO", woColor, ifelse(gbd == "B", bolterColor, "white")))))))
fontcolormatrix <- ifelse(gbd == "0","white","black")
gbdTable<-set_header_labels(gbdTable, V4="V44",V5="V45",V6="V46",V7="V47",V8="V48",V9="V49")
gbdTable <- bg(gbdTable, bg=bgcolormatrix)
gbdTable <- color(gbdTable, color=fontcolormatrix)
gbdTable<-align(gbdTable, part="body", align="center")
gbdTable<-align(gbdTable, j=1, align="left")
gbdTable<-bold(gbdTable, j=1, bold=TRUE)
gbdTable<-bold(gbdTable, part="header", bold=TRUE)
gbdTable<-color(gbdTable, j=1, color="red")
big_border = fp_border(color="black", width = 2)
bigger_border = fp_border(color = "blue", width = 6 )
gbdTable<-border_inner(gbdTable, part="all",border=big_border)
gbdTable<-border_outer(gbdTable, part="all",border=big_border)
gbdTable<-color(gbdTable, part="body", j=2, color="black")
gbdTable<-add_header_lines(gbdTable, values = subtitle)
gbdTable<-add_header_lines(gbdTable, values = title)
gbdTable<-fontsize(gbdTable, j=1, size = 20)
gbdTable<-fontsize(gbdTable, part="header", i=1, size = 40)
gbdTable<-fontsize(gbdTable, part="header", i=2, size = 20)
gbdTable<-color(gbdTable, part="header", j=4:33, color="black")
gbdTable<-bg(gbdTable, part = "header", bg = "gray")
gbdTable<-bg(gbdTable, part = "header", i=3, bg = "black")
gbdTable<-color(gbdTable, part="header", j=1:3, i=3, color="gray")
gbdTable<-border_outer(gbdTable, part="body", border=bigger_border)
#gbdTable<-border_outer(gbdTable, part="header", border=bigger_border)
gbdTable<-height(gbdTable, height = .5) %>% 
  hrule(rule = "exact", part = "body") %>% 
  width(width=.5) %>%
  set_table_properties(layout="fixed")

#make a filename
#save to different directory
outFile <- paste("C:/Users/mtill/Google Drive/VFA469/Greenie Boards/",currentMonth,currentYear,"HowlersGreenie.png", sep="")
flextable::save_as_image(gbdTable,outFile)

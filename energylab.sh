#!/usr/bin/env bash

# labsum is the sum of lab report grades
# fin is final grade.

awk ' BEGIN {

FS=",|\t";
OFS=",";

printf "Last Name, First Name, Username, Student ID, Lab01, Lab02, Lab03, Lab04, Lab05, Lab06, Survey, Final Exam, Final Grade, Letter Grade\n"

} NR>1 {

labsum=($12+$9+$10+$11+$14+$15);

fin=(0.1*labsum+0.2*($13+$16));

if ( fin >=93 ) { lg="A" }

else if ( fin>=89.33 && fin<=92.99 ) { lg="A-" }

else if ( fin>=85.67 && fin<=89.32 ) { lg="B+" }

else if ( fin>=82.00 && fin<=85.66 ) { lg="B" }

else if ( fin>=78.33 && fin<=81.99 ) { lg="B-" }

else if ( fin>=74.67 && fin<=78.32 ) { lg="C+" }

else if ( fin>=71.00 && fin<=74.66 ) { lg="C" }

else if ( fin>=67.33 && fin<=70.99 ) { lg="C-" }

else if ( fin>=63.67 && fin<=67.32 ) { lg="D+" }

else if ( fin>=60.00 && fin<=63.66 ) { lg="D" }

else { lg="F" }

sum+=fin; print $1, $2, $3, $4, $9, $10, $11, $12, $14, $15, $16, $13, fin, lg } END {

print "\n\nCLASS AVERAGE", sum/NR } ' $1

# > Energy_Lab_Final_Grade.csv

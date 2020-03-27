/* Jessica McCallum 8417055 */

/* creating a library to read code and a different library where new 
datasets are saved */
libname epi "Z:\EPI5143\Code";
libname ex "Z:\EPI5143\Workfolder";

/* Creating a new dataset with data from 2003 */
data spine;
set epi.Nencounter;
if year(datepart(EncStartDtm))=2003;
run;

/* sorting by patient number */
proc sort data=spine out=spine1;
by EncPatWID;
run;

/* QUESTION 1a */
/* couting inpatient visits */

data spine4;
set spine1;
by EncPatWID;
If first.EncPatWID then do; visit=0;count=0;
end;
if EncVisitTypeCd in:('INPT') then do; 
visit=1;count=count+1;end;
If last.EncPatWID then output;
retain visit count;
run;

proc freq data=spine4;
tables visit count;
run;

/*  1074 patients had at least 1 inpatient encounter in 2013*/


/* Question 1b */
/* counting emerg visits */
data spine3;
set spine1;
by EncPatWID;
If first.EncPatWID then do; visit=0;count=0;
end;
if EncVisitTypeCd in:('EMERG') then do; 
visit=1;count=count+1;end;
If last.EncPatWID then output;
retain visit count;
run;

proc freq data=spine3;
tables visit count;
run;

/* 1978 patients had at least one emergency department encounter in 2003 */

/*counting both */
data spine2;
set spine1;
by EncPatWID;
If first.EncPatWID then do; visit=0;count=0;
end;
if EncVisitTypeCd in:('INPT' 'EMERG') then do; 
visit=1;count=count+1;end;
If last.EncPatWID then output;
retain visit count;
run;

proc freq data=spine2;
tables visit count;
run;

/* 2891 patients had at least 1 emergency department or inpatient encounter in 2003 */

/* flat filing to check duplicates to verify number of unique patients */
proc sort data=spine out=spine6 nodupkey;
by EncPatWID;
run;

/* There were 2891 unique patients  */

/* Question 1d */

options formchar="|----|+|---+=|-/\<>*";
proc printto file="Z:/EPI5143/Workfolder/Quizzes/report.txt" new;
proc freq data=spine2 order=data;
tables count / outpct;
weight visit;
run;
proc printto;run;

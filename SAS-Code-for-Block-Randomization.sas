%let Seed=39859; 
/39859 or 94847 
%let BlockN=6; 
%let BlockSize=6; 
%let SubjectN=36; 
/SubjectN=BlockN*Blocksize//

title; 
footnote;

proc plan seed=&Seed; 
factors Block=&BlockN ordered Alloc=&BlockSize random Serial=1 of &SubjectN perm; 
output out=plan Allock cvals=('RRT' 'RTR' 'TRR' 'RRT' 'RTR' 'TRR'); 
run;

proc sort data=plan; 
by Serial; 
run;

data table; 
retain Serial Alloc; 
set plan;
where Serial<=33; /Within allocated subjects number/ 
if Alloc = 'RRT' then Inv='R->R->T'; 
if Alloc = 'RTR' then Inv='R->T->R'; 
if Alloc = 'TRR' then Inv='T->R->R';
rename Serial=Distribution Alloc=SubjectGroup Inv=Midterm; 
drop Block; 
run;

options printerpath=pdf; 
ods pdf file='G-Medicine_Randomization.pdf; ods escapechar='~';

title; 
footnote; 
title1 h=10pt f=tahoma j=left 'Site: Clinical Center' j=right 'Protocol No: G-2021-923-GH'; 
title2 h=10pt f=tahoma j=left 'Open-label' j=right 'Confidential'; 
itle4 h=14pt f=tahoma bold j=center 'Randomization Table'; 
title6 h=10pt f=tahoma j=left "Seed number: &Seed" j=right 'Date: ~{nbspace 30} (Signature)';

proc print data=table noobs style=[width=100%]; 
var Distribution SubjectGroup Midterm; 
run;

footnote6 h=9pt f=tahoma j-left 'mid T: Patient taken by oral one time the '130' on condition empty stomach.'; 
footnote7 h=9pt f=tahoma j-left 'mid R: Patient taken by oral one time the '120' on condition empty stomach.'; 
footnote9 h=10pt f=tahoma j=center '{thispage}/{lastpage}';

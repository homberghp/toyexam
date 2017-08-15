#!/usr/bin/perl -w
my ($recfile,$student);
my ($candid,$pw,$uid,$gid,$lname,$fname,$tussen,$mod,$cohort,$email,$pcn,$sclass,$home,$shell,$project,$year,$grp,$uxuid,$stick,$lang,$filename,$doclang);
$recfile='records.csv';
if ( ($#ARGV+1) > 0 ) {
    $recfile=$ARGV[0];
}
print qq(#!/bin/bash
mkdir -p out
);
open(REC,"<$recfile") or die qq(cannot open file records.csv, please correct\n);
my $count=0;
while(<REC>){
    $count++;
    chomp;
    ($candid,$pw,$uid,$gid,$lname,$fname,$tussen,$mod,$cohort,$email,$pcn,$sclass,$home,$shell,$project,$year,$grp,$uxuid,$stick,$doclang)= split/:/;
    $candid =~ s/^x//;
    if ( defined $tussen && $tussen ne '') {
	$student= join('~',($lname,$fname,$tussen,$candid));
    } else {
	$student= join('~',($lname,$fname,$candid));
    }
    $lang=lc($doclang);
    $filename = $student;
    $filename =~ s/~/_/g;
    print qq((
for i in 1 2; do
pdflatex -jobname=${filename} -output-directory out <<EOF > /dev/null
\\documentclass[dvipsnames,10pt,twoside,dvipsnames]{article}
\\usepackage[utf8]{inputenc}
\\providecommand\\StudentId{$student}
\\providecommand\\StudentNumber{$candid}
\\providecommand\\StickNr{${stick}}
\\providecommand\\Lang{${doclang}}
\\input assessmentdoc_$lang
EOF
done
)&
);
}
# make sure the program waits for all children 
print qq(
wait
echo latex compiled $count documents to dir ./out
);

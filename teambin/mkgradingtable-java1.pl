#!/usr/bin/perl -w
use Config::Properties;
use File::Path qw(make_path);
use Cwd;
my $weightSum=0;
my $jweightSum=0;
my $sweightSum=0;
my $minutes=0;
my $sminutes=0;
my $jminutes=0;
my $workdir= getcwd;
$workdir =~ m/.*(\d{4})(\d{2})(\d{2})$/;
my $defexam_date ="$1-$2-$3";

open PROPS, "<../default.properties" or die "unable to open setup file";

# if ( -d 'examproject'  && !-f 'project.xml_template' ) {
#   die "Need project.xml_template with examproject dir to populate project in repos\n";
# }

my $properties = new Config::Properties();
$properties->load(*PROPS);
my $module_name =$properties->getProperty('module_name','SEN1');
my $exam_date = $properties->getProperty('exam_date',$defexam_date);
my $exam_year = substr($exam_date,0,4);
my $exam_id = $module_name.'-'.$exam_date;
my $event=$exam_id;
my %jtaskHash;
my %staskHash;
$event =~ s/-//g;
my ($d,$q,$mod);
my ($question,$maxpoints);
my ($filepart,$tagpart);
open( PROC, qq(grep -r  STUDENT_ID  examproject |sort|)) or die qq(cannot find exam questions\n) ;
while(<PROC>){
    chomp;
    ($filepart,$tagpart) = split/:\s*/;
    if ($tagpart =~ m/.*?[\<\-]editor-fold\s+defaultstate=\"expanded\" desc=\"(\w+);.*?WEIGHT\s+?(\d+)/){
	$question= $1;
	$maxpoints=$2;
	$weightSum += $maxpoints;
	$question =~ s/_/\\_/g;
	$filename=$filepart;
	$filename =~ s/.*?examproject\///;
	$taskHash{$question}= qq($question & $maxpoints & $filename\\\\\\hline\n);
	$jweightSum += $maxpoints;
	
    }
}
close(PROC);
$minutes=$weightSum/5;
$jminutes=$jweightSum/5;
print qq(
\\section*{Grading}
The preliminary weights of the tasks, used in grading the exercises can be found in table~\\ref{tab:grading}. 

\\begin{table}
\\caption{\\label{tab:grading}Grading for performance assessment.}
\\begin{tabular}{|l|r|l|}\\hline
\\rowcolor{gray} {\\color{white}Task ID} & {\\color{white}points} &{\\color{white}Source File}\\\\\\hline\n);
foreach my $key (sort keys %taskHash) {
    print qq($taskHash{$key});
}
print qq(\\rowcolor{gray}{\\color{white}Total}& {\\color{white}$jweightSum} & {\\color{white}JAVA1 approximately $jminutes minutes of work.}\\\\\\hline\n);
print qq(\\end{tabular}\n\\end{table}\n);


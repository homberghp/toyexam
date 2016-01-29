#!/usr/bin/perl -w
# count questions and points for mc and open questions.
# The script makes specific assumptions about the
# directory layout of a project, fitting the fontys venlo way of working.
# %% <CourseDir>
# %% ├── builds
# %% │   ├── <ExamInstance>, e.g. 20120628
# %% │
# %% └── questions, and resources e.g.
# %%     ├── figures
# %%     ├── q1h01

sub countCat($$$);
my $defpoints=2;
if ($#ARGV < 0) {
  die "usage: countpoints.pl <sourcefile>\n";
}
my $source=$ARGV[0];
if ( !-e $source) {
  die  "file $source does not exists\n";
}
# read basedir and instance from source file
my ($basedir,$instance,$workdir);
open(SOURCE,"<$source") or die "cannot op sourcfe file $source\n";
while (<SOURCE>) {
  chomp;
  if (m/\\def\\CourseDir\{(.+)\}/){
    $basedir=$1;
  }
  if (m/\\def\\ExamInstance\{(.+)\}/){
    $instance=$1;
  }
}
close(SOURCE);
$workdir=$basedir.'/builds/'.$instance;
close(STDOUT);
open(STDOUT,">questioncount.tex");
countCat("$workdir/questions.tex",'amc',$defpoints);
$defpoints=5;
countCat("$workdir/openquestions.tex",'amcopen',$defpoints);
close(STDOUT);
exit 0;

sub countCat($$$) {
  my ($quest,$opencount,$openpoints,$mccount,$mcpoints);
  my ($qfile,$cat) = @_;
  if (open(QUESTIONS,"<$qfile")) {
    while (<QUESTIONS>) {
      chomp;
      next if (/^%/);
      s/\\element{general}{//;
      s/}}//;
      s/\\inputQ{/$basedir\/questions\//;
      $quest=$_;
      if (open(QUEST,"<$quest")) {
	$delta = $defpoints;
	while (<QUEST>) {
	  if (m/\%\%maxpoints=(\d+)/) {
	    $delta =$1;
	  }
	}
	$mccount++;
	$mcpoints +=$delta;
	close(QUEST);
      } else {
	print STDERR "WARNING: cannot open question file $quest\n";
      }
    }
    if (defined $mccount) {
      print qq(\\def\\${cat}count{$mccount}\n).
	qq(\\def\\${cat}points{$mcpoints}\n);
    }
    close(QUESTIONS);
  } else {
    print STDERR "WARNING: could not open file $qfile\n";
  }
}				# end of countCat.

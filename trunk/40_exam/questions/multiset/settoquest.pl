#!/usr/bin/perl -w
my ($base,$dir,$correctchoice,$num,$source,%hash,$realcount);
$source="multiset2.txt";
$dir='multi';
$num=1;
$base='provinciesteden';
my @choices;
open(SRC,"$source") or die qq(cannot open file $source\n);
while (<SRC>){
    chomp;
    next if m/^#/;
    if (m/^choices:/){
	s/^choices://;
	(@choices) = split ",";
    } else {
	($quest,$correctchoice)= split/;/;
	if (defined($quest)){
	    if (defined($correctchoice)){
		$hash{$quest}= $correctchoice;
	    } 
	}
    }
}
close(SRC);

foreach my $key1 (keys %hash) {
    my $qid = qq($dir-$base$num);
    my $fname=qq($base${num}.tex);
    open(FILE,">$fname") or die qq(cannot open $fname\n);
    print FILE qq(\\begin{questionmult}{$qid}
\\NL{In welke provincie ligt $key1?}
\\DE{In welcher Provinz liegt $key1?}
\\EN{In which province lies $key1?}
  \\begin{multicols}{3}
  \\begin{choices}
);
    for my $key2 (@choices) {
	if ($hash{$key1} eq $key2 ) {
	    print FILE qq(    \\correctchoice{$key2}\n);
	} else {
	    print FILE qq(    \\wrongchoice{$key2}\n);
	}
    }
    print FILE qq(  \\end{choices}
\\end{multicols}
\\end{questionmult});
    $num++;
    
print qq($key1 => $hash{$key1}\n);
    close(FILE);
}

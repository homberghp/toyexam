#!/usr/bin/perl -w

use File::Basename;
my ($filename,$basename,$flsname,$source,$target,$cmd, $path,%deps,@despA,$contin,@output);
# reads an latex recorder file (.fls)
if ($#ARGV < 0 ) {
    die qq(<need filename>);
}

$filename=$ARGV[0];
$filename =~s/\.$//; # trim of last dot if any
$basename=$filename;
$target=basename($filename).'.pdf';
$source=$filename.'.tex';
$flsname = basename($filename).'.fls'; # append .fls
if ( ! -r $flsname) {
    my @args=("pdflatex","-recorder","-interaction=batchmode",$filename);
    @output=`pdflatex -recorder -interaction=batchmode $filename; rm -f $target`;# or die qq(running @args fails $?\n);
}
open(FILE,"<$flsname") or die qq(cannot open $flsname, maybe you need to run "pdflatex -recorder $basename" once by hand
);
while(<FILE>){
    chomp;
    ($cmd, $path) = split/\s+/;
    if ($cmd =~ m/INPUT/ && $path !~ m/^\/usr\/share\// && $path !~ m/\.(out|aux|bbl)$/){
	if (! defined $deps{$path}) {
	    $deps{$path} = 1;
	    push( @depsA, $path );
	}
    }
}

print qq($target: );
$contin=qq( \\
\t);
foreach $path  (@depsA) {
    print qq($contin$path);
}
print qq(\n);

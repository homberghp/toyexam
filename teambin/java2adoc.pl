#!/usr/bin/perl -w
my $argc= $#ARGV + 1;
if ($argc < 1) {
  print STDERR qq(Usage java2adoc.pl javafilename\n);
  exit(1);
}
my $javapath =$ARGV[0];
my @fileparts=  split('/',$javapath);
my $javafile=$fileparts[$#fileparts];
my $adocfile=$javafile.'.adoc';
open (ADOC,">$adocfile") or die qq(cannot open adoc file $adocfile\n);
print ADOC qq(= $javafile 
:source-highlighter: coderay
:coderay-linenums-mode: inline
:theme: golo
:icons: font

[[${javafile}]]
[source,java,linenums]
----
include::${javapath}[]
----
link:${javapath}[source]
);
close(ADOC);
my @cmd=('asciidoctor', '-n',$adocfile);
print qq(@cmd\n);
system( @cmd) ;# or die qq(cannot run asciidoctor \n);

#!/usr/bin/perl -w
my ($file);
my $num_args = $#ARGV + 1;
my $element='general';
if ($num_args > 0) {
    # set and consume
    $element=shift;
}
while(<>){
  chomp;
  $file =$_;
  $file =~s/\.\.\/\.\.\/questions\///;
  print qq(\\element{$element}{\\inputQ{$file}}\n);
  
}

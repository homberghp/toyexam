#!/usr/bin/perl -w
my ($file);

while(<>){
  chomp;
  $file =$_;
  $file =~s/\.\.\/\.\.\/questions\///;
  print qq(\\element{general}{\\inputQ{$file}}\n);
  
}

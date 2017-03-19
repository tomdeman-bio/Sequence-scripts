#!/usr/bin/perl

#runs SPAdes assembler for single end IonTorrent reads in batch
#Written by Tom de Man

use warnings;
use strict;
use File::Basename;

my @files=@ARGV;

foreach my $file (@files){
	my ($file_name,$dir)=fileparse($file);
	my @base = split (/\./, $file_name);
	my $name = $base[0];
	
	my $cmd="spades.py -t 12 --iontorrent -k 21,33,55,77,99,127 --careful -s $file -o $name"."_assembly";
	print $cmd,"\n";
	die if system($cmd);
}

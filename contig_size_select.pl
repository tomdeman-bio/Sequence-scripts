#! /usr/bin/perl

#Copied from Umer Zeeshan Ijaz at University of Glasgow

use strict;
use Getopt::Long;

my ($low,$high)=(0,99999999);

GetOptions( "low=i"      => \$low,
            "high=i"        => \$high,
            "help|?"       => sub {Usage()}
          );
sub Usage
{
   print STDERR "perl $0 -low <lower_bound> -high <higher_bound> <fasta_file>\n\n";
   exit;
}
if (scalar(@ARGV)!=1) {print STDERR "Please give one input fasta file\n";&Usage;}

my $seq;
my $id;
my $len;
my @seq;
open (IN,"$ARGV[0]") or die ":$!";
while(<IN>)
{
    chomp;
    if(/^>(.*)/)
    {
       if ($seq){
            if ($seq=~/\d+/)
            {
                chop $seq;
                @seq = split /\s+/,$seq;
                $len=scalar(@seq);
            }
            else
            {
                $len=length ($seq);
            }
            if ($len>=$low and $len<=$high){
                print ">$id\n$seq\n";
            }
       }
       $id =$1;
       $seq ="";
    }
    else
    {
      if ($_ =~/\d+/) # for qual file
       {
           $seq .= $_." ";
       }
       else
       {
           $seq .= $_;
       }
    }
}
      if ($seq){
            if ($seq=~/\d+/)
            {
                chop $seq;
                @seq = split /\s+/,$seq;
                $len=scalar(@seq);
            }
            else
            {
                $len=length ($seq);
            }
            if ($len>=$low and $len<=$high){
                print ">$id\n$seq\n";
            }
      }

close IN;
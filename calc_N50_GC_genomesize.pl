#! /usr/bin/perl

#Written by Tom de Man
#Calculates basic contig stats like G+C content, N50, and number of contigs

use strict;
use warnings;
use List::Util qw(sum min max);
use Getopt::Long;
use File::Basename;

my $As = 0;
my $Ts = 0;
my $Gs = 0;
my $Cs = 0;
my $Ns = 0;

my $file;
my $helpAsked;
my $outFile = "";

GetOptions(
		"i=s" => \$file,
		"h|help" => \$helpAsked,
		"o|outputFile=s" => \$outFile,
		);

if(defined($helpAsked)) {
	Usage();
	exit;
}
if(!defined($file)) {
	Error("No input files are provided");
}

my ($fileName, $filePath) = fileparse($file);
$outFile = $file . "_n50_GC_genomesize_stats" if($outFile eq "");

open(IN, "<$file") or die "Cannot open file: $file\n";
open(OUT, ">$outFile") or die "Cannot open file: $outFile\n";

my @len = ();
my $prevFastaSeqId = "";
my $fastaSeqId = "";
my $fastaSeq = "";

while(<IN>) {
	chomp;
	if($_ =~ /^>/) {
		$prevFastaSeqId = $fastaSeqId;
		$fastaSeqId = $_;
		if($fastaSeq ne "") {
			push(@len, length $fastaSeq);
			baseCount($fastaSeq);
		}
		$fastaSeq = "";
	}
	else {
		$fastaSeq .= $_;
	}
}
close IN;

if($fastaSeq ne "") {
	$prevFastaSeqId = $fastaSeqId;
	push(@len, length $fastaSeq);
	baseCount($fastaSeq);
}
	
my $totalContigs = scalar @len;
my $bases = sum(@len);
my $minContigLen = min(@len);
my $maxContigLen = max(@len);
my $n50 = calcN50(\@len, 50);
my $GCcont = ($Gs+$Cs)/$bases*100;

#MMB sheet order
print "$totalContigs\t$bases\n";

printf OUT "%-25s %d\n", "Number of reads/contigs", $totalContigs;
printf OUT "%-25s %d\n", "Total assembly length", $bases;
#GC
printf OUT "%-25s %0.2f %s\n", "(G + C)s", ($Gs+$Cs)/$bases*100, "%";
#N50
printf OUT "%-25s %d\n", "N50 length", $n50;


print "Contig Statistics file: $outFile\n";
close OUT;
exit; 

sub calcN50 {
	my @x = @{$_[0]};
	my $n = $_[1];
	@x=sort{$b<=>$a} @x;
	my $total = sum(@x);
	my ($count, $n50)=(0,0);
	for (my $j=0; $j<@x; $j++){
		$count+=$x[$j];
		if(($count>=$total*$n/100)){
			$n50=$x[$j];
			last;
		}
	}
	return $n50;
}

sub baseCount {
	my $seq = $_[0];
	my $tAs += $seq =~ s/A/A/gi;
	my $tTs += $seq =~ s/T/T/gi;
	my $tGs += $seq =~ s/G/G/gi;
	my $tCs += $seq =~ s/C/C/gi;
	$Ns += (length $seq) - $tAs - $tTs - $tGs - $tCs;
	$As += $tAs;
	$Ts += $tTs;
	$Gs += $tGs;
	$Cs += $tCs;
}

sub Usage {
	print "\n Usage: perl $0 <options>\n\n";
	print "### Input reads/contigs (FASTA) (Required)\n";
	print "  -i <Read/Sequence file>\n";
	print "    Read/Sequence in fasta format\n";
	print "  -o | -outputFile <Output file name>\n";
	print "    default: By default, N50 statistics file will be stored where the input file is\n";
	print "  -h | -help\n";
	print "    Prints this help\n";
	print "\n";
}

sub Error {
	my $msg = $_[0];
	printf STDERR "|%-70s|\n", "  Error!!";
	printf STDERR "|%-70s|\n", "  $msg";
	
	Usage();
	exit;
}

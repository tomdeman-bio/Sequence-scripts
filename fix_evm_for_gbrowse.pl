#!/usr/bin/perl

#Written by Tom de Man

use strict;
my %count;

while(<>) {
    next if /^\s*$/;
    chomp;
    my @row = split(/\t/,$_);
    
    if($row[2] eq 'CDS') {
		my %grp = map { split(/=/,$_) } split(/;/,pop @row);
		$grp{ID} .= ".cds".++$count{$grp{ID}};
		push @row, join(";", map { sprintf("%s=%s",$_,$grp{$_})} qw(ID Parent));
    }
    print join("\t", @row), "\n";
}
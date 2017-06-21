#!/usr/bin/perl
use strict;
use warnings;
use FileHandle;

my $path = "U:\/Polyspace_ex\\subfolder";

open(FILE, '<',"U:/Polyspace_ex/options_command.txt") || die "File not found";
my @lines = <FILE>;
close(FILE);
my @newlines;

foreach(@lines){
	if ($_ !~ /"I- ".$path\s/) {
			push(@newlines, "$_");
	}
}

foreach (@newlines) {
	print "$_";
}
#!/usr/bin/perl
use strict;
use warnings;
use FileHandle;

my @lines;
my $start_check = 1;
my $last_check = 1;
my @new_lines;

open(FILE, '<', "U:/Summary_Source_DAudio_Micom.html");
@lines = <FILE>;
close(FILE);

foreach  (@lines) {
	if ("$_" =~ /(.*)AUTOGENBOOKMARK_2(.*)/) {
		$start_check = -1;
	}
	if ($start_check * $last_check == 1) {
		push(@new_lines, "$_");
	}
	if($start_check == -1 && "$_" =~ /(.*)<\/table>/) {;
		$last_check = -1;
	}

}

open(FILE, '>', "U:/Summary_Source_test_zz.html");
foreach  (@new_lines) {
	print FILE "$_";
}
close(FILE);
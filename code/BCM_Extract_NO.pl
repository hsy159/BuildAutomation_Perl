#!/usr/bin/perl
use strict;
use warnings;
use FileHandle;

my $var_path = "U:/BCM과제/Variant.c";
my @part_number;
my @static_line;
my $start_check = -1;
my @temp;
my $i;

open(FILE, '<',"$var_path") || die "File not found";
my @lines = <FILE>;
close(FILE);

foreach(@lines){
	if ("$_" =~ /static const _VARIANT/) {
		$start_check = 1;
	}
	if ($start_check == 1 && "$_" =~ /{(.*)}/) {
		push(@static_line, $_);
	}
	if("$_" eq "};\n"){
		$start_check = -1;
		last;
	}
}

foreach  (@static_line) {
	@temp = split(/"/,$_);
	if ($temp[1] =~ /^[1-9](.*)/) {
		push(@part_number, $temp[1]);
	}
}
for ($i = 0; $i < scalar(@part_number); $i++){
	open(FILE, '>', "U:/BCM과제/test_file"."$i"."\.c");
	foreach  (@lines) {
		if ($_ =~ /static const _VARIANT/) {
			$_ =~ tr{\n|\t}{ };
			print FILE "$_"."$part_number[$i]\n";
		}
		else{
			print FILE "$_";
		}
	}
	close(FILE);
}


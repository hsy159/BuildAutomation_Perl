#!/usr/bin/perl
use strict;
use warnings;

# Directory는 D:\DATA\workspace\$[/myjob/procedureName]\IBS331_HKMC_1.0\src\AS\PARAM

my $file ="U:/IBS_Parameter.c";

# $[4_IBS_PROJECT] 변수 사용할 것
my $IBS_PROJECT = "IK_G9000";
my $Pro_pattern = "(.*)IBS_PROJECT(.*)".$IBS_PROJECT."(.*)";
my $SW_pattern = "(.*)SW_Ver(.*)";

my $Pro_check = -1;
my $SW_check = 1;
my $SW_line;

open(my $fh, '<',$file)
	or die "Could not open file";

while(my $line = <$fh>){
	chomp $line;
	if ($Pro_check * $SW_check == 1) {
		$SW_line = $line;
	}
	if ($line =~ /$Pro_pattern/) {
		$Pro_check *= -1;
	}
	if ($line =~ /$SW_pattern/ && $Pro_check ==1) {
		$SW_check *= -1;
		last;
	}
}

my @fields = split /,/, $SW_line;
$fields[0] =~ s/\D//g;
$fields[1] =~ s/\D//g;
$fields[2] =~ s/\D//g;

if (length($fields[2])==1) {
	$fields[2] = '0'.$fields[2];
}

my $SW_Ver = $fields[0].$fields[1].$fields[2];
print "SW_Ver: ".$SW_Ver."\n";

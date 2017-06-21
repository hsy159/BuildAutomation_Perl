#!/usr/bin/perl
use strict;
use warnings;	
use ElectricCommander;

my $file = "D:\\DATA\\workspace\\$[/myJob/procedureName]\\IBS331_HKMC_1.0\\src\\ASW\\PARAM\\IBS_Parameter.c";
my $IBS_PROJECT = "$[/myJob/4_IBS_PROJECT]";
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
	if ($line =~ /$SW_pattern/ && $Pro_check == 1) {
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

my $ec = new ElectricCommander();
$ec->setProperty("/myJob/SW_Ver","$SW_Ver");

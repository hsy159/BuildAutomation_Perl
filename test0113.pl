#!/usr/bin/perl
use strict;
use warnings;
use ElectricCommander;

my $ec = new ElectricCommander();

$ec->setProperty("/myJob/0_UPDATE_VERSION","PD.KOR.0000.V071.160225");
my $ver = ($ec -> getProperty("/myJob/0_UPDATE_VERSION"))->findvalue('//value')->string_value;

my @fields = split /\./,$ver;

if($1){
	$ver = $1;
}else{
	$ver = "X";
}

`ectool setProperty "/myJob/Integration_Version" $fields[3]`;
`ectool setProperty "/myJob/Integration_Date" $fields[4]`;




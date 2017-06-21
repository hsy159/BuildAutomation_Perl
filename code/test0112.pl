#!/usr/bin/perl
use strict;
use warnings;

#my $ec = new ElectricCommander();

#my $ver = ($ec->getProperty("/myJob/0_UPDATE_VERSION"))->findvalue('//value')->string_value;
my $ver = "PD.KOR.0000.V071.160225";

$ver =~ m/(V\d+)/g;

my @fields = split /\./ , $ver;
print "$fields[4]";

if($1){
  $ver = $1;
}else{
  $ver = "X";
}

#`ectool setProperty "/myProcedure/Integration_Version" $ver`;

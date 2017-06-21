#!/usr/bin/perl
use strict;
use warnings;
use FileHandle;

my $var_path = "D:\\data\\Workspace\\BCM_CF_PE_Integrity_Build_test\\Sources\\Variant.c";
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
	open(FILE, '>', "D:\\data\\Workspace\\BCM_CF_PE_Integrity_Build_test\\Sources\\Variant"."$i"."\.c");
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
#################################################################



#################################################################
}



#!/usr/bin/perl
use strict;
use warnings;
use FileHandle;

my $var_path = "D:\\data\\Workspace\\BCM_CF_PE_Integrity_Build_test\\Sources\\Variant.c";
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
	open(FILE, '>', "D:\\data\\Workspace\\BCM_CF_PE_Integrity_Build_test\\output\\bin\\Variant"."$i"."\.c");
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

	system("SET PATH=%PATH%;\"C:/Program Files (x86)/Freescale/CWS12v5.1/bin\"");
	system("echo e_cf_bcm_platform.mcp");
	system("D:");
	system("cd D:/data/Workspace/BCM_CF_PE_Integrity_Build_test");
	system("attrib -R /S *.*");
	system("echo \"clean.....\"");
	system("cmdide ./e_cf_bcm_platform.mcp /r /c /q /f n");
	#CO_Build
	system("echo \"build.....\"");
	system("D:/CodeWarriorScript/CodeWarrior_Build_v1.3.vbs \"D:/data/Workspace/BCM_CF_PE_Integrity_Build_test/e_cf_bcm_platform.mcp\"");
	system("taskkill /f /im IDE.exe");
	#create_zip
	system("D:");
	system("cd data/Workspace/BCM_CF_PE_Integrity_Build_test/output/bin");
	system("\"C:/Program Files/Bandizip/7z/7z.exe\" a BCM_CF_PE_Integrity_Build_test_$i.zip \"D:/data/Workspace/BCM_CF_PE_Integrity_Build_test/output/bin/*.*\"");
}
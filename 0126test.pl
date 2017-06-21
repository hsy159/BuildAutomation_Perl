#!/usr/bin/perl
use strict;
use warnings;
use FileHandle;

sub Include_folder{

	my $path = shift;
	my $options_command = "D:\\data\\Workspace\\MFC_PolySpace\\"."$[3.polyspace_project]"."\\"."options_command_test.txt";
	my @inc_fol;
	my @others;
    my @lines;
	my $options = "$[5.additional_options]";

	if (-e "$options_command") {
		open(FILE, '<',"$options_command") || die "File not found";
		@lines = <FILE>;
		close(FILE);

		foreach  (@lines) {
			if ($_ =~ /-I (.*)/ ) {
				push(@inc_fol, "$_");
			}
			else{
				push(@others, "$_");
			}
		}
	}

	my @temp = split(/_/,"$[3.polyspace_project]");
	@others = split(/\n/, $options);
	
	foreach  (@others) {
		$_ =~ s/\[project\]/$temp[2]/g;
		$_ =~ s/\[misra\]/$[4.misra]/g;
	}

	if ($path =~ /(.*) \/s/) {
		my @split_path = split(/ /,$path);
		my @file_subdir_list = check_All_SubDir("$split_path[0]","1");
		
		foreach  (@file_subdir_list) {
			push(@inc_fol, "-I "."$_\n");
		}
		foreach  (@others) {
			push(@inc_fol, "$_"."\n");
		}

		@inc_fol = uniq(@inc_fol);

		open(my $fh,'>',$options_command)
			or die "Could not open file";
		foreach(@inc_fol){
			print $fh "$_";
		}
		close($fh);

		foreach  (@inc_fol) {
			print "$_";
		}
	}

	else{
		push(@inc_fol, "-I "."$path\n");
		foreach  (@others) {
			push(@inc_fol, "$_"."\n");
		}
		@inc_fol = uniq(@inc_fol);
		
		open(my $fh,'>',$options_command)
			or die "Could not open file";
		foreach(@inc_fol){
			print $fh "$_";
		}
		close($fh);
		
		foreach  (@inc_fol) {
			print "$_";
		}
	}
}

sub Exclude_folder{
	my $path = shift;
	my $options_command = "D:\\data\\Workspace\\MFC_PolySpace\\"."$[3.polyspace_project]"."\\"."options_command_test.txt";
	my @newlines;

	open(FILE, '<',"$options_command") || die "File not found";
	my @lines = <FILE>;
	close(FILE);

    $path =~ s/([^\\])\\([^\\])/$1\\\\$2/g;

	if ($path =~ /(.*) \/s/) {
		my @split_path = split(/ /, $path);
		foreach  (@lines) {
			if ($_ !~ /$split_path[0]/) {
				push(@newlines, "$_");
			}
		}
		open(FILE, '>',$options_command) || die "not found";
		foreach(uniq(@newlines)){
			print FILE "$_";
		}
		close(FILE);
		foreach(uniq(@newlines)){
			print "$_";
		}
	}

	else{
		foreach  (@lines) {
			if ("$_" !~ "$path\n") {
				push(@newlines, "$_");
			}
		}
		open(FILE, '>',$options_command) || die "not found";
		foreach(uniq(@newlines)){
			print FILE "$_";
		}
		close(FILE);
		foreach(uniq(@newlines)){
			print "$_";
		}
	}
}


sub check_All_SubDir{
    my $directory = shift;
    my $dir_condition = shift;
	
    opendir( DIR, $directory ); 
    my @contents = grep !/(^\.\.?$)/, readdir DIR;
    closedir( DIR );
    our @directories;
	our @not_directories_temp;
	my @not_directories;
	my $i;
	our $check = 0;
	if($check == 0){
		push(@directories, $directory);
		$check++;
	} 

	foreach( @contents )
    {
		if( opendir( SubDir, $directory . '\\' . $_ ) ) #¿­¸®¸é directory
        {
			push( @directories, $directory . '\\' . $_ );
            closedir( SubDir );

            check_All_SubDir( $directory . '\\' . $_ ); 
        }
		else{
			push ( @not_directories_temp, $directory . '\\' . $_ );
		}
    }
	
	foreach (@not_directories_temp) {
		push ( @not_directories, $_);
	}


	if($dir_condition){
		return uniq(@directories);
	}
	else {return uniq(@not_directories);}
}

sub uniq {
    my %seen;
    grep !$seen{$_}++, @_;
}

my $include_path = "$[1.include_path]";
my $exclude_path = "$[2.exclude_path]";

my @include_path_list = split(/\n/, $include_path);
my @exclude_path_list = split(/\n/, $exclude_path);

foreach  (@include_path_list) {
	Include_folder("$_");
}

foreach  (@exclude_path_list) {
	Exclude_folder("$_");
}
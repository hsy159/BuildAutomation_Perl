#!/usr/bin/perl
use strict;
use warnings;
use FileHandle;

sub Include_file{
	
	my $source_path = shift; 
	my $include_folder = shift;
	my $pattern = shift;
	my $file_extend = shift;
	my $sub_folder = shift;

	my $source_command = "D:\\data\\Workspace\\MFC_PolySpace\\"."$[1. polyspace_project]"."\\"."$[2. source_command]";
	my @file_subdir_list = check_All_SubDir($source_path,"0"); 
	my @file_only_list = check_Only_Dir($source_path);
	my @dir_list_final;
	my @lines;

	if (-e "$source_command") {
		open(FILE, '<',"$source_command") || die "File not found";
		@lines = <FILE>;
		close(FILE);
	}


	if ($sub_folder == 1) { 	
		foreach (@file_subdir_list) {
			if($_ =~ /$include_folder(.*)$pattern(.*)\.$file_extend$/){
				push(@dir_list_final,"$_\n");
			}			
		}
		foreach(uniq(@dir_list_final)){
			print "$_";
		}
	}

	else {
		foreach (@file_only_list) {
			if($_ =~ /$include_folder(.*)$pattern(.*)\.$file_extend$/){
				push(@dir_list_final,"$source_path"."\\"."$_\n");
			}			
		}

		foreach(@dir_list_final){
			print "$_";
		}
	}
	
	push(@lines, @dir_list_final);

    open(my $fh,'>',$source_command)
		or die "Could note open file";
	
	foreach(uniq(@lines)){
		print $fh "$_";
	}
	
	close($fh);
}

sub Exclude_file{

	my $source_path = shift;
	my $delete_path = shift;
	my $pattern = shift;
	my $file_extend = shift;
	my $sub_folder = shift;
	my $source_command = "D:\\data\\Workspace\\MFC_PolySpace\\"."$[1. polyspace_project]"."\\"."$[2. source_command]";
	my @file_extend_list;
	my @newlines;
	
	open(FILE, '<',"$source_command") || die "File not found";
	my @lines = <FILE>;
	close(FILE);

	$source_path =~ s/([^\\])\\([^\\])/$1\\\\$2/g;
	$delete_path =~ s/([^\\])\\([^\\])/$1\\\\$2/g;

	if($sub_folder == 1){ 
		foreach(@lines) {
			if($_ !~ /$source_path\\$delete_path(.*)$pattern(.*)\.$file_extend/) {
                                print "$_";
				push(@newlines, "$_");
			}
		}
	}
	else{
		foreach(@lines) {
			if($_ !~ /$source_path\\$delete_path(.*)$pattern(.*)\.$file_extend/){ 
				push(@newlines, "$_");
			}
		}
		foreach(@lines) {
			if($_ =~ /$source_path\\$delete_path(.*)[^\.$file_extend]\\$pattern(.*)\.$file_extend/){
				push(@newlines, "$_");
			}
		}
	}
	
        open(FILE, '>',"$source_command") || die "not found";
	foreach(uniq(@newlines)){
		print FILE "$_";
	}
	close(FILE);
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
		if( opendir( SubDir, $directory . '\\' . $_ ) ) 
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


sub check_Only_Dir{

	my $dir = shift;
	my @list;

	opendir(DIR, $dir) or die $!;

	while (my $file = readdir(DIR)) {
		# Use a regular expression to ignore files beginning with a period
		next if ($file =~ m/^\./);
		push( @list, "$file" );
	}

	closedir(DIR);
	return @list;
}

sub uniq {
    my %seen;
    grep !$seen{$_}++, @_;
}


my $include_path = "$[1.include_path]";
my $exclude_path = "$[2.exclude_path]";

my @include_path_list = split(/\\n/,$[1.include_path]);
my @exclude_path_list = split(/\\n/, $[2.exclude_path]);

foreach  (@include_path_list) {
	$_ =~ s/([^\\])\\([^\\])/$1\\\\$2/g;
	Include_File("$_");
}

foreach  (@exclude_path_list) {
	$_ =~ s/([^\\])\\([^\\])/$1\\\\$2/g;
	EXclude_File("$_");
}


sub Include_File{
	my $path = shift;
	my $file_extend = shift;
	my @lines;
	my $source_command = "D:\\data\\Workspace\\MFC_PolySpace\\$[4.polyspace_project]\\source_command_test.txt";


	if (-e "$source_command") {
		open(FILE, '<',"$source_command") || die "File not found";
		@lines = <FILE>;
		close(FILE);
	}

	if ($path =~ /(.*)\.(.*)/) { #file
		push(@lines, "$path");
	}
	else {
		my @only_dir_list = check_Only_Dir("$path");
		foreach  (@only_dir_list) {
			if ($_ =~ /(.*)\.$file_extend/) {
				push(@lines, "$path");
			}
		}
	}

	open(FILE, '<',"$source_command") || die "File not found";
	foreach  (@lines) {
		print FILE "$_\n";
	}
	close(FILE);
}

sub Exclude_File{
	
}
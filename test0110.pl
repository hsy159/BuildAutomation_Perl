#!/usr/bin/perl
use strict;
use warnings;
use FileHandle;

sub Include_file{
	
	my $source_path = shift; 
	my $file_extend = shift;
	my $sub_folder = shift;
	my $source_command = "$[1. polyspace_project_dir]"."\\"."$[2. source_command]";
	my @file_subdir_list = check_All_SubDir($source_path,"0"); 
	my @file_only_list = check_Only_Dir($source_path);
	my @dir_list_final;
	

	if ($sub_folder == 1) { 	
		foreach (@file_subdir_list) {
			if($_ =~ /(.*)\.$file_extend$/){
				if($_ !~ /look2(.*)/){
					push(@dir_list_final,$_);
				}
			}			
		}
		foreach(uniq(@dir_list_final)){
			print "$_\n";
		}
	}

	else {
		foreach (@file_only_list) {
			if($_ =~ /(.*)\.$file_extend$/ && $_ !~ /look2(.*)/){
				push(@dir_list_final,"$source_path"."\\"."$_");
			}			
		}

		foreach(@dir_list_final){
			print "$_\n";
		}
	}

        print "$source_command\n";
	open(my $fh,'>>',$source_command)
		or die "Could note open file";
	
	foreach(uniq(@dir_list_final)){
		print $fh "$_\n";
	}
	
	close($fh);
}


sub Include_folder{

	my $source_path = shift;
	my $want_path = shift;
	my $sub_folder = shift;
	my @include_subdir_list = check_All_SubDir($source_path.$want_path,"1");
	my $options_command = "$[2. polyspace_project_dir]"."\\"."$[3. options_command]";

	if ($sub_folder == 1) {
		open(my $fh,'>>',$options_command)
			or die "Could note open file";
	
		foreach(@include_subdir_list){
			print $fh "-I "."$_\n";
		}
	
		close($fh);

		foreach(@include_subdir_list){
			print "$_\n";
		}
	}
	else {
		open(my $fh,'>>',$options_command)
			or die "Could note open file";
		print $fh "-I "."$source_path\n";
	
		close($fh);
		if($want_path eq ''){
			print $source_path.$want_path;
		}
		else{
			print $source_path.'\\'.$want_path;
		}
	}
}

sub Exclude_file{

	my $source_path = shift;
	my $delete_path = shift;
	my $file_extend = shift;
	my $sub_folder = shift;
	my $source_command = "$[2. polyspace_project_dir]"."\\"."$[3. source_command]";
	my @file_extend_list;
	my @newlines;
	
	open(FILE, '<',"$source_command") || die "File not found";
	my @lines = <FILE>;
        close(FILE);
        $source_path =~ s/([^\\])\\([^\\])/$1\\\\$2/g;
        $delete_path =~ s/([^\\])\\([^\\])/$1\\\\$2/g;

	if($sub_folder == 1){ 
		foreach(@lines) {
			if($_ !~ /$source_path\\$delete_path(.*)\.$file_extend/) {
                                print "$_";
				push(@newlines, "$_");
			}
		}
		foreach(@newlines) {
                        #print "$_";		
                }
	}
	else{
		foreach(@lines) {
			if($_ !~ /$source_path\\$delete_path(.*)\.$file_extend/){ 
				push(@newlines, "$_");
			}
		}
		foreach(@lines) {
			if($_ =~ /$source_path\\$delete_path(.*)[^\.$file_extend]\\(.*).$file_extend/){
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

sub Exclude_folder{
	my $source_path = shift;
	my $delete_path = shift;
	my $sub_folder = shift;
	my $options_command = "$[2. polyspace_project_dir]"."\\"."$[3. options_command]";
	my @newlines;

	open(FILE, '<',"$options_command") || die "File not found";
	my @lines = <FILE>;
	close(FILE);

        $source_path =~ s/([^\\])\\([^\\])/$1\\\\$2/g;
        $delete_path =~ s/([^\\])\\([^\\])/$1\\\\$2/g;
        	
        if ($delete_path eq '') {
		if($sub_folder == 1) {
			foreach(@lines){
				if ($_ !~ /-I $source_path\s/ && $_ !~ /-I $source_path\\(.*)/) {
					push(@newlines, "$_");
				}
			}
		}
		else {
			foreach(@lines){
				if ($_ !~ /-I $source_path\s/) {
					push(@newlines, "$_");
				}
			}
		}
	}	
	else{
		if($sub_folder == 1) {
			foreach(@lines){
				if ($_ !~ /-I $source_path\\$delete_path\s/ && $_ !~ /-I $source_path\\$delete_path\\(.*)/) {
					push(@newlines, "$_");
				}
			}
		}
		else {
			foreach(@lines){
				if ($_ !~ /-I $source_path\\$delete_path\s/) {
					push(@newlines, "$_");
				}
			}
		}
        }
	foreach(@newlines){
		print "$_";
	}

	open(FILE, '>',$options_command) || die "not found";
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

Include_file("$[0. include_path]","$[4. extend]","$[3. include_subdir]");
Include_folder("$[0. include_path]","$[1. include_folder]","$[4. include_subdir]");
Exclude_file("$[0. exclude_path]","$[1. exclude_folder]","$[5. extend]","$[4. include_subdir]");
Exclude_folder("$[0. include_path]","$[1. exclude_folder]","$[4. include_subdir]");

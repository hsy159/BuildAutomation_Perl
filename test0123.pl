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


sub Include_folder{

	my $source_path = shift;
	my $want_path = shift;
	my $sub_folder = shift;
    my @include_subdir_list='';
	my $options_command = "D:\\data\\Workspace\\MFC_PolySpace\\"."$[2. polyspace_project]"."\\"."$[3. options_command]";
	my $options = "D:\\data\\Workspace\\MFC_Polyspace\\Options\\options.txt";
	my @inc_fol;
	my @others;
    my @lines;

	if ("$want_path" eq '') {
		@include_subdir_list = check_All_SubDir($source_path,"1");
	}
	else{
		@include_subdir_list = check_All_SubDir($source_path."\\".$want_path,"1");
	}
	if (-e "$options_command") {
		open(FILE, '<',"$options_command") || die "File not found";
		@lines = <FILE>;
		close(FILE);

		foreach  (@lines) {
			print "$_";
		}
			
		foreach  (@lines) {
			if ($_ =~ /-I (.*)/ ) {
				push(@inc_fol, "$_");
			}
			else{
				push(@others, "$_");
			}
		}
	}
	my @temp = split(/_/,"$[2. polyspace_project]");
        
	open(FILE, '<',"$options") || die "File not found";
	@others = <FILE>;
	close(FILE);

	foreach  (@others) {
		$_ =~ s/\[project\]/$temp[2]/g;
		$_ =~ s/\[misra\]/$[5. misra]/g;
	}

	if ($sub_folder == 1) {
		foreach (@include_subdir_list){
			push(@inc_fol, "-I "."$_\n");
		}
		push(@inc_fol, @others);
		@inc_fol = uniq(@inc_fol);
		open(my $fh,'>',$options_command)
			or die "Could not open file";

		foreach(@inc_fol){
			print $fh "$_";
		}
		close($fh);
		foreach(@inc_fol){
			print "$_";
		}
	}
	else {
		push(@inc_fol, "-I "."$source_path\n");
		push(@inc_fol, @others);
		@inc_fol = uniq(@inc_fol);
		open(my $fh,'>',$options_command)
			or die "Could not open file";
		foreach(@inc_fol){
			$_ =~ s/1-I/-I/g;
			print $fh "$_";
		}
		close($fh);

		if($want_path eq ''){
			print $source_path.$want_path;
		}
		else{
			print $source_path.'\\'.$want_path;
		}
	}
}

sub Exclude_folder{
	my $source_path = shift;
	my $delete_path = shift;
	my $sub_folder = shift;
	my $options_command = "D:\\data\\Workspace\\MFC_PolySpace\\"."$[2. polyspace_project]"."\\"."$[3. options_command]";
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


if ("$[6. patterns]" eq '') {
	if("$[in_or_ex]"){
		Include_file("$[0. path]",'',"$[5. folder]","$[4. extend]","$[3. include_subdir]");
	}
	else{
		Exclude_file("$[0. path]",'',"$[5. folder]","$[4. extend]","$[3. include_subdir]");
	}
}

else {
	my @patterns = split /,/, "$[6. patterns]";

	if("$[in_or_ex]"){
		foreach  (@patterns) {
			Include_file("$[0. path]","$[5. folder]","$_","$[4. extend]","$[3. include_subdir]");
		}
	}
	else{
		foreach  (@patterns) {
			Exclude_file("$[0. path]","$[5. folder]","$_","$[4. extend]","$[3. include_subdir]");
		}
	}
}

if("$[1. folder]" eq ''){
	if("$[in_or_ex]"){
		Include_folder("$[0. path]","$[1. folder]","$[4. include_subdir]");
	}
	else{
		Exclude_folder("$[0. path]","$[1. folder]","$[4. include_subdir]");
	}
}

else{
	my $folder = "$[1. folder]";
	my @lists = split /,/, $folder;

	foreach  (@lists) {
		if("$[in_or_ex]"){
			Include_folder("$[0. path]","$_","$[4. include_subdir]");
		}
		else{
			Exclude_folder("$[0. path]","$_","$[4. include_subdir]");
		}
	}
}
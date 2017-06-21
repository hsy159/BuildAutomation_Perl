#!/usr/bin/perl
use strict;
use warnings;
use FileHandle;

sub Include_folder{

	my $source_path = shift;
	my $want_path = shift;
	my $sub_folder = shift;
	my @include_subdir_list = check_All_SubDir($source_path.$want_path,"1");
	my $options_command = "D:\\data\\Workspace\\MFC_PolySpace\\"."$[2. polyspace_project]"."\\"."$[3. options_command]";
	my @inc_fol;	
	my @others;
    my @lines;
	if (-f "test.txt") {
		open(FILE, '<',"$options_command") || die "File not found";
		@lines = <FILE>;
		close(FILE);

		foreach  (@lines) {
			if ($_ = /-I (.*)/ ) {
			push(@inc_fol, $_);
			}
			else{
				push(@others, $_);
			}
		}	
	}
	my @temp = split(/_/,"$[/myJob/WORKSPACE_NAME]");
	push(@others, "-misra2 D:\\data\\Workspace\\MFC_PolySpace\\Ruleset\\"."$[5. misra]\n");
	push(@others, "-prog "."$temp[2]"."_SCAM3_MFC_SBAS\n");

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
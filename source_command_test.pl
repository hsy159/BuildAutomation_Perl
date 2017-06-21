#!/usr/bin/perl
use strict;
use warnings;
use FileHandle;

sub Include_file{
	
	my $source_path = shift; 
	my $pattern = shift;
	my $file_extend = shift;
	my $sub_folder = shift;
	my $source_command = "$[1. polyspace_project_dir]"."\\"."$[2. source_command]";
	my @file_subdir_list = check_All_SubDir($source_path,"0"); 
	my @file_only_list = check_Only_Dir($source_path);
	my @dir_list_final;
	

	if ($sub_folder == 1) { 	
		foreach (@file_subdir_list) {
			if($_ =~ /(.*)$pattern(.*)\.$file_extend$/){
				push(@dir_list_final,$_);
			}			
		}
		foreach(uniq(@dir_list_final)){
			print "$_\n";
		}
	}

	else {
		foreach (@file_only_list) {
			if($_ =~ /(.*)$pattern(.*)\.$file_extend$/){
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

sub Exclude_file{

	my $source_path = shift;
	my $delete_path = shift;
	my $file_extend = shift;
	my $sub_folder = shift;
	my $source_command = "$[1. polyspace_project_dir]"."\\"."$[2. source_command]";
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
		Include_file("$[0. path]",'',"$[4. extend]","$[3. include_subdir]");
	}
	else{
		Exclude_file("$[0. path]",'',"$[5. exclude_folder]","$[4. extend]","$[3. include_subdir]");
	}
}

else {
	my @patterns = split /,/, "$[6. patterns]";

	if("$[in_or_ex]"){
		foreach  (@patterns) {
			Include_file("$[0. path]","$_","$[4. extend]","$[3. include_subdir]");
		}
	}
	else{
		foreach  (@patterns) {
			Exclude_file("$[0. path]","$[5. exclude_folder]","$_","$[4. extend]","$[3. include_subdir]");
		}
	}
}
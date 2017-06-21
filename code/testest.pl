#!/usr/bin/perl
use strict;
use warnings;
use FileHandle;

sub Include_File{
    my $path = shift;
    my $file_extend = shift;
    my @lines;
    my $source_command = "D:\\data\\Workspace\\MFC_PolySpace\\$[4.WORKSPACE]\\source_command_test.txt";

	if (-e "$source_command") {
		open(FILE, '<',"$source_command") || die "File not found";
		@lines = <FILE>;
		close(FILE);
	}


    if ($path =~ /(.*)\.(.*)/) { #file
		push(@lines, "$path\n");
	}
    else {
		if ($path =~ /(.*) \/s/) {
			my @split_path = split(/ /,$path);
			my @file_subdir_list = check_All_SubDir("$split_path[0]","0");
			foreach  (@file_subdir_list) {
				if ($_ =~ /(.*)\.$file_extend/) {
					push(@lines, "$_\n");
				}
			}
		}
		else{
			my @only_dir_list = check_Only_Dir("$path");
			foreach (@only_dir_list) {
				if ($_ =~ /(.*)\.$file_extend/) {
					push(@lines, "$path"."\\"."$_\n");
				}
			}
		}
    }

    open(FILE, '>',"$source_command") || die "File not found";
    foreach (uniq(@lines)) {
        print FILE "$_";
    }
    close(FILE);
    foreach (uniq(@lines)) {
        print "$_";
    }
}

sub Exclude_File{
    my $path = shift;
    my $file_extend = shift;
    my @lines;
    my @new_lines;
    my $source_command = "D:\\data\\Workspace\\MFC_PolySpace\\$[4.WORKSPACE]\\source_command_test.txt";

    open(FILE, '<',"$source_command") || die "File not found";
    @lines = <FILE>;
    close(FILE);

    if ($path =~ /(.*)\.(.*)/) { #file
        foreach (@lines) {
            if ("$_" ne "$path\n") {
                push(@new_lines, "$_");
            }
        }
    }
    else {
		if ($path =~ /(.*) \/s/) {
			my @split_path = split(/ /,$path);
			$split_path[0] =~ s/([^\\])\\([^\\])/$1\\\\$2/g;

			foreach  (@lines) {
				if("$_" !~ /$split_path[0]\\(.*)\.$file_extend/) {
					push(@new_lines, "$_");
				}
			}
		}
		else {
			$path =~ s/([^\\])\\([^\\])/$1\\\\$2/g;
			foreach (@lines) {
				if ("$_" !~ /$path\\(.*)\.$file_extend/) {
					push(@new_lines, "$_");
				}
				if ("$_" =~ /$path\\(.*)\\(.*)\.$file_extend/) {
					push(@new_lines, "$_");
				}
			}
		}
    }

    open(FILE, '>',"$source_command") || die "File not found";
    foreach (uniq(@new_lines)) {
        print FILE "$_";
    }
    close(FILE);
    foreach (uniq(@new_lines)) {
        print "$_";
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

my $include_path = "$[1.INCLUDE_PATH]";
my $exclude_path = "$[2.EXCLUDE_PATH]";

my @include_path_list = split(/\n/, $include_path);
my @exclude_path_list = split(/\n/, $exclude_path);

foreach (@include_path_list) {
    Include_File("$_","$[3.EXTEND]");
}

foreach (@exclude_path_list) {
    Exclude_File("$_","$[3.EXTEND]");
}
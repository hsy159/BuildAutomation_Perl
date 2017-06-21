#!/usr/bin/perl
use strict;
use warnings;
use FileHandle;

sub check_All_SubDir{
    my $directory = shift;
	my @all_file;
	
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
	
	push(@directories, @not_directories);
	return uniq(@directories);
}

sub uniq {
    my %seen;
    grep !$seen{$_}++, @_;
}

my @list = check_All_SubDir("D:\\data\\test\\IBS331_HKMC_1.0\\src");
foreach(@list){
	print "$_\n";
}
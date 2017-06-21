#!/usr/bin/perl
use strict;
use warnings;
use autodie;

sub Include_file{
	
	my $source_path = shift; 
	my $file_extend = shift;
	my $sub_folder = shift;
	my $i;
	my @dir_list = Directory_file_list($source_path);
	my @dir_list_final;
	
	if ($sub_folder == 1) { #���� ���� ����	
		for ($i=0; $i < scalar(@dir_list) ; $i++) { #folder �����̰ų� .c ���ϸ� ����
			if($dir_list[$i] =~ /(.*)\.$file_extend/ || $dir_list[$i] !~ /(.*)\.(.*)/){
				if($dir_list[$i] !~ /look2(.*)/){
					push(@dir_list_final,$dir_list[$i]);
				}
			}			
		}

		for($i=0; $i < scalar(@dir_list_final);$i++){
			print "$source_path"."/"."$dir_list_final[$i]\n";
		}
	}

	else { #���� ���� ������	
		for ($i = 0; $i < scalar(@dir_list) ; $i++) {
			if($dir_list[$i] =~ /(.*)\.$file_extend/ && $dir_list[$i] !~ /look2(.*)/){
				push(@dir_list_final,$dir_list[$i]);
			}			
		}

		for($i=0; $i < scalar(@dir_list_final);$i++){
			print "$source_path"."/"."$dir_list_final[$i]\n";
		}
	}

	my $source_command = "$source_path"."/source_command.txt";
	open(my $fh,'>>',$source_command)
		or die "Could note open file";
	
	foreach(@dir_list_final){
		print $fh "$source_path"."/"."$_\n";
	}
	
	close($fh);

}

sub Exclude_file{
	
	my $source_path = shift; 
	my $file_extend = shift;
	my $sub_folder = shift;
	my $i;
	my @dir_list = Directory_file_list($source_path);
	my @dir_list_final;
	
	if ($sub_folder == 1) { #���� ���� ����
		for ($i=0; $i < scalar(@dir_list) ; $i++) {
			if($dir_list[$i] !~ /(.*)\.$file_extend/ && $dir_list[$i] !~ /look2(.*)/){
				push(@dir_list_final,$dir_list[$i]);
			}
		}
		for($i=0; $i < scalar(@dir_list_final);$i++){
			print "$source_path"."/"."$dir_list_final[$i]\n";
		}
		
	}

	else { #���� ���� ������
		for ($i=0; $i < scalar(@dir_list) ; $i++) {
			if($dir_list[$i] !~ /(.*)\.$file_extend/ && $dir_list[$i] =~ /(.*)\.(.*)/ && $dir_list[$i] !~ /look2(.*)/){
				push(@dir_list_final,$dir_list[$i]);
			}
		}
		for($i=0; $i < scalar(@dir_list_final);$i++){
			print "$source_path"."/"."$dir_list_final[$i]\n";
		}
	}
	
	my $source_command = "$source_path"."/source_command.txt";
	open(my $fh,'>>',$source_command)
		or die "Could note open file";
	
	foreach(@dir_list_final){
		print $fh "$source_path"."/"."$_\n";
	}
	
	close($fh);
}

sub Directory_file_list{

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





Include_file("U:/Polyspace_ex","c","0");
print "\n\n";
Include_file("U:/Polyspace_ex","h","1");
print "\n\n";
Exclude_file("U:/Polyspace_ex","c","0");
print "\n\n";
Exclude_file("U:/Polyspace_ex","h","1");
print "\n\n";
#!/usr/bin/perl
#
# mkprotos.pl
#
# generate aprotos.h from all .c files given
#

my $top = <<TOP;
/* automatically generated by make config in $0 %s */
#ifndef APROTOS_H
#define APROTOS_H
#define PROTO
TOP

my $bot = <<BOT;
#endif
BOT

sub getprotos 
{
	my ($file) = shift;

	open(F,$file) || die "$file: $!\n";
	while(<F>)
	{
		chop;
		if ( m/^PROTO/ ) 
		{
			s/^PROTO\s+//g;
			s/\s+\{$//g;
			s/\s+$//g;
			print "$_;\n";
		}
	}

	close F;
}

sub do_dir 
{
	my ($dir) = @_;

	opendir(DIR,$dir) || return;

	for( readdir(DIR) ) 
	{
		next if ! m/\.c$/;
		getprotos("$dir/$_");
	}

	closedir(DIR);
}


printf($top, scalar localtime(time) );
do_dir(".");
do_dir("auth");
printf $bot;


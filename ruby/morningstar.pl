use strict;
use warnings;
use DBI;



my $dbh = DBI->connect('DBI:mysql:world', 'root', 'comp0707'
	           ) || die "Could not connect to database: $DBI::errstr";
# (insert query examples here...)
$dbh->disconnect();
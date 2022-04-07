#! perl

use v5.30;

use strict;
use warnings;

use Data::Dumper qw( Dumper );

use Inventory::Client;

my $client = Inventory::Client->new();

my $user = $client->login->get_authenticated_user();

print "User : " . Dumper($user);
#! perl

use v5.30;

use strict;
use warnings;

use Data::Dumper qw( Dumper );

use Inventory::Utils::Client;

my $client = Inventory::Utils::Client::get_authenticated_client();

print "User : " . Dumper($client->authenticated_user());

print "Countries: " . Dumper($client->country->get_countries());
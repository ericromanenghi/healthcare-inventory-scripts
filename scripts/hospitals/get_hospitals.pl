#! perl

use v5.30;

use strict;
use warnings;

use Data::Dumper qw( Dumper );

use Inventory::Utils::Client;

my $client = Inventory::Utils::Client::get_authenticated_client();

my $hospitals = $client->hospital->get_all({
    "pagination[pageSize]" => 10
});

print Dumper($hospitals);
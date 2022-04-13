#! perl

use v5.30;

use strict;
use warnings;

use Data::Dumper qw( Dumper );

use Inventory::Utils::Client;

my $client = Inventory::Utils::Client::get_authenticated_client();

my $countries = $client->country->get_all({
    "pagination[page]"     => 1,
    "pagination[pageSize]" => 10
});

print Dumper($countries);
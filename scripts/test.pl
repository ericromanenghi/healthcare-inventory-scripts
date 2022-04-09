#! perl

use v5.30;

use strict;
use warnings;

use Data::Dumper qw( Dumper );

use Inventory::Utils::Client;

my $client = Inventory::Utils::Client::get_authenticated_client();

# print "Countries: " . Dumper($client->country->get_countries());

my $hospital_dto = Inventory::DTO::Hospital->new({
    name => "Hospital one",
    address => "Avenida siempre viva"
});

my $created_hospital = $client->hospital->create_hospital($hospital_dto);

print Dumper($created_hospital);
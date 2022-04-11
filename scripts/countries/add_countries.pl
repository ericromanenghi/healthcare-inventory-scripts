#! perl

use v5.30;

use strict;
use warnings;

use JSON;

use Data::Dumper qw( Dumper );
use File::Slurp;

use Inventory::Utils::Client;

my $countries_json = read_file('datasets/countries.json');
my $countries_raw = decode_json($countries_json);

my @country_dtos = map {
    Inventory::DTO::Country->new(
        country_code => lc($_->{'alpha-2'}),
        name_en      => $_->{name}
    )
} @$countries_raw;

my $client = Inventory::Utils::Client::get_authenticated_client();

for my $country_dto (@country_dtos) {
    my $response = $client->country->create_country($country_dto);
    if ($response) {
        print $response->name_en . " inserted successfuly \n";
    }
}

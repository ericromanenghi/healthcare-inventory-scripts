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

my %stored_countries = map {
    $_->{country_code} => 1
} @{$client->country->get_all_forced()};

for my $country_dto (@country_dtos) {
    if ($stored_countries{$country_dto->country_code}) {
        print $country_dto->country_code . " already stored\n";
        next;
    }

    my $response = $client->country->create($country_dto);

    if ($response) {
        print $response->country_code . " inserted successfuly\n";
    }
}

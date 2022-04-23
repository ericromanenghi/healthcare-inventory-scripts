#! perl

use v5.30;

use strict;
use warnings;

use JSON;

use Data::Dumper qw( Dumper );
use File::Slurp;
use Getopt::Long;

use Inventory::Utils::Client;

my $config_file = '.env.dev';
GetOptions('config=s' => \$config_file);

my $countries_json = read_file('datasets/countries.json');
my $countries_raw = decode_json($countries_json);

my @country_dtos = map {
    Inventory::DTO::Country->new(
        country_code => lc($_->{'alpha-2'}),
        name_en      => $_->{name}
    )
} @$countries_raw;

my $client = Inventory::Utils::Client::get_authenticated_client($config_file);

my $stored_countries = $client->country->get_map_by_field('country_code');

for my $country_dto (@country_dtos) {
    if ($stored_countries->{$country_dto->country_code}) {
        print $country_dto->country_code . " already stored\n";
        next;
    }

    my $response = $client->country->create($country_dto);

    if ($response) {
        print $response->country_code . " inserted successfuly\n";
    }
}

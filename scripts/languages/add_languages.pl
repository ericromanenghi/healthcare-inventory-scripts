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

my $languages_json = read_file('datasets/languages.json');
my $languages_raw = decode_json($languages_json);

my @language_dtos = map {
    Inventory::DTO::Language->new(
        code    => lc($_->{'alpha2'}),
        name_en => $_->{'English'}
    )
} @$languages_raw;

my $client = Inventory::Utils::Client::get_authenticated_client($config_file);

my $stored_languages = $client->language->get_map_by_field('code');

for my $language_dto (@language_dtos) {
    if ($stored_languages->{$language_dto->code}) {
        print $language_dto->code . " already stored\n";
        next;
    }

    my $response = $client->language->create($language_dto);

    if ($response) {
        print $response->code . " inserted successfuly\n";
    }
}

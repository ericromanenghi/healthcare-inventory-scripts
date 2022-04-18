#! perl

use v5.30;

use strict;
use warnings;

use JSON;

use Data::Dumper qw( Dumper );

use Inventory::Utils::Client;

main();
exit;

sub main {
    my $client = Inventory::Utils::Client::get_authenticated_client();

    my $country_by_country_code = $client->country->get_map_by_field('country_code');
    my $language_by_code = $client->language->get_map_by_field('code');

    my @hospitals_to_insert = get_hospitals_to_insert(
        $country_by_country_code,
        $language_by_code
    );

    for my $hospital (@hospitals_to_insert) {
        my $response = $client->hospital->create($hospital);

        if ($response) {
            print $response->name . " inserted successfuly\n";
        } else {
            print $response->name . " insertion failed\n";
        }
    }
}

sub get_hospitals_to_insert {
    my ($country_by_country_code, $language_by_code) = @_;

    return (
        Inventory::DTO::Hospital->new(
            name                   => 'Hospital from script',
            country                => $country_by_country_code->{ar}, # Argentina
            address                => 'Address from script',
            google_maps_link       => 'Some link',
            phone                  => '0303456',
            admition_protocol      => 'Some admition protocol',
            can_accommodate_family => 'maybe',
            comments               => 'Some comments',
            spoken_languages       => [$language_by_code->{en}, $language_by_code->{es}], # English, Spanish
            translated_languages   => [$language_by_code->{ru}], # Russian
            website                => 'www.example.com',
            localization           => 'North Spain',
        )
    );
}
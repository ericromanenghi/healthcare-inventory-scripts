#! perl

use v5.30;

use strict;
use warnings;

use Data::Dumper qw( Dumper );

use Inventory::Utils::Client;

my $client = Inventory::Utils::Client::get_authenticated_client();

my $countries = $client->country->get_all({
    "pagination[pageSize]" => 300
});

for my $country (@$countries) {
    print "Deleting country " . $country->{id} . "\n";
    my $response = $client->country->delete($country->{id});
    if ($response) {
        print $country->{name_en} . " successfuly deleted \n";
    } else {
            print "Could not delete " . $country->{name_en} . "\n";
    }
}
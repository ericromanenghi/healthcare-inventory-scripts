#! perl

use v5.30;

use strict;
use warnings;

use Data::Dumper qw( Dumper );

use Inventory::Utils::Client;

my $client = Inventory::Utils::Client::get_authenticated_client();

my $languages = $client->language->get_all_forced();

for my $language (@$languages) {
    print "Deleting language " . $language->{id} . "\n";
    my $response = $client->language->delete($language->{id});
    if ($response) {
        print $language->{code} . " successfuly deleted \n";
    } else {
            print "Could not delete " . $language->{code} . "\n";
    }
}
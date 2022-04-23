#! perl

use v5.30;

use strict;
use warnings;

use Data::Dumper qw( Dumper );
use Getopt::Long;

use Inventory::Utils::Client;

my $config_file = '.env.dev';
GetOptions('config=s' => \$config_file);

my $client = Inventory::Utils::Client::get_authenticated_client($config_file);

my $languages = $client->language->get_all({
    "pagination[page]"     => 1,
    "pagination[pageSize]" => 10
});

print Dumper($languages);
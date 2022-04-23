package Inventory::Utils::Client;

use strict;
use warnings;

use Inventory::Environment;
use Inventory::Client;

sub get_authenticated_client {
    my ($config_file) = @_;

    my $environment = Inventory::Environment->new(
        $config_file ? (config_file => $config_file) : ()
    );

    return Inventory::Client->new(
        environment => $environment
    );
}

1;
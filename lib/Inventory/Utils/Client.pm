package Inventory::Utils::Client;

use strict;
use warnings;

use Inventory::Environment;
use Inventory::Client;

sub get_authenticated_client {
    my ($username, $password) = @_;

    my $environment = Inventory::Environment->new();
    
    return Inventory::Client->new(
        username => $username // $environment->api_username,
        password => $password // $environment->api_password,
    );
}

1;
package Inventory::Client::Country;

use Moose;

with 'Inventory::Role::Endpoint';

use Inventory::DTO::Country;

sub get_countries {
    my ($self) = @_;

    my $countries_data = $self->get();

    return unless $countries_data;

    return [
        map { 
            _render_country_data($_)
        } @{ $countries_data->{data} }
    ];
}

sub _render_country_data {
    my ($country_data) = @_;
    
    my $attributes = $country_data->{attributes};
    
    return Inventory::DTO::Country->new(
        id => $country_data->{id},
        %{$attributes}
    );
}

no Moose;
__PACKAGE__->meta->make_immutable;
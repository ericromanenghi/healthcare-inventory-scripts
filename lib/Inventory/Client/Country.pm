package Inventory::Client::Country;

use Moose;

with 'Inventory::Role::Endpoint';

use Inventory::DTO::Country;

sub get_countries {
    my ($self, $args) = @_;

    my $countries_data = $self->get($args);

    return unless $countries_data;

    return [
        map { 
            _render_country_data($_)
        } @{ $countries_data->{data} }
    ];
}

sub create_country {
    my ($self, $country_dto) = @_;

    my $country_data = {
        data => +{ %{$country_dto} }
    };

    my $response = $self->post($country_data);

    return unless $response;

    return _render_country_data($response->{data});
}

sub delete_country {
    my ($self, $id) = @_;

    my $response = $self->delete({
        id => $id
    });

    return $response;
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
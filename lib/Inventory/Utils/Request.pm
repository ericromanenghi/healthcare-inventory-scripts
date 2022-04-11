package Inventory::Utils::Request;

use strict;
use warnings;

use JSON;
use HTTP::Request;
use LWP::UserAgent;

sub get {
    my ($host, $uri, $params, $jwt) = @_;

    my $request = _make_get_request($host, $uri, $params);

    if ($jwt) {
        $request->header('Authorization' => "Bearer $jwt");
    }

    my $response = _call($request);

    return $response;
}

sub post {
    my ($host, $uri, $params, $jwt) = @_;

    my $request = _make_post_request($host, $uri, $params);

    if ($jwt) {
        $request->header('Authorization' => "Bearer $jwt");
    }

    my $response = _call($request);

    return $response;
}

sub delete {
    my ($host, $uri, $params, $jwt) = @_;

    my $request = _make_delete_request($host, $uri, $params);

    if ($jwt) {
        $request->header('Authorization' => "Bearer $jwt");
    }

    my $response = _call($request);

    return $response;
}

sub _call {
    my ($request) = @_;

    my $ua = LWP::UserAgent->new();
    my $response = $ua->request($request);

    return $response;
}

sub _make_post_request {
    my ($host, $uri, $params) = @_;

    my $url = sprintf(
        "%s%s",
        $host,
        $uri,
    );

    $params = defined $params ? $params : {};

    my $request = HTTP::Request->new('POST', $url);
    $request->header('Content-Type' => 'application/json');
    $request->content(encode_json($params));

    return $request;
}

sub _make_delete_request {
    my ($host, $uri, $params) = @_;

    die "Id parameter is required for delete operations" unless defined $params->{id};

    my $url = sprintf(
        "%s%s/%s",
        $host,
        $uri,
        $params->{id}
    );

    my $request = HTTP::Request->new('DELETE', $url);
    $request->header('Content-Type' => 'application/json');

    return $request;
}

sub _make_get_request {
    my ($host, $uri, $params) = @_;

    my $encoded_params = $params ?
        join('&', map { _make_get_param($_, $params->{$_}) } keys %$params ) :
        '';

    my $url = sprintf(
        "%s%s?%s",
        $host,
        $uri,
        $encoded_params
    );

    return HTTP::Request->new('GET', $url);
}

sub _make_get_param {
    my ($name, $value) = @_;

    if (ref $value eq 'ARRAY') {
        return join('&', map {sprintf("%s=%s", $name, $_)} @$value)
    }

    return sprintf("%s=%s", $name, $value);
}

1;
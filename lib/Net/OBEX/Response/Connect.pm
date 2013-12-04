package Net::OBEX::Response::Connect;

use strict;
use warnings;

our $VERSION = '0.004';

use Carp;
use base 'Net::OBEX::Response::Generic';

sub parse_info {
    my ( $self, $packet ) = @_;
    $packet = $self->packet
        unless defined $packet;

    my %info;
    @info{ qw(
            response_code  packet_length  obex_version  flags  mtu
        )
    } = unpack 'a n B8 B8 n', $packet;

    @info{qw( response_code response_code_meaning ) } =
    $self->code_meaning( $info{response_code} );
    
    $info{headers_length} = $info{packet_length} - 7;
    $self->headers_length( $info{headers_length} );

    return $self->info( \%info );
}

1;

__END__

=encoding utf8

=head1 NAME

Net::OBEX::Response::Connect - interpret OBEX protocol Connect response packets

=head1 SYNOPSIS

    use strict;
    use warnings;
    use Net::OBEX::Response;

    my $res = Net::OBEX::Response->new;

    # read 7 bytes of the Connect packet from the socket there somewhere
    # now parse it:
    my $response_ref = $res->parse( $data_from_the_socket, 1 );

    if ( $response_ref->{headers_length} ) {
        # ok, looks like we got some headers in this packet
        # read $response_ref->{headers_length} bytes from the socket
        # here and parse the headers.
    }

    # OMG SO COMPLICATED!!
    # Why not use Net::OBEX::Response parse_sock() method instead?!

=head1 DESCRIPTION

B<WARNING!!! this module is still in early alpha stage. It is recommended
that you use it only for testing.>

This module is used internally by L<Net::OBEX::Response> and that's what
you probably should be using.
This module provides means to interpret raw OBEX protocol Connect responses.
For other responses see L<Net::OBEX::Response::Generic>

=head1 CONSTRUCTOR

=head2 new

    my $res = Net::OBEX::Response::Connect->new;

Takes no arguments, returns a freshly baked, Net::OBEX::Response::Connect
object ready to be used and abused.

=head1 METHODS

=head2 parse_info

    $res->packet( $data_from_wire );
    my $connect_response = $res->parse_info;

    # or

    my $connect_response = $res->parse_info( $data_from_wire );

Takes one optional argument which is the raw data from the wire
representing the Connect response packet. If called without
arguments will use the data which you set via C<packet()> method
(see documentation for L<Net::OBEX::Response::Generic>)
Returns a hashref with the following keys/values:

Sample returns (descriptions are below):

    $VAR1 = {
        'mtu' => 5126,
        'flags' => '00000000',
        'packet_length' => 31,
        'obex_version' => '00010000',
        'response_code' => 200,
        'headers_length' => 24,
        'response_code_meaning' => 'OK, Success'
    };

=head3 packet_length

    { 'packet_length' => 3 }

The C<packet_length> key will contain the length of the packet in bytes.

=head3 headers_length

    { 'headers_length' => 24 }

The C<headers_length> key will contain the length of packet's headers in
bytes. You would use this value to finish reading the entire packet from
the socket, however, see the C<parse_sock()> method described below.

=head3 response_code

    { 'response_code' => 200 }

The C<response_code> key will contain a response code, this will pretty
much be HTTP response codes since that what OBEX prefers to use.

=head3 response_code_meaning

    { 'response_code_meaning' => 'OK, Success' }

The C<response_code_meaning> key will contain a human parseable explanation
of C<response_code>.

=head3 mtu

    { 'mtu' => 5126 }

The C<mtu> key will contain the MTU of the responding device, i.e. the
maximum length of a packet (in bytes) the device can accept.

=head3 flags

    { 'flags' => '00000000' }

The C<flags> key will contain an unpacked "flags" byte, all but the first
of those 8 bits are reserved. If the first bit is set it
I<indicates support for multiple IrLMP connections to the same LSAP-SEL>

=head3 obex_version

    { 'obex_version' => '00010000' }

The C<obex_version> key will contain an unpacked "version" byte.
Which is the version of the OBEX protocol encoded with the major number
in the high order 4 bits, and the minor version in the low order 4 bits.

=head2 other methods

The module also provides C<code_meaning()>, C<headers_length()>,
C<packet> and
C<info()> methods which are described in documentation for
L<Net::OBEX::Response::Generic>.

=head1 SEE ALSO

L<Net::OBEX::Packet::Headers>, L<Net::OBEX::Response>,
L<Net::OBEX::Response::Generic>

=head1 AUTHOR

Zoffix Znet, C<< <zoffix at cpan.org> >>
(L<http://zoffix.com>, L<http://haslayout.net>)

=head1 BUGS

Please report any bugs or feature requests to C<bug-net-obex-response at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Net-OBEX-Response>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Net::OBEX::Response

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Net-OBEX-Response>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Net-OBEX-Response>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Net-OBEX-Response>

=item * Search CPAN

L<http://search.cpan.org/dist/Net-OBEX-Response>

=back

=head1 COPYRIGHT & LICENSE

Copyright 2008 Zoffix Znet, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

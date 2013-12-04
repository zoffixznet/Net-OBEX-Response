use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Net::OBEX::Response',
    license             => 'perl',
    dist_author         => 'Zoffix Znet <zoffix@cpan.org>',
    dist_version_from   => 'lib/Net/OBEX/Response.pm',
    build_requires => {
        'Test::More' => 0,
    },
    configure_requires => { 'Module::Build' => 0.40 },
    requires => {
        'Carp'                       => '1.04',
        'Net::OBEX::Packet::Headers' => '0.002',
        'Class::Data::Accessor' => '0.04001',
        perl                    => '5.006',
    },
    add_to_cleanup      => [ 'Net-OBEX-Response-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();

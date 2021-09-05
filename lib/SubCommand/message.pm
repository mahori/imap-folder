package SubCommand::message;

use strict;
use warnings;
use feature qw( say );
use Encode qw( from_to );
use Encode::IMAPUTF7;

use FindBin qw( $RealBin );
use lib "$RealBin/lib";
use base qw( SubCommand::Base );

sub execute {
  my ( $self, $folder, $uid ) = @_;

  unless ( defined $folder && defined $uid ) {
    return;
  }

  my $client = $self->{client};

  from_to( $folder, 'UTF-8', 'IMAP-UTF-7' );
  $client->select( $folder ) or die $!;

  my $message = $client->message_string( $uid ) or die $!;
  unless ( $message ) {
    return;
  }

  say $message;
}

1;

package messages;

use strict;
use warnings;
use feature qw( say );
use Encode qw( from_to );
use Encode::IMAPUTF7;

use FindBin qw( $RealBin );
use lib "$RealBin/lib";
use base qw( Command );

sub execute {
  my ( $self, $folder ) = @_;

  unless ( defined $folder ) {
    return;
  }

  my $client = $self->{client};

  from_to( $folder, 'UTF-8', 'IMAP-UTF-7' );
  $client->select( $folder ) or die $!;

  my @messages = $client->messages or die $!;
  unless ( @messages ) {
    return;
  }

  foreach my $message ( sort { $a <=> $b } @messages ) {
    say $message;
  }
}

1;

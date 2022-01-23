package export;

use strict;
use warnings;
use feature qw( say );
use Encode qw( from_to );
use Encode::IMAPUTF7;
use File::Spec::Functions qw( catfile );

use FindBin qw( $RealBin );
use lib "$RealBin/lib";
use base qw( Command );

sub execute {
  my ( $self, $folder, $directory ) = @_;

  unless ( defined $folder && defined $directory ) {
    return;
  }

  my $client = $self->{client};

  from_to( $folder, 'UTF-8', 'IMAP-UTF-7' );
  $client->select( $folder ) or die $@;

  my $count = $client->message_count;
  unless ( defined $count ) {
    die $@;
  }
  if ( $count == 0 ) {
    return;
  }

  my @messages = $client->sort( 'DATE', 'US-ASCII', 'ALL' ) or die $@;
  unless ( @messages ) {
    return;
  }
  if ( scalar @messages == 0 ) {
    return;
  }

  unless ( -d $directory ) {
    mkdir $directory or die $!;
  }

  my $length = length scalar @messages;
  my $format = sprintf '%%0%dd', $length;

  my $index = 1;
  foreach my $message ( @messages ) {
    my $basename = sprintf $format, $index;
    my $uid      = sprintf $format, $message;

    say STDERR "$basename : $uid";

    my $filename = catfile( $directory, $basename );
    $client->message_to_file( $filename, $message ) or die $@;

    $index++;
  }
}

1;

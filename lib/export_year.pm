package export_year;

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
  my ( $self, $folder, $directory, $year ) = @_;

  unless ( defined $folder && defined $directory && defined $year ) {
    return;
  }

  my $client = $self->{client};

  from_to( $folder, 'UTF-8', 'IMAP-UTF-7' );
  $client->select( $folder ) or die $!;

  my $since    = sprintf 'SENTSINCE 01-Jan-%d',  $year;
  my $before   = sprintf 'SENTBEFORE 01-Jan-%d', $year + 1;
  my @messages = $client->sort( 'DATE', 'US-ASCII', $since, $before ) or die $!;
  unless ( @messages ) {
    return;
  }

  my $count  = scalar @messages;
  my $length = length $count;
  my $format = sprintf '%%0%dd', $length;

  unless ( -d $directory ) {
    mkdir $directory or die $!;
  }

  my $index = 1;
  foreach my $message ( @messages ) {
    my $basename = sprintf $format, $index;
    my $uid      = sprintf $format, $message;

    say STDERR "$basename : $uid";

    my $filename = catfile( $directory, $basename );
    $client->message_to_file( $filename, $message ) or die $!;

    $index++;
  }
}

1;
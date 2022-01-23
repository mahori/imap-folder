package export_year;

use strict;
use warnings;
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
  $client->select( $folder ) or die $@;

  my $count = $client->message_count;
  unless ( defined $count ) {
    die $@;
  }
  if ( $count == 0 ) {
    return;
  }

  my $since    = sprintf 'SENTSINCE 01-Jan-%d',  $year;
  my $before   = sprintf 'SENTBEFORE 01-Jan-%d', $year + 1;
  my @messages = $client->sort( 'DATE', 'US-ASCII', $since, $before ) or die $@;
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

    my $file = catfile( $directory, $basename );

    print STDERR $basename, ' : ';

    $client->message_to_file( $file, $message ) or die $@;

    print STDERR $uid, "\n";

    $index++;
  }
}

1;

package export_date;

use strict;
use warnings;
use File::Spec::Functions qw( catfile );

use FindBin qw( $RealBin );
use lib "$RealBin/lib";
use base qw( Command );

sub options {
  my $class = shift;

  return 'folder', 'directory';
}

sub execute {
  my ( $self, $folder, $directory ) = @_;

  unless ( defined $folder && defined $directory ) {
    return;
  }

  my $client = $self->{client};

  $self->folder_select( $folder );

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

    my $file = catfile( $directory, $basename );

    print STDERR $basename, ' : ';

    $client->message_to_file( $file, $message ) or die $@;

    print STDERR $uid, "\n";

    $index++;
  }
}

1;

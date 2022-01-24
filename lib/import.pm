package import;

use strict;
use warnings;
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

  $self->folder_select( $folder );

  opendir my $dh, $directory or die $!;
  my @entries = readdir $dh;
  closedir $dh;

  foreach my $entry ( sort @entries ) {
    my $file = catfile( $directory, $entry );

    unless ( -f $file ) {
      next;
    }

    print STDERR $entry, ' : ';

    my $uid = $client->append_file( $folder, $file ) or die $client->LastError;

    print STDERR $uid, "\n";
  }
}

1;

package help;

use strict;
use warnings;
use File::Basename qw( basename );

use FindBin qw( $RealBin );
use lib "$RealBin/lib";
use base qw( Command );

sub options {
  my $class = shift;

  return 'command';
}

sub execute {
  my ( $self, $command ) = @_;

  my $basename = basename( $0 );

  unless ( defined $command ) {
    print STDERR 'Usage: ', $basename, ' [server_option] <command>', "\n";
    return;
  }

  my $module = $command;
  $module =~ s/-/_/g;

  eval "use $module";
  if ( $@ ) {
    die $@;
  }

  print STDERR 'Usage: ', $basename, ' [server_option] ', $command;

  my @options = $module->options;
  if ( @options ) {
    foreach my $option ( @options ) {
      print STDERR ' <', $option, '>';
    }
  }

  print STDERR "\n";
}

1;

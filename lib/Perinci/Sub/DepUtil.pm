package Perinci::Sub::DepUtil;

use 5.010001;
use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
                       declare_function_dep
               );

# VERSION

sub declare_function_dep {
    my %args    = @_;
    my $name    = $args{name}   or die "Please specify dep's name";
    my $schema  = $args{schema} or die "Please specify dep's schema";
    my $check   = $args{check};

    $name =~ /\A\w+\z/
        or die "Invalid syntax on dep's name, please use alphanums only";

    require Rinci::Schema;
    # XXX merge first or use Perinci::Object, less fragile
    my $dd = $Rinci::Schema::function->[1]{"[merge+]keys"}{deps}
        or die "BUG: Schema structure changed (1)";
    $dd->[1]{keys}
        or die "BUG: Schema structure changed (2)";
    $dd->[1]{keys}{$name}
        and die "Dependency type '$name' is already declared";
    $dd->[1]{keys}{$name} = $args{schema};

    if ($check) {
        require Perinci::Sub::DepChecker;
        no strict 'refs';
        *{"Perinci::Sub::DepChecker::checkdep_$name"} = $check;
    }
}

1;
# ABSTRACT: Utility routines for Perinci::Sub::Dep::* modules

=head1 SYNOPSIS


=head1 FUNCTIONS

=head2 declare_function_dep


=head1 SEE ALSO

L<Perinci>

Perinci::Sub::Dep::* modules.

=cut

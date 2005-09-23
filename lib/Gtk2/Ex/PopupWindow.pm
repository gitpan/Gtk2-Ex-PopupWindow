package Gtk2::Ex::PopupWindow;

our $VERSION = '0.02';

use strict;
use warnings;
use Gtk2;
use Glib qw(TRUE FALSE);

sub new {
	my ($class, $parent) = @_;
	my $self  = {};
	bless ($self, $class);
	$self->{parent} = $parent;
	$self->{showing} = FALSE;
	$self->{move_with_parent} = FALSE; # default behaviour
	my $window = Gtk2::Window->new('toplevel');
	$window->set_skip_taskbar_hint(TRUE) unless $^O =~ /Win32/;
	$window->set_skip_pager_hint(TRUE) unless $^O =~ /Win32/;
	$window->set_decorated(0);
	$window->add_events ( [ 'button-press-mask' ] );
	$self->{window} = $window;
	$parent->signal_connect('realize' => 
		sub {
			$self->_add_events;
			$self->{window}->set_transient_for($parent->get_toplevel);
			return 0;
		}
	);
	return $self;
}

sub set_move_with_parent {
	my ($popupself, $flag) = @_;
	$popupself->{move_with_parent} = $flag;
}

sub get_move_with_parent {
	my ($popupself) = @_;
	return $popupself->{move_with_parent};
}

sub show {
	my ($popupself) = @_;
	my ($x, $y) = $popupself->{parent}->window->get_origin;
	my $alloc = $popupself->{parent}->allocation;
	$x += $alloc->x;
	$y += $alloc->y;
	$y += $popupself->{parent}->size_request()->height;
	$popupself->{window}->show_all();
	my $window = $popupself->{window};
	$popupself->{window}->move($x,$y);
	$popupself->{showing} = TRUE;
	return 0;
}

sub hide {
	my ($popupself) = @_;
	$popupself->{window}->hide;
	$popupself->{showing} = FALSE;
	return 0;
}

sub toggle {
	my ($popupself) = @_;
	if ($popupself->{window}->visible) {
		$popupself->hide();
	} else {
		$popupself->show();
	}
	return 0;
}

# ------------------------------------------ #
# All methods below this are private methods #
# All private methods start with _           #
# ------------------------------------------ #
sub _add_events {
	my ($popupself) = @_;
	my $parent = $popupself->{parent};
	my $window = $parent->get_toplevel;
	$popupself->{window}->signal_connect ('focus-out-event' => 
		sub {
			my ($self, $event) = @_;
			$popupself->hide unless $popupself->{move_with_parent};
			return 0;
		}
	);
	$window->signal_connect ('button-press-event' => 
		sub {
			my ($self, $event) = @_;
			$popupself->hide unless $popupself->{move_with_parent};
			return 0;
		}
	);
	$window->signal_connect ('configure-event' => 
		sub {
			my ($self, $event) = @_;
			$popupself->show if $popupself->{showing};
			$popupself->hide unless $popupself->{move_with_parent};
			return 0;
		}
	);
	$window->signal_connect ('window-state-event' => 
		sub {
			my ($self, $event) = @_;
			my $mask = $event->changed_mask;
			if ("$mask" eq '[ iconified ]' or "$mask" eq '[ maximized ]') {
				$popupself->show if $popupself->{showing};
			}
			return 0;
		}
	);
}
 
1;

__END__

=head1 AUTHOR

Lee Aylward
Ofey Aikon, C<< <ofey.aikon at gmail dot com> >>


=head1 COPYRIGHT & LICENSE

Copyright 2005 Lee Aylward, Ofey Aikon, All Rights Reserved.

This library is free software; you can redistribute it and/or modify it under
the terms of the GNU Library General Public License as published by the Free
Software Foundation; either version 2.1 of the License, or (at your option) any
later version.

This library is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU Library General Public License for more
details.

You should have received a copy of the GNU Library General Public License along
with this library; if not, write to the Free Software Foundation, Inc., 59
Temple Place - Suite 330, Boston, MA  02111-1307  USA.

=cut

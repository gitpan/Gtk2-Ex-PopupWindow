use strict;
use warnings;
use Glib qw(TRUE FALSE);
use Gtk2 qw/-init/;
use Data::Dumper;
use Gtk2::Ex::PopupWindow;

use Gtk2::TestHelper tests => 5;

# ------------------------------------ #
# Show the popup, then move the window
# Popup should not get closed
# ------------------------------------ #

my $label = Gtk2::Label->new(' Sample Label ');
my $popupwindow = Gtk2::Ex::PopupWindow->new($label);
my $window = Gtk2::Window->new;
$window->add($label);
$window->show_all;
$popupwindow->set_move_with_parent(TRUE);
ok($popupwindow->get_move_with_parent());

isa_ok($popupwindow, "Gtk2::Ex::PopupWindow");
$popupwindow->show;
ok($popupwindow->{window}->visible());

# Move the window and see. The popup should be close
Glib::Timeout->add(100, \&move_window);

Gtk2->main;

sub move_window {
	my ($x, $y) = $window->get_position;
	$window->move($x+10, $y+10);
	ok($popupwindow->{window}->visible());
	$popupwindow->hide;
	ok(!$popupwindow->{window}->visible());
	Gtk2->main_quit;
	return FALSE;
}



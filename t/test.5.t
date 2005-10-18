use strict;
use warnings;
use Glib qw(TRUE FALSE);
use Gtk2 qw/-init/;
use Data::Dumper;
use Gtk2::Ex::PopupWindow;

use Gtk2::TestHelper tests => 9;

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

Glib::Timeout->add(100, \&move_window);
Glib::Timeout->add(150, \&check_window);

Glib::Timeout->add(200, \&move_window);
Glib::Timeout->add(250, \&check_window);

Glib::Timeout->add(300, \&maximize);
#Glib::Timeout->add(350, \&check_window);

Glib::Timeout->add(500, \&terminate);

Gtk2->main;

sub move_window {
    my ($x, $y) = $window->get_position;
    $window->move($x+10, $y+10);
    ok($popupwindow->{window}->visible());
    return FALSE;
}

sub check_window {
    ok($popupwindow->{window}->visible());
    my ($x, $y) = $label->window->get_origin;
    my $alloc = $label->allocation;
    $x += $alloc->x;
    $y += $alloc->y;
    $y += $label->size_request()->height;
    my ($x1, $y1) = $popupwindow->{window}->window->get_origin;
    is (Dumper([$x, $y]) , Dumper([$x1, $y1]));
    return FALSE;
}

sub maximize {
    $window->window->maximize;
    return FALSE;
}


sub terminate {
    Gtk2->main_quit;
}



use strict;
use warnings;
use Glib qw(TRUE FALSE);
use Gtk2 qw/-init/;
use Data::Dumper;
use Gtk2::Ex::PopupWindow;

use Gtk2::TestHelper tests => 4;

my $label = Gtk2::Label->new(' Sample Label ');
my $popupwindow = Gtk2::Ex::PopupWindow->new($label);
my $window = Gtk2::Window->new;
$window->add($label);
$window->show_all;

isa_ok($popupwindow, "Gtk2::Ex::PopupWindow");
$popupwindow->show;
ok($popupwindow->{window}->visible());

# Move the window and see. The popup should be close
Glib::Timeout->add(100, \&show_window);

Gtk2->main;

sub show_window {
    $popupwindow->show;
    ok($popupwindow->{window}->visible());
    my ($x, $y) = $label->window->get_origin;
    my $alloc = $label->allocation;
    $x += $alloc->x;
    $y += $alloc->y;
    $y += $label->size_request()->height;
    my ($x1, $y1) = $popupwindow->{window}->window->get_origin;
    is (Dumper([$x, $y]) , Dumper([$x1, $y1]));
    Gtk2->main_quit;
    return FALSE;
}



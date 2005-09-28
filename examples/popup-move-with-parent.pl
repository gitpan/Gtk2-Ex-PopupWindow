use strict;
use warnings;
use Glib qw(TRUE FALSE);
use Gtk2 qw/-init/;
use Data::Dumper;
use Gtk2::Ex::Simple::List;
use Gtk2::Ex::PopupWindow;

my $window = Gtk2::Window->new;
$window->signal_connect('destroy', sub {Gtk2->main_quit;});

my $openbutton = Gtk2::Button->new_from_stock('gtk-open');
my $togglebutton = Gtk2::Button->new_from_stock('gtk-help');
my $closebutton = Gtk2::Button->new_from_stock('gtk-close');

my $popupwindow = Gtk2::Ex::PopupWindow->new($togglebutton);
$popupwindow->set_move_with_parent(TRUE);

my $slist = Gtk2::Ex::Simple::List->new (
	'Flag'			=> 'bool',
	'Name'			=> 'text',
);
@{$slist->{data}} = (
	  [ 1, 'This'],
	  [ 1, 'That'],
	  [ 0, 'What'],
);
my $text = Gtk2::TextView->new;
$text->set_buffer(Gtk2::TextBuffer->new);
my $vbox1 = Gtk2::VBox->new (FALSE, 0);
$vbox1->pack_start ($text, FALSE, TRUE, 0);    
$vbox1->pack_start ($slist, FALSE, TRUE, 0);    
$popupwindow->{window}->add($vbox1);
$popupwindow->{window}->set_default_size(100, 200);

my $hbox = Gtk2::HBox->new (TRUE, 0);
$hbox->pack_start ($openbutton, FALSE, TRUE, 0);    
$hbox->pack_start ($togglebutton, FALSE, TRUE, 0);    
$hbox->pack_start ($closebutton, FALSE, TRUE, 0);

my $vbox = Gtk2::VBox->new (FALSE, 0);
$vbox->pack_start ($hbox, FALSE, TRUE, 0);
$window->add ($vbox);

$openbutton->signal_connect('button-release-event' => 
	sub {
		$popupwindow->show;
		return 0;
	}
);
$closebutton->signal_connect('button-release-event' => 
	sub {
		$popupwindow->hide;
		return 0;
	}
);
$togglebutton->signal_connect('button-release-event' => 
	sub {
		$popupwindow->toggle;
		return 0;
	}
);

$window->set_default_size(500, 400);
$window->show_all;

Gtk2->main;

use strict;
use warnings;
use Glib qw(TRUE FALSE);
use Gtk2 qw/-init/;
use Gtk2::Ex::PopupWindow;
use Gtk2::Ex::Simple::List;
use Data::Dumper;

my $window = Gtk2::Window->new;
$window->signal_connect('destroy', sub {Gtk2->main_quit;});

my $label = Gtk2::Label->new('Sample Label');
my $openbutton = Gtk2::Button->new_from_stock('gtk-open');

my $popupwindow = Gtk2::Ex::PopupWindow->new($openbutton);
my $text = Gtk2::TextView->new;
$text->set_buffer(Gtk2::TextBuffer->new);

$popupwindow->{window}->add($text);
$popupwindow->{window}->set_default_size(100, 200);

my $hbox = Gtk2::HBox->new (TRUE, 0);
$hbox->pack_start ($label, FALSE, TRUE, 0);    
$hbox->pack_start ($openbutton, FALSE, TRUE, 0);    

my $vbox = Gtk2::VBox->new (FALSE, 0);
$vbox->pack_start ($hbox, FALSE, TRUE, 0);
$window->add ($vbox);
$window->add_events( [ 'button-press-mask' ] );

$popupwindow->signal_connect('show' => 
	sub {
		print "Showing\n";
	}
);
$popupwindow->signal_connect('hide' => 
	sub {
		print "Hidden\n";
	}
);
$popupwindow->{window}->signal_connect('event' => 
	sub {
		my ($self, $event) = @_;
		#print Dumper $event->type;
		return 0;
	}
);
$window->signal_connect('window-state-event' => 
	sub {
		my ($self, $event) = @_;
		#print Dumper $event;
		return 0;
	}
);

$openbutton->signal_connect('button-release-event' => 
	sub {
		$popupwindow->show;
		return 0;
	}
);
print "Click 'open' button to open...\n";
print "Click anywhere except the 'open' button to close\n";
$window->set_default_size(500, 400);
$window->show_all;

Gtk2->main;

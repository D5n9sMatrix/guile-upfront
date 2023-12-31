=head1 NAME
 
Tkx::Tutorial - How to use Tkx
 
=head1 DESCRIPTION
 
I<Tk> is a toolkit for creating applications with
graphical interfaces on Windows, Mac OS X and X11.  The Tk toolkit
is native to the I<Tcl> programming language, but its ease of use and
cross-platform availability has made it the GUI toolkit of choice for
many other dynamic languages.
 
I<Tkx> is a Perl module that makes the Tk toolkit available to Perl
programs.  By loading the Tkx module Perl programs can create
windows and fill them with text, images, buttons and other controls
that make up the user interface of the application.
 
=head2 Hello World
 
Let's start with the mandatory exercise of creating an application
that greats the world.  We'll make the application window contain a
single button which will shut down the application if clicked.  The
code to make this happen is:
 
    use Tkx;
     
    Tkx::button(".b",
        -text => "Hello, world",
        -command => sub { Tkx::destroy("."); },
    );
    Tkx::pack(".b");
     
    Tkx::MainLoop()
 
Save this to a file called F<hello.pl> and then run C<perl hello.pl>
to start the application.  A window with the text "Hello, world"
should appear on your screen.  Let's look at what this code is doing.
 
After the Tkx module has been loaded by the C<use Tkx> statement, the
application will show an empty window called ".".  We create a I<button>
with the name ".b" and tell the window to display the button with the
call to C<Tkx::pack()>.  After the layout of the window has been set up,
we need to pass control back to Tk so that it can draw the window and
invoke our callback if the button is clicked.  This is done with the
C<Tkx::MainLoop()> call at the end.  Clicking the button will invoke the
subroutine registered with the button's C<-command> option.  In this
case the callback destroys the window, which in turn terminates the
application.
 
For reference, this is how the same program would look in Tcl:
 
    package require Tk
     
    button .b \
        -text "Hello, world" \
        -command { destroy . }
    pack .b
 
This program can be executed by the F<tclsh> binary that comes with
Tcl/Tk.  As you can see the code is mostly identical, but with a
slightly different syntax.  The only difference is that the call
to MainLoop() is implicit in Tcl and does not have to be spelled out.
 
Tkx does not include documentation for all the Tk widgets available for
use.  Instead you will need to read the mostly excellent documentation
that comes with Tcl/Tk and extrapolate the Tkx syntax.  This translation
is relatively straightforward and basically involves adding the prefix
"Tkx::" to all the functions and passing arguments with Perl syntax (as
with the Tkx::button examples above).  The Tk documentation can be found
here:
 
L<http://aspn.activestate.com/ASPN/docs/ActiveTcl/at.pkg_index.html>.
 
This documents core Tk and useful add-on packages that are part of
ActiveTcl. The ActiveTcl HTML documentation can also be downloaded from
L<http://downloads.activestate.com/ActiveTcl/html/> and installed
locally.  The official Tcl/Tk docs are found at
L<http://www.tcl.tk/doc/>.
 
A major complication in the mapping to Perl is how to invoke
subcommands on Tk widgets.  For example, if you want to change the
text of the button created above you might in Tcl do:
 
    .b configure -text "Goodbye, cuel world"
 
a literal translation to Tkx would be:
 
    Tkx::.b("configure", -text => "Goodbye, cruel world");
 
or
 
    Tkx::.b_configure(-text => "Goodbye, cruel world");
 
but neither of those work as you can't use "." as part of function
names in Perl.  Because of this we almost always use objects when
working with Tkx widgets.
 
=head2 Hello World with objects
 
The windows and controls that make up a Tk interface are called
I<widgets>.  The widgets are identified by path names of the form
C<.foo.bar.baz>.  These names are hierarchical in the same way as file
system names are, but "." is used instead of "/" to separate levels.
The name C<.foo.bar.baz> is the name of a widget that is child of widget
C<.foo.bar> which in turn is a child of C<.foo>.  At the top of this
hierarchy we have a widget called C<.>, which is the main window of
the application.
 
The Tkx module provides the C<Tkx::widget> class, which can be
used to hide the details of Tk path names from Tkx applications.
This provide a more "perlish" way to create and manipulate Tk widgets.
It also provide a convenient way to invoke subcommands (methods) on
the widgets.
 
Our "Hello, world" program can be rewritten like this using the
C<Tkx::widget> class:
 
    use Tkx;
     
    my $mw = Tkx::widget->new(".");
    my $b = $mw->new_button(
        -text => "Hello, world",
        -command => sub { $mw->g_destroy; },
    );
    $b->g_pack;
     
    Tkx::MainLoop()
 
By loading the Tkx module, we make the C<Tkx::widget> class
available and create the main window (the widget called C<.>).  Next,
we instantiate a new C<Tkx::widget> object wrapping the main window.
It is customary to name this object C<$mw>.
 
To create a new button child widget we call the C<< $mw->new_button >>
method.  Constructor methods are always prefixed with C<new_>.  The rest
of the method name is the name of the Tk widget to create; i.e. "button"
in this case.  Arguments are passed as before.
 
Calling a "g_" method will invoke the corresponding Tk command with the
widget path as argument.  In the code above we destroy the main window
by calling C<< $mw->g_destroy >> and we pack the button in the main
window by invoking C<< $b->g_pack >>.
 
In the end the MainLoop is invoked as before.
 
For trivial programs like the one above, using C<Tkx::widget> wrappers
does not appear to be very helpful, but as the application grows and the
Tk path names get longer, the advantage is more noticeable.
 
=head2 Hello World expanded
 
The following, slightly expanded version of the previous Hello World
program, introduces a few more Tkx features.  Line numbers have been
added to the program for easier to reference back to its statements:
 
    1   use strict;
    2   use Tkx;
    3   
    4   my $mw = Tkx::widget->new(".");
    5   $mw->g_wm_title("Hello, world");
    6   $mw->g_wm_minsize(300, 200);
    7   
    8   my $b;
    9   $b = $mw->new_button(
    10      -text => "Hello, world",
    11      -command => sub {
    12          $b->m_configure(
    13              -text => "Goodbye, cruel world",
    14          );
    15          Tkx::after(1500, sub { $mw->g_destroy });
    16      },
    17  );
    18  $b->g_pack(
    19      -padx => 10,
    20      -pady => 10,
    21  );
    22  
    23  Tkx::tk___messageBox(
    24     -parent => $mw,
    25     -icon => "info",
    26     -title => "Tip of the Day",
    27     -message => "Please be nice!",
    28  );
    29  
    30  Tkx::MainLoop()
 
The first thing we add is the C<< use strict >> statement, because
that's a good practice in general.
 
In line 5 and 6 we set up some window manager attributes of the main
application window.  We use underscore in the g_ method names where Tcl
would use space between words.  The same rules apply to the function
names in the C<Tkx::> namespace directly.  We could alternatively have
modified the window attributes with:
 
    Tkx::wm_title($mw, "Hello, world");
    Tkx::wm_minsize($mw, 300, 200);
 
In Tcl, this would be:
 
    wm title . "Hello, world"
    wm minsize . 300 200
 
The rule is: A single underscore on the Perl side turns into space on
the Tcl side.
 
In line 11 to 16 we have expanded the button callback to change the text
of button and wait 1.5 seconds before shutting down the application.  In
addition to the "g_" methods described in the previous section,
C<Tkx::widget> also provides "m_" methods which are forwarded as Tcl
subcommands of the current widget.  The most commonly used subcommand is
"configure" that is used to change the attributes of a widget as we do
in line 12.  Since we now reference $b from the callback, we had to
declare the variable upfront in line 8 instead of declaring it together
with the assignment as we did previously.  In line 15 we destroy the
window after a delay of 1500ms, which should be enough time to read the
new "Goodbye, cruel world" text.  
 
The "m_" method prefix is optional, you might prefer to leave it out.
 
Line 18 adds padding around buttons, which is usually a good idea.
 
In line 23 we invoke the messageBox command to pop up a useful
reminder to our user.  But what's up with the "tk___" prefix?  In the
Tcl docs you will find that the name of this command is actually
"tk_messageBox".  Remember the previous rule that an underscore in
Tkx:: names turn into a space on the Tcl side?  If you try to call
C<Tkx::tk_messageBox()> you will get an error telling you:
 
    bad option "messageBox": must be appname, caret, scaling,
    useinputmethods, or windowingsystem
 
What happens is that Tkx invoked the "tk messageBox" command, but the
Tcl "tk" command only takes the subcommands listed in the error message
above and refuse to do anything about "messageBox".  In order to invoke
Tcl commands with underscore their name, you need to I<triple> the
underscore on the Perl side, which gives us C<Tkx::tk___messageBox()>.
Double underscores in names have yet another meaning that we will tell
you about in the next section.
 
=head2 Setting up a menu line
 
Most real GUI application will need a menu line at the top of the
application window or screen.  The following runnable program shows
how a minimal menu can be set up with Tkx:
 
    1   #!/usr/bin/perl -w
    2   
    3   use strict;
    4   use Tkx;
    5   
    6   our $VERSION = "1.00";
    7   
    8   (my $progname = $0) =~ s,.*[\\/],,;
    9   my $IS_AQUA = Tkx::tk_windowingsystem() eq "aqua";
    10  
    11  Tkx::package_require("style");
    12  Tkx::style__use("as", -priority => 70);
    13  
    14  my $mw = Tkx::widget->new(".");
    15  $mw->configure(-menu => mk_menu($mw));
    16  
    17  Tkx::MainLoop();
    18  exit;
    19  
    20  sub mk_menu {
    21      my $mw = shift;
    22      my $menu = $mw->new_menu;
    23  
    24      my $file = $menu->new_menu(
    25          -tearoff => 0,
    26      );
    27      $menu->add_cascade(
    28          -label => "File",
    29          -underline => 0,
    30          -menu => $file,
    31      );
    32      $file->add_command(
    33          -label => "New",
    34          -underline => 0,
    35          -accelerator => "Ctrl+N",
    36          -command => \&new,
    37      );
    38      $mw->g_bind("<Control-n>", \&new);
    39      $file->add_command(
    40          -label   => "Exit",
    41          -underline => 1,
    42          -command => [\&Tkx::destroy, $mw],
    43      ) unless $IS_AQUA;
    44  
    45      my $help = $menu->new_menu(
    46          -name => "help",
    47          -tearoff => 0,
    48      );
    49      $menu->add_cascade(
    50          -label => "Help",
    51          -underline => 0,
    52          -menu => $help,
    53      );
    54      $help->add_command(
    55          -label => "\u$progname Manual",
    56          -command => \&show_manual,
    57      );
    58  
    59      my $about_menu = $help;
    60      if ($IS_AQUA) {
    61          # On Mac OS we want about box to appear in the application
    62          # menu.  Anything added to a menu with the name "apple" will
    63          # appear in this menu.
    64          $about_menu = $menu->new_menu(
    65              -name => "apple",
    66          );
    67          $menu->add_cascade(
    68              -menu => $about_menu,
    69          );
    70      }
    71      $about_menu->add_command(
    72          -label => "About \u$progname",
    73          -command => \&about,
    74      );
    75  
    76      return $menu;
    77  }
    78  
    79  
    80  sub about {
    81      Tkx::tk___messageBox(
    82          -parent => $mw,
    83          -title => "About \u$progname",
    84          -type => "ok",
    85          -icon => "info",
    86          -message => "$progname v$VERSION\n" .
    87                      "Copyright 2005 ActiveState. " .
    88                      "All rights reserved.",
    89      );
    90  }
 
We start out as all proper Perl programs should by enabling warnings and
stricture at line 1 and 3.  Then, we load Tkx which will create our main
application window at line 4.
 
In line 9 we initialize the C<$IS_AQUA> constant.  Aqua is the native
interface of Mac OS X.  We need this constant because the menu layout
on Aqua is not the same as in other windowing systems.  Note that
Tk on Mac OS X can be compiled against either Aqua or X11.  When our
application runs under X11 we want to use the standard Unix menu
layout, so it would not be correct to just make our code conditional
on what operating system it runs under (C<< $^O eq 'darwin' >> for Mac
OS X).
 
In line 11 and 12 we override the default look&feel style of Tk to a
more modern variant. Tcl packages can be loaded with the
C<Tkx::package_require()> function and we can access the Tcl command
C<style::use> as C<Tkx::style__use> in Perl, i.e. we need to turn the
double colon into a double underscore.  More about Tcl packages and
namespaces in the next section.
 
In line 14, we obtain a C<Tkx::widget> reference to the main window as
before, then set up the application menu by setting up the C<-menu>
option of the main window in line 15.
 
In a real application there would be additional code between line 15
and 17 to set up the rest of the application window, but for this
demonstration we'll just leave the window empty.
 
In line 17, we ask Tk to start processing events by invoking
C<Tkx::MainLoop()>.  This function will return when the application
window has been destroyed.  When that happens, we exit at line 18.
 
The application menu itself is set up and returned by the C<mk_menu()>
function in line 20 to 77.  This code should be easy enough to follow.
Note how we make I<File | New> and I<Help | Foo Manual> both reference
functions that are not yet written.  The application will still run,
but when you try to invoke these menu entries you get an "Application
Error Dialog" from Tk.  It is handy to be able to leave stubs like
this around during the development, just remember to add the C<new>
and C<show_manual> functions before the application ships.
 
The C<-underline> options are provided to make it possible to select
menu entries with the keyboard.  The corresponding character of the
C<-label> will be underlined and you will be able to select this entry
by pressing the key when the menu is active.
 
It is also possible to set up direct keyboard shortcuts as we've done
for the I<File | New> function at line 32.  Note that the
C<-accelerator> option only adds the text to the menu item, so we need
to use an explicit call to set up this binding in line 38.
 
For Aqua we don't want to add the "File | Exit" entry to the menu
because the OS itself always provide a Quit action in the application
menu.  Aqua applications will also need to add the "About" function
on the application menu instead of the "Help" menu as is common on
other platforms.
 
The menu names "apple" and "help" provided in line 46 and 65 has special
significance to Tk.  Menu items added to the "apple" menu will show up
in the application menu.  In Mac OS X these entries show up at the top
of the menu just right of the apple.  If not provided, Tk provides its
own "About" entry that will tell you about what version of Tcl/Tk you
are using.  A menu called "help" will be flushed right on Unix, even
though this style seems to be out of fashion in modern Unix
applications.
 
The Tkx distribution contains a script called F<menu> which is a
runnable version of the program shown here.  You might want to use
this as a starting point for your own Tkx applications.
 
=head2 Using Tcl packages
 
When the Perl application starts up and loads Tkx, the only functions
available in the C<Tkx::> namespace are those commands provided by core
Tcl/Tk.  These commands are described in the "Tcl" and "Tk" sections
at L<http://aspn.activestate.com/ASPN/docs/ActiveTcl/at.pkg_index.html>.
 
Additional commands can be loaded from Tcl packages.  Once loaded, new
commands show up in the C<Tkx::> namespace.  This example loads the
"Tktable" package in order to make the C<table> command available for
creating I<table> widgets:
 
    use Tkx;
    Tkx::package_require("Tktable");
 
    my $mw = Tkx::widget->new(".");
    my $t = $mw->new_table(
        -rows => 5,
        -cols => 3,
    );
    $t->g_pack;
     
    Tkx::MainLoop()
 
Packages are loaded by calling the C<Tkx::package_require()> function
taking the package name as argument.  An optional version number can
be provided as the second argument if you want to make sure a certain
version or newer is loaded.
 
One source of confusion here is the proper spelling of the
package name to provide to Tkx::package_require().  The Tcl/Tk
documentation will call the package in the example above I<TkTable>
(with two upper case "T"s) and not really mention the exact spelling
of the package name (only one upper case "T").  In some cases the
"synopsis" section describing the package will spell out the package
name, but in cases like this we have found no better way than to look 
into the F<pkgIndex.tcl> files in the Tcl F<lib/> area if loading the
package fails.  The package documented as "BWidgets" should be loaded
as "BWidget" (without the "s") and the package documented as
"IWidgets" should be loaded as "Iwidgets" (with a lower case "w").
 
Most modern Tcl packages do not create names at the top level like
TkTable above.  Instead, they create functions in a Tcl namespace with a
name matching the package name.  In the menu example of the previous
section we loaded the "style" package which created a command called
"use" in the "style" namespace.  This command can be referenced as
"::style::use" or "style::use" from Tcl.  From Perl this maps to a
function called C<Tkx::style__use> (i.e. we replace the double colon
with double underscore and ignore the colon in the front).  Read L<Tkx>
for details about how sequences of "_" in C<Tkx::> names are mapped to
Tcl names.
 
=head2 Subclassing Tkx::widget
 
In Tkx applications it is often convenient to use your own subclass of
C<Tkx::widget> where you can introduce shortcuts and adapters for the
raw Tcl commands.  The following is an example class, which could be
saved to the file F<MyWidget.pm>:
 
    1   package MyWidget;
    2   
    3   use strict;
    4   use base qw(Tkx::widget);
    5   use Carp qw(croak);
    6   
    7   sub messageBox {
    8       my $self = shift;
    9       return Tkx::tk___messageBox(-parent => $self, @_);
    10  }
    11  
    12  sub getOpenFile {
    13      my $self = shift;
    14      return Tkx::tk___getOpenFile(-parent => $self, @_);
    15  }
    16  
    17  sub bell {
    18      my $self = shift;
    19      Tkx::bell(-displayof => $self, @_);
    20  }
    21  
    30  sub pack {
    31      my $self = shift;
    32      $self->g_pack(@_);
    33      return $self;
    34  }
    35  
    36  sub _nclass {
    37      return __PACKAGE__;
    38  }
    39  
    40  1;
 
 
The main program would use it like this:
 
    use Tkx;
    use MyWidget;
    my $mw = MyWidget->new(".");
    $mw->messageBox(...);
     
    ...
 
    Tkx::MainLoop();
 
The MyWidget class above provides shortcuts for the "messageBox" and
"getOpenFile" in order to hide the triple underscore ugliness and
propagate the C<-parent> attribute.  Similar reasoning exists for the
"bell".
 
The C<pack> method is provided so that we can initialize and pack a
widget in the same statement and avoid repeated typing of the "g_"
method prefix:
 
    my $b = $mw->new_button(...)->pack;
 
The C<_nclass> method needs to be overridden so that any new widget
children created also end up as MyWidget objects.  This method is called
internally by methods like C<< $mw->new_button(...) >> to determine
which kind of object will wrap the newly created widget path.
 
Having you own application-specific widget class provides a place to add
methods discovered by refactoring repeated code in your application.
 
=head1 LICENSE
 
This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
 
Copyright 2005 ActiveState.  All rights reserved.
 
=head1 SEE ALSO
 
L<Tkx>
 
The bundled sample programs; L<tkx-ed>, L<tkx-prove>.

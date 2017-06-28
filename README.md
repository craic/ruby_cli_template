# ruby_cli_template
A basic command line interpreter in Ruby that can handle, and redirect, STDIN and STDOUT

This script implements a simple command line interface using OptionParser
and can handle redirected STDIN and STDOUT

I use this as the starting point for writing bioinformatics tools in Ruby that
function like classic Unix tools that can be linked together in pipes

I'm choosing to use the '--' option prefix exclusively (e.g. --help) as opposed to the
shorter '-' prefix (e.g. -h)

I am also choosing to handle options with defined vocabulaires myself as opposed to
do this with OptionParser - using the library allows you to use unique shortened
strings e.g. f instead of foobar
Doing it myself allows for more flexible error handling

Full documentation for OptionParser is here:

https://ruby-doc.org/stdlib-2.4.1/libdoc/optparse/rdoc/OptionParser.html

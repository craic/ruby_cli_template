#!/usr/bin/env ruby

# ruby_cli_template.rb

# Copyright 2017  Robert Jones  jones@craic.com

# Freely distributed under the terms of the MIT license

# This script implements a simple command line interface using OptionParser
# and can handle redirected STDIN and STDOUT

# I use this as the starting point for writing bioinformatics tools in Ruby that
# function like classic Unix tools that can be linked together in pipes

# I'm choosing to use the '--' option prefix exclusively (e.g. --help) as opposed to the
# shorter '-' prefix (e.g. -h)

# I am also choosing to handle options with defined vocabulaires myself as opposed to
# do this with OptionParser - using the library allows you to use unique shortened
# strings e.g. f instead of foobar
# Doing it myself allows for more flexible error handling

require 'optparse'


def process_options

  # arrays of the valid values for specific options
  valid_arguments = {}
  valid_arguments[:key] = [ 'feature_type', 'sub_type' ]

  error_flag = false

  options = {}

  # Define the options

  opt_parser = OptionParser.new do |opts|
    opts.banner = "Usage: #{File.basename($0)} [options]"

    # Required common options are defined here

    opts.on('--input FILENAME', 'Input file name [string] - default is STDIN') do |filename|
      options[:input] = File.expand_path(filename)
    end

    opts.on('--output FILENAME', 'Output file name [string] - default is STDOUT') do |filename|
      options[:output] = File.expand_path(filename)
    end

    opts.on_tail('--help', 'Output help message and exit') do
      $stderr.puts opts
      exit
    end

    opts.on("--[no-]verbose", "verbose") do |v|
      options[:verbose] = v
    end

    # Your custom options are defined here

    # In this example there are two options : --key and --value
    # --key can take either foo or bar as its value
    opts.on("--key KEY", String, "Search Key ['foo', 'bar']") do |k|
      options[:key] = k
    end

    opts.on("--value VALUE", String, "Search Value [string]") do |v|
      options[:value] = v
    end

  end

  # Parse the command line arguments and capture any errors from OptionParser
  # Don't exit the script until all validations have been performed

  begin
    opt_parser.parse!
  rescue => e
    $stderr.puts "** ERROR  #{e}"
    error_flag = true
  end

  # This section contains custom validations

  if options[:key] and not valid_arguments[:key].include?(options[:key])
    $stderr.puts "ERROR: --key #{options[:key]} is not valid - must be one of '#{valid_arguments[:key].sort.join(', ')}'"
    error_flag = true
  end

  # Check for missing args - no value should start with '--'
  # that indicates the previous key have no value unless it was set up that way
  # This assumes that no valid argument can begin with '--'

  options.keys.each do |key|
    if options[key].nil? or options[key] =~ /^\-\-/
      $stderr.puts "ERROR: option '--#{key}' is missing its value"
      error_flag = true
    end
  end

  # There are remaining arguments - that is an error
  if ARGV.length > 0
    $stderr.puts "ERROR: There is an unexpected extra argument: #{ARGV[0]}"
    error_flag = true
  end

  exit if error_flag

  # Redirect STDIN and/or STDOUT to files if they have been defined as options

  if options[:input]
    $stdin = File.open(options[:input], 'rb')
  end

  if options[:output]
    $stdout = File.open(options[:output], 'wb')
  end

  return options
end


# main ......................................................

options = process_options

options.keys.each do |option_key|
  puts "option #{option_key}   #{options[option_key]}"
end

# do input and output using $stdin and $stdout

$stdin.each_line do |line|
  # $stdout.puts line
  puts line
end

require 'json'
require 'optparse'
require 'safe_yaml'

require 'soya/actions'
require 'soya/cli_parser'
require 'soya/error'
require 'soya/expression'
require 'soya/version'

module Soya
  @@options = {}

  def self.options
    @@options
  end

  def self.load(filename, format)
    fd = (filename == '-') ? $stdin : File.open(filename, 'rb')
    contents = fd.read

    if (format == :json)
      return JSON.load(contents)
    elsif (format == :yaml || format == :yml)
      return YAML.load(contents)
    else
      ## The CLI parser should stop this from occurring.
      raise Soya::Error.new("impossible input format: #{format.to_s}")
    end
  end

  def self.verbose(message)
    if Soya.options[:verbose]
      $stderr.puts message
    end
  end

  def self.merge_strategy(key, v1, v2)
    if (Hash === v1 && Hash === v2)
      return v1.merge(v2, &method(:merge_strategy))
    elsif Soya.options[:strict]
      raise Soya::Error.new("duplicate key: #{key}")
    else
      return v2
    end
  end

  def self.deep_clone(obj)
    ## This breaks YAML anchors/references.
    Marshal.load(Marshal.dump(obj))
  end

  def self.run
    begin
      SafeYAML::OPTIONS[:default_mode] = :safe

      parser = Soya::CliParser.new(ARGV)
      @@options = parser.options
      args = parser.args

      filenames = (args + options[:define]).empty? ? ['-'] : args
      file_hashes = filenames.reduce({}) do |hash, filename|
        hash.merge(load(filename, options[:from]), &method(:merge_strategy))
      end

      actions = [
        { :class => Soya::Action::Definition, :param => options[:define]    },
        { :class => Soya::Action::Copying,    :param => options[:copy]      },
        { :class => Soya::Action::Extraction, :param => options[:extract]   },
        { :class => Soya::Action::Deletion,   :param => options[:delete]    },
        { :class => Soya::Action::Insertion,  :param => options[:insert]    },
        { :class => Soya::Action::Canonical,  :param => options[:canonical] },
        ## Soya::Action::Output class must be last because its #result is a String not a Hash.
        { :class => Soya::Action::Output,     :param => options[:to]        },
      ]
      puts actions.reduce(file_hashes) { |memo, action| action[:class].new(action[:param], memo).result }
    rescue Soya::Error => e
      $stderr.puts "#{File.basename($PROGRAM_NAME)}: #{e.to_s}"
      verbose(e.backtrace)
      exit e.return_code
    end
  end
end

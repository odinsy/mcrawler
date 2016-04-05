require 'pp'
require 'optparse'
require 'pmap'
require 'csv'

require File.expand_path('../lib/seo_params.rb', __FILE__)

options = {}
OptionParser.new do |opt|
  opt.on('-i', '--input_file FILE_PATH', 'Input file') { |o| options[:input_file] = o}
  opt.on('-o', '--output_file FILE_PATH', 'Output file') { |o| options[:output_file] = o}
  opt.on('-n', '--host_names "HOSTS"', 'Array with hosts names') { |o| options[:host_names] = o.split(' ')}
  opt.on('-p', '--proxy IPADDR:PORT', 'Proxy') { |o| options[:proxy] = o}
end.parse!


if !options[:output_file].nil? && File.exist?(options[:output_file])
  File.delete(options[:output_file])
end

if !options[:input_file].nil? && File.exist?(options[:input_file])
  File.readlines(options[:input_file]).peach(3) do |url|
    url = url.strip
    if !url.empty?
      output = SeoParams.new(url, options[:proxy]).all
      unless options[:output_file].nil?
        CSV.open(options[:output_file], 'a+', col_sep: '|', headers: output.keys) do |file|
          file << output.values
        end
        # File.open(options[:output_file], 'a') do |f|
        #   f.puts output.join(', ')
        # end
      else
        if output.class == Array
          p output.join(', ')
        else
          p output
        end
      end
    end
  end
else
  if !options[:host_names].nil?
    options[:host_names].each do |url|
      if !url.empty?
        output = SeoParams.new(url, options[:proxy]).all
        if !options[:output_file].nil?
          File.open(options[:output_file], 'a') do |f|
            f.puts output.join(', ')
          end
        else
          if output.class == Array
            p output.join(', ')
          else
            p output
          end
        end
      end
    end
  else
    error_handler("Не были указаны url'ы")
    exit
  end
end


def error_handler(error)
  File.open('errors', 'a') do |f|
    f.puts("#{DateTime.now}: #{error}")
  end
end

#!/usr/bin/env jruby

require 'optparse'
require 'java'
require '~/opt/opennlp/lib/opennlp-tools-1.5.3.jar'

java_import java.io.FileInputStream
java_import Java::opennlp.tools.tokenize.TokenizerME
java_import Java::opennlp.tools.tokenize.TokenizerModel
java_import Java::opennlp.tools.namefind.TokenNameFinderModel
java_import Java::opennlp.tools.namefind.NameFinderME
java_import Java::opennlp.tools.util.Span

tokenizer_model   = "en-token.bin"
name_finder_model = "en-ner-person.bin"

OptionParser.new do |opts|
  opts.banner = "Usage: extract.rb [options] file"

  opts.on("-t", "--tokenizer TOKENIZER", "Language tokenizer (default #{tokenizer_model})") do |l|
    tokenizer_model = l
  end

  opts.on("-f", "--finder FINDER", "Use specific name finder (default #{name_finder_model})") do |f|
    name_finder_model = f
  end

  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end

end.parse!

text = File.read(ARGV[0])

tokenizer = TokenizerME.new(TokenizerModel.new(FileInputStream.new(tokenizer_model)))
tokens = tokenizer.tokenize(text)
puts "Found #{tokens.length} token(s)"

nameFinder = NameFinderME.new(TokenNameFinderModel.new(FileInputStream.new(name_finder_model)))
spans = nameFinder.find(tokens) # opennlp.tools.util.Span
puts "Found #{spans.length()} name(s)"
spans.each { |s|
  print "#{s.getType()}> "
  for i in s.getStart()...s.getEnd() do
    print "#{tokens[i]} "
  end
  puts
}

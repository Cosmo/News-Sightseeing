#!/usr/bin/env jruby

require 'java'
require '~/opt/opennlp/lib/opennlp-tools-1.5.3.jar'

java_import java.io.FileInputStream
java_import Java::opennlp.tools.tokenize.TokenizerME
java_import Java::opennlp.tools.tokenize.TokenizerModel
java_import Java::opennlp.tools.namefind.TokenNameFinderModel
java_import Java::opennlp.tools.namefind.NameFinderME
java_import Java::opennlp.tools.util.Span

text = File.read("Pierre_Vinken.txt")

tokenizer = TokenizerME.new(TokenizerModel.new(FileInputStream.new("en-token.bin")))
tokens = tokenizer.tokenize(text)
puts "Found #{tokens.length} token(s)"

nameFinder = NameFinderME.new(TokenNameFinderModel.new(FileInputStream.new("en-ner-person.bin")))
spans = nameFinder.find(tokens) # opennlp.tools.util.Span
puts "Found #{spans.length()} persons(s)"
spans.each { |s|
  print "#{s.getType()}> "
  for i in s.getStart()...s.getEnd() do
    print "#{tokens[i]} "
  end
  puts
}

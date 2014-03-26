#!/usr/bin/env jruby

require 'java'
require '/Users/kai/opt/opennlp/lib/opennlp-tools-1.5.3.jar'

java_import java.io.FileInputStream
java_import Java::opennlp.tools.namefind.TokenNameFinderModel
java_import Java::opennlp.tools.namefind.NameFinderME
java_import Java::opennlp.tools.util.Span

# Download from http://opennlp.sourceforge.net/models-1.5/
modelIn = FileInputStream.new("en-ner-person.bin")
model = TokenNameFinderModel.new(modelIn)
nameFinder = NameFinderME.new(model)
sentence = ["Pierre", "Vinken", "is", "61", "years", "old", "."]
#opennlp.tools.util.Span
spans = nameFinder.find(sentence.to_java(:string))
puts "Found #{spans.length()} persons(s)"
spans.each { |s|
  print "#{s.getType()}> "
  for i in s.getStart()...s.getEnd() do
    print "#{sentence[i]} "
  end
  puts
}

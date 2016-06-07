#!/usr/bin/env ruby

require "../lib/glosbe"

ARGF.each_line do |line|
  word = line.chomp

  begin
    definition = Glosbe.definition(word).join(", ")
    phrase, phrase_translated = *Glosbe.phrase(word)

    puts "#{definition}~#{word}~#{phrase}~#{phrase_translated}"
  rescue
  end
end

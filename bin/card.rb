#!/usr/bin/env ruby

require "../lib/glosbe"

def get_definitions(definitions)
  final_definitions = []

  warn "Definitions: Y[es]/n[o]/d[one]"
  definitions.each do |definition|
    warn definition
    case gets.chomp
    when /\An/i then next
    when /\Ad/i then break
    else final_definitions << definition
    end
  end

  final_definitions
end

def get_phrase(phrases)
  warn "Phrase: Y[es]/n[o]/c[ustom]"
  if !phrases || phrases == []
    phrases = [""]
  end
  loop do
    phrases.each do |phrase|
      warn phrase[0]
      warn phrase[1]
      case gets.chomp
      when /\An/i then next
      when /\Ac/i then return [gets.chomp, gets.chomp]
      else return phrase
      end
    end
  end
end

ARGF.each_line do |line|
  word = line.chomp

  parsed_word = word.sub(/\Ala |le |l'|un |une |les |des |de la |du |de l'/, '')
  parsed_word = parsed_word.sub(/ -\w+\Z/, '')

  begin
    warn "#{word} (#{parsed_word})"
    definitions = get_definitions(Glosbe.definitions(parsed_word)).join(", ")
    phrase = get_phrase(Glosbe.phrases(parsed_word))

    puts "#{definitions}~#{word}~#{phrase[0]}~#{phrase[1]}"
  rescue => e
    warn e
  end
end

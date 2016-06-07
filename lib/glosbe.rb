#!/usr/bin/env ruby

require 'uri'
require 'net/http'
require 'json'

module Glosbe
  BASE_URL = "https://glosbe.com/gapi_v0_1"
  TRANSLATE_URL = "#{BASE_URL}/translate"
  PHRASE_URL = "#{BASE_URL}/tm"

  DEFAULT_ARGS = {
    from: "fra",
    dest: "eng",
    format: "json"
  }

  def self.definition(word)
    self.parse_definition(self.request(TRANSLATE_URL, phrase: word))
  end

  def self.phrase(word)
    self.parse_phrase(self.request(PHRASE_URL, phrase: word))
  end

  private

  def self.request(url, **args)
    Net::HTTP.get_response(URI.parse("#{url}?#{URI.encode_www_form(DEFAULT_ARGS.merge(args))}"))
  end

  def self.parse_definition(response)
    JSON.parse(response.body)["tuc"].map do |f|
      f["phrase"] && f["phrase"]["text"]
    end.compact.first(3)
  end

  def self.parse_phrase(response)
    hash = JSON.parse(response.body)["examples"].min_by { |f| f["first"].length }
    [ hash["first"], hash["second"] ]
  end
end

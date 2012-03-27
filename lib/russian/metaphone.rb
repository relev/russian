# -*- encoding: utf-8 -*-

module Russian
  # Metaphone code generation for english words and metaphon-like code for russian titles
  #
  # Генерация метафон-кодов для английский слов и русских названий
  # (русская версия заточена и будет дальше дорабатываться именно
  # в эту сторону - названия и заголовки)
  module Metaphone
    extend self

    require "active_support/core_ext/string"

    TRANSFORMATIONS_EN = [
      [/\A[gkp]n/       ,  'n'],   # gn, kn, or pn at the start turns into 'n'
      [/\Ax/            ,  's'],   # x at the start turns into 's'
      [/\Awh/           ,  'w'],   # wh at the start turns into 'w'
      [/mb\z/           ,  'm'],   # mb at the end turns into 'm'
      [/sch/            ,  'sk'],  # sch sounds like 'sk'
      [/x/              ,  'ks'],
      [/cia/            ,  'xia'], # the 'c' -cia- and -ch- sounds like 'x'
      [/ch/             ,  'xh'],
      [/c([iey])/       ,  's\1'], # the 'c' -ce-, -ci-, or -cy- sounds like 's'
      [/ck/             ,  'k'],
      [/c/              ,  'k'],
      [/dg([eiy])/      ,  'j\1'], # the 'dg' in -dge-, -dgi-, or -dgy- sounds like 'j'
      [/d/              ,  't'],
      [/gh/             ,  ''],
      [/gned/           ,  'ned'],
      [/gn((?![aeiou])|(\z))/ ,  'n'],
      [/g[eiy]/         ,  'j'],
      [/ph/             ,  'f'],
      [/[aeiou]h(?![aeoiu])/ ,  '\1'], # 'h' is silent after a vowel unless it's between vowels
      [/q/              ,  'k'],
      [/s(h|(ia)|(io))/ ,  'x\1'],
      [/t((ia)|(io))/   ,  'x\1'],
      [/th/             ,  '0'],
      [/v/              ,  'f'],
      [/w(?![aeiou])/   ,  ''],
      [/y(?![aeiou])/   ,  ''],
      [/z/              ,  's']
    ]

    # english metaphone code was inspired by
    # author: AndyV  http://snippets.dzone.com/user/AndyV
    # source: http://snippets.dzone.com/posts/show/4112
    def generate_en(aWord)
      word = aWord.downcase
      TRANSFORMATIONS_EN.each { |transform| word.gsub!(transform[0], transform[1]) }
      word.squeeze
      return (word[0].chr + word[1..word.length-1].gsub(/[aeiou]/, '')).upcase
    end

    TRANSFORMATIONS_RU = [
      [ /[дт]с/,'ц' ],        # seems this improves matching
      [ /[аяоёуюыиэе]/, '' ], # remove vowels
      [ /[йъь]/, '' ],        # these also ; this also removes all adjactive endings (-ый, -ая, -ое, ...)
#      [ /[лмн]/, 'л' ],       # seems this improves matching
#      [ /ч/, 'ц' ],           # this also
      [ /сч/,'ш' ],           # this also
      [ /б/, 'п' ],           # map pair letters
      [ /в/, 'ф' ],
      [ /г/, 'к' ],
      [ /д/, 'т' ],
      [ /ж/, 'ш' ],
      [ /з/, 'с' ],
      [ /щ/, 'ш' ],
    ]

    def generate_ru(aWord)
      word = aWord.mb_chars.downcase.squeeze
      TRANSFORMATIONS_RU.each { |transform| word.gsub!(transform[0], transform[1]) }
      word.squeeze
    end

    # Generates a metaphone code for the given string
    #
    # Генерирует метафон-код заданной строки (в т.ч. русской, в т.ч. рус+eng)
    def generate(str)
      str.split(/\s+/).map do |s|
        s =~ /[A-Za-z]/ ? generate_en(s =~ /[^A-Za-z]/ ? Russian.translit(s) : s) : generate_ru(s)
      end .join(' ').gsub(/\s+/,' ').mb_chars.upcase
    end

  end
end
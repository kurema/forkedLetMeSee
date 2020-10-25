#!/usr/bin/env ruby
#!/usr/local/bin/ruby -Ke
#
#
#
#
#

RDIC_VERSION = "0.1.5 (20031126)"

module Stem
  extend self

  IRREGULAR_VERB_LIST = {
    "arisen" => "arise", "arose" => "arise", "arise" => "arise", 
    "awoken" => "awake", "awakened" => "awake", "awoke" => "awake", "awake" => "awake", 
    "been" => "be", "were" => "be", "was" => "be", "be" => "be", 
    "borne" => "bear", "born" => "bear", "bore" => "bear", "bear" => "bear", 
    "beat" => "beat", "beaten" => "beat", 
    "become" => "become", "became" => "become", 
    "befallen" => "befall", "befell" => "befall", "befall" => "befall", 
    "begun" => "begin", "began" => "begin", "begin" => "begin", 
    "beheld" => "behold", "behold" => "behold", 
    "bent" => "bend", "bend" => "bend", 
    "betted" => "bet", "bet" => "bet", 
    "bid" => "bid", 
    "bound" => "bind", "bind" => "bind", 
    "bitten" => "bite", "bit" => "bite", "bite" => "bite", 
    "bled" => "bleed", "bleed" => "bleed", 
    "blown" => "blow", "blew" => "blow", "blow" => "blow", 
    "broken" => "break", "broke" => "break", "break" => "break", 
    "bred" => "breed", "breed" => "breed", 
    "brought" => "bring", "bring" => "bring", 
    "broadcast" => "broadcast", 
    "browbeat" => "browbeat", 
    "built" => "build", "build" => "build", 
    "burntburned" => "burn", "burned" => "burn", "burnt" => "burn", "burn" => "burn", 
    "burst" => "burst", 
    "bust" => "bust", "busted" => "bust", 
    "bought" => "buy", "buy" => "buy", 
    "cast" => "cast", 
    "caught" => "catch", "catch" => "catch", 
    "chosen" => "choose", "chose" => "choose", "choose" => "choose", 
    "clung" => "cling", "cling" => "cling", 
    "come" => "come", "came" => "come", 
    "cost" => "cost", 
    "crept" => "creep", "creep" => "creep", 
    "cut" => "cut", 
    "dealt" => "deal", "deal" => "deal", 
    "dug" => "dig", "dig" => "dig", 
    "dived" => "dive", "dive" => "dive", 
    "dove" => "dive", 
    "done" => "do", "did" => "do", "do" => "do", 
    "drawn" => "draw", "drew" => "draw", "draw" => "draw", 
    "dreamed" => "dream", "dreamt" => "dream", "dream" => "dream", 
    "drunk" => "drink", "drank" => "drink", "drink" => "drink", 
    "driven" => "drive", "drove" => "drive", "drive" => "drive", 
    "dwelled" => "dwell", "dwelt" => "dwell", "dwell" => "dwell", 
    "eaten" => "eat", "ate" => "eat", "eat" => "eat", 
    "fallen" => "fall", "fell" => "fall", "fall" => "fall", 
    "fed" => "feed", "feed" => "feed", 
    "felt" => "feel", "feel" => "feel", 
    "fought" => "fight", "fight" => "fight", 
    "found" => "find", "find" => "find", 
    "fit" => "fit", 
    "fitted" => "fit", 
    "fled" => "flee", "flee" => "flee", 
    "flung" => "fling", "fling" => "fling", 
    "flown" => "fly", "flew" => "fly", "fly" => "fly", 
    "forbidden" => "forbid", "forbade" => "forbid", "forbid" => "forbid", 
    "forecast" => "forecast", 
    "foregone" => "forego", "forewent" => "forego", "forego" => "forego", 
    "foreseen" => "foresee", "foresaw" => "foresee", "foresee" => "foresee", 
    "foretold" => "foretell", "foretell" => "foretell", 
    "forgotten" => "forget", "forgot" => "forget", "forget" => "forget", 
    "forgiven" => "forgive", "forgave" => "forgive", "forgive" => "forgive", 
    "forsaken" => "forsake", "forsook" => "forsake", "forsake" => "forsake", 
    "frozen" => "freeze", "froze" => "freeze", "freeze" => "freeze", 
    "got" => "get", "gotten" => "get", "get" => "get", 
    "given" => "give", "gave" => "give", "give" => "give", 
    "gone" => "go", "went" => "go", "go" => "go", 
    "ground" => "grind", "grind" => "grind", 
    "grown" => "grow", "grew" => "grow", "grow" => "grow", 
    "hung" => "hang", "hang" => "hang", 
    "had" => "have", "have" => "have", 
    "heard" => "hear", "hear" => "hear", 
    "hidden" => "hide", "hid" => "hide", "hide" => "hide", 
    "hit" => "hit", 
    "held" => "hold", "hold" => "hold", 
    "hurt" => "hurt", 
    "input" => "input", 
    "inset" => "inset", 
    "interbreda" => "interbreed", "interbreed" => "interbreed", 
    "interwoven" => "interweave", "interwove" => "interweave", "interweave" => "interweave", 
    "kept" => "keep", "keep" => "keep", 
    "kneeled" => "kneel", "knelt" => "kneel", "kneel" => "kneel", 
    "knitted" => "knit", "knit" => "knit", 
    "known" => "know", "knew" => "know", "know" => "know", 
    "laid" => "lay", "lay" => "lay", 
    "led" => "lead", "lead" => "lead", 
    "leant" => "lean", "leaned" => "lean", "lean" => "lean", 
    "leaped" => "leap", "leapt" => "leap", "leap" => "leap", 
    "learnt" => "learn", "learned" => "learn", "learn" => "learn", 
    "left" => "leave", "leave" => "leave", 
    "lent" => "lend", "lend" => "lend", 
    "let" => "let", 
    "lain" => "lie", "lie" => "lie", 
    "lighted" => "light", "lit" => "light", "light" => "light", 
    "lost" => "lose", "lose" => "lose", 
    "made" => "make", "make" => "make", 
    "meant" => "mean", "mean" => "mean", 
    "met" => "meet", "meet" => "meet", 
    "misheard" => "mishear", "mishear" => "mishear", 
    "mislaid" => "mislay", "mislay" => "mislay", 
    "misled" => "mislead", "mislead" => "mislead", 
    "misread" => "misread", 
    "misspelt" => "misspell", "misspelled" => "misspell", "misspell" => "misspell", 
    "mistaken" => "mistake", "mistook" => "mistake", "mistake" => "mistake", 
    "misunderstood" => "misunderstand", "misunderstand" => "misunderstand", 
    "mow" => "mow", "mowed" => "mow", 
    "outbid" => "outbid", 
    "outdone" => "outdo", "outdid" => "outdo", "outdo" => "outdo", 
    "outgrown" => "outgrow", "outgrew" => "outgrow", "outgrow" => "outgrow", 
    "outrun" => "outrun", "outran" => "outrun", 
    "outsold" => "outsell", "outsell" => "outsell", 
    "overcast" => "overcast", 
    "overcome" => "overcome", "overcame" => "overcome", 
    "overdone" => "overdo", "overdid" => "overdo", "overdo" => "overdo", 
    "overdrawn" => "overdraw", "overdrew" => "overdraw", "overdraw" => "overdraw", 
    "overeaten" => "overeat", "overate" => "overeat", "overeat" => "overeat", 
    "overhung" => "overhang", "overhang" => "overhang", 
    "overheard" => "overhear", "overhear" => "overhear", 
    "overlaid" => "overlay", "overlay" => "overlay", 
    "overlain" => "overlie", "overlie" => "overlie", 
    "overpaid" => "overpay", "overpay" => "overpay", 
    "overridden" => "override", "overrode" => "override", "override" => "override", 
    "overrun" => "overrun", "overran" => "overrun", 
    "overseen" => "oversee", "oversaw" => "oversee", "oversee" => "oversee", 
    "oversold" => "oversell", "oversell" => "oversell", 
    "overshot" => "overshoot", "overshoot" => "overshoot", 
    "overslept" => "oversleep", "oversleep" => "oversleep", 
    "overtaken" => "overtake", "overtook" => "overtake", "overtake" => "overtake", 
    "overthrown" => "overthrow", "overthrew" => "overthrow", "overthrow" => "overthrow", 
    "partaken" => "partake", "partook" => "partake", "partake" => "partake", 
    "paid" => "pay", "pay" => "pay", 
    "pleaded" => "plead", "pled" => "plead", "plead" => "plead", 
    "pre-set" => "pre-set", 
    "proofread" => "proofread", 
    "proved" => "prove", "proven" => "prove", "prove" => "prove", 
    "put" => "put", 
    "quitted" => "quit", "quit" => "quit", 
    "read" => "read", 
    "rebound" => "rebind", "rebind" => "rebind", 
    "rebuilt" => "rebuild", "rebuild" => "rebuild", 
    "recast" => "recast", 
    "redone" => "redo", "redid" => "redo", "redo" => "redo", 
    "re-laid" => "re-lay", "re-lay" => "re-lay", 
    "remade" => "remake", "remake" => "remake", 
    "repaid" => "repay", "repay" => "repay", 
    "rerun" => "rerun", "reran" => "rerun", 
    "resold" => "resell", "resell" => "resell", 
    "reset" => "reset", 
    "rethought" => "rethink", "rethink" => "rethink", 
    "rewound" => "rewind", "rewind" => "rewind", 
    "rewritten" => "rewrite", "rewrote" => "rewrite", "rewrite" => "rewrite", 
    "rid" => "rid", 
    "ridden" => "ride", "rode" => "ride", "ride" => "ride", 
    "rung" => "ring", "rang" => "ring", "ring" => "ring", 
    "risen" => "rise", "rose" => "rise", "rise" => "rise", 
    "run" => "run", "ran" => "run", 
    "said" => "say", "say" => "say", 
    "seen" => "see", "saw" => "see", "see" => "see", 
    "sought" => "seek", "seek" => "seek", 
    "sold" => "sell", "sell" => "sell", 
    "sent" => "send", "send" => "send", 
    "set" => "set", 
    "sewed" => "sew", "sewn" => "sew", "sew" => "sew", 
    "shaken" => "shake", "shook" => "shake", "shake" => "shake", 
    "sheared" => "shear", "shorn" => "shear", "shear" => "shear", 
    "shed" => "shed", 
    "shone" => "shine", "shined" => "shine", "shine" => "shine", 
    "shat" => "shit", "shit" => "shit", 
    "shot" => "shoot", "shoot" => "shoot", 
    "showed" => "show", "shown" => "show", "show" => "show", 
    "shrunk" => "shrink", "shrank" => "shrink", "shrink" => "shrink", 
    "shut" => "shut", 
    "sung" => "sing", "sang" => "sing", "sing" => "sing", 
    "sat" => "sit", "sit" => "sit", 
    "slain" => "slay", "slew" => "slay", "slay" => "slay", 
    "slept" => "sleep", "sleep" => "sleep", 
    "slid" => "slide", "slide" => "slide", 
    "slung" => "sling", "sling" => "sling", 
    "slit" => "slit", 
    "smelt" => "smell", "smelled" => "smell", "smell" => "smell", 
    "spoken" => "speak", "spoke" => "speak", "speak" => "speak", 
    "speeded" => "speed", "sped" => "speed", "speed" => "speed", 
    "spelt" => "spell", "spelled" => "spell", "spell" => "spell", 
    "spent" => "spend", "spend" => "spend", 
    "spun" => "spin", "spin" => "spin", 
    "spat" => "spit", "spit" => "spit", 
    "split" => "split", 
    "spoilt" => "spoil", "spoiled" => "spoil", "spoil" => "spoil", 
    "spoon-fed" => "spoon-feed", "spoon-feed" => "spoon-feed", 
    "spread" => "spread", 
    "sprung" => "spring", "sprang" => "spring", "spring" => "spring", 
    "stood" => "stand", "stand" => "stand", 
    "stolen" => "steal", "stole" => "steal", "steal" => "steal", 
    "stuck" => "stick", "stick" => "stick", 
    "stung" => "sting", "sting" => "sting", 
    "stunk" => "stink", "stank" => "stink", "stink" => "stink", 
    "strewed" => "strew", "strewn" => "strew", "strew" => "strew", 
    "stridden" => "stride", "strode" => "stride", "stride" => "stride", 
    "striven" => "strive", "strove" => "strive", "strive" => "strive", 
    "stricken" => "strike", "struck" => "strike", "strike" => "strike", 
    "strung" => "string", "string" => "string", 
    "strived" => "strive", 
    "sworn" => "swear", "swore" => "swear", "swear" => "swear", 
    "swept" => "sweep", "sweep" => "sweep", 
    "swelled" => "swell", "swollen" => "swell", "swell" => "swell", 
    "swum" => "swim", "swam" => "swim", "swim" => "swim", 
    "swung" => "swing", "swing" => "swing", 
    "taken" => "take", "took" => "take", "take" => "take", 
    "taught" => "teach", "teach" => "teach", 
    "torn" => "tear", "tore" => "tear", "tear" => "tear", 
    "told" => "tell", "tell" => "tell", 
    "thought" => "think", "think" => "think", 
    "thrown" => "throw", "threw" => "throw", "throw" => "throw", 
    "thrust" => "thrust", 
    "trod" => "tread", "trodden" => "tread", "tread" => "tread", 
    "unbound" => "unbind", "unbind" => "unbind", 
    "underlain" => "underlie", "underlay" => "underlie", "underlie" => "underlie", 
    "understood" => "understand", "understand" => "understand", 
    "undertaken" => "undertake", "undertook" => "undertake", "undertake" => "undertake", 
    "underwritten" => "underwrite", "underwrote" => "underwrite", "underwrite" => "underwrite", 
    "undone" => "undo", "undid" => "undo", "undo" => "undo", 
    "unwound" => "unwind", "unwind" => "unwind", 
    "upheld" => "uphold", "uphold" => "uphold", 
    "upset" => "upset", 
    "waked" => "wake", "woken" => "wake", "woke" => "wake", "wake" => "wake", 
    "worn" => "wear", "wore" => "wear", "wear" => "wear", 
    "woven" => "weave", "wove" => "weave", "weave" => "weave", 
    "wedded" => "wed", "wed" => "wed", 
    "wept" => "weep", "weep" => "weep", 
    "wetted" => "wet", "wet" => "wet", 
    "won" => "win", "win" => "win", 
    "wound" => "wind", "wind" => "wind", 
    "withdrawn" => "withdraw", "withdrew" => "withdraw", "withdraw" => "withdraw", 
    "wrung" => "wring", "wring" => "wring", 
    "written" => "write", "wrote" => "write", "write" => "write",

    "has" => "have", "haven't" => "have", "hasn't" => "have", "hadn't" => "have",
    "is" => "be", "are" => "be", "am" => "be", "isn't" => "be", "aren't" => "be", "wasn't" => "be", "weren't" => "be",
    "does" => "do", "doesn't" => "do", "didn't" => "do", "don't" => "do",
    "may" => "may", "might" => "may", "mayn't" => "may", "mightn't" => "may",
    "can" => "can", "could" => "can", "can't" => "can", "couldn't" => "can",
    "will" => "will", "would" => "will", "won't" => "will", "wouldn't" => "will",
    "must" => "must", "mustn't" => "must",

    "good" => "good", "better" => "good", "best" => "good",
    "bad" => "bad", "worse" => "bad", "worst" => "bad",
    "little" => "little", "less" => "little", "least" => "little",
    # "many" => "many", "more" => "many", "moat" => "many",
    # "much" => "much", "more" => "much", "most" => "much",
    "far" => "far", "further" => "far", "furthest" => "far",
    "farther" => "far", "farthest" => "far",
    "old" => "old", "elder" => "old", "eldest" => "old",
    "older" => "older", "oldest" => "old",
    
    "a" => "a", "an" => "a",

    # "i" => "one", "you" => "one", "he" => "one", "she" => "one", "it" => "one", "we" => "one", "they" => "one",
    # "me" => "one", "him" => "one", "us" => "one", "them" => "one",
    "my" => "one's", "your" => "one's", "his" => "one's", "her" => "one's", "its" => "one's", "our" => "one's", "their" => "one's", 
    "mine" => "one's", "yours" => "one's", "hers" => "one's", "ours" => "one's", "theirs" => "one's", 
    "myself" => "oneself", "yourself" => "oneself", "himself" => "oneself", "herself" => "oneself", "itself" => "oneself", "ourselves" => "oneself", "yourselves" => "oneself", "themselves" => "oneself", 
  }
  
  ELIMINATE_WORD_LIST = [
    "be", "been" ,
    "is" , "are" ,  "am" , "was", "were", "do" , "does", "did" ,
    "not", "isn't", "aren't", "wasn't", "weren't",  "don't", "doesn't", "didn't",
    "can" , "could", "can't", "couldn't",
    "will", "would" , "won't", "wouldn't", 
    "have", "has", "had" , "haven't", "hasn't", "hadn't",
    "must", "mustn't", 
    "shall", "should", "shouldn't",
    "an" , "a", "the",
    "i" , "one", "you" , "he" , "she" , "it" , "we" ,  "they" ,
    "my" , "one's", "your" , "his" , "her" , "its" , "our" , "their" ,  
    "me" , "him" , "us" , "them" , 
    "mine" , "yours" , "hers" , "ours" , "theirs" , 
    "this", "that", "these", "those", "there", 
    "myself" , "oneself", "yourself" , "himself" , "herself" , "itself" , "ourselves" , "yourselves" , "themselves", 
    "when", "who", "where", "what", "why", "whom", "how", "whose", "while",
    "and", "or", "nor", "so", "as", "then", "though", "but", "if", "because", "until", "til", "unless",
    "at", "by", "in", "on", "near", "to", "from", "down", "off", "through", "out", "past", "up", "of", "for", "with", "like",
    "about", "along", "below", "during", "above", "among", "across", "around", "beside", "inside", "after", "before", "between", "outside", "against", "behind", "beyond", "over", "under",
    "into", "upon", "without", "onto", "within"
  ]
  
  C = "[^aiueo]" # consonant
  V = "[aiueoy]" # vowel
  CC = "#{C}[^aiueoy]*"
  VV = "#{V}[aiueo]*"
  CV = "(#{CC})?#{V}"
  M = "^(#{CC})?#{VV}#{CC}"
  
  def stem_impl(word)
    return [word]     if word.length < 3 
    return [word]     unless word =~ /^[\w'-]+$/
    return [word, $`] if word =~ /'/n

    if word =~ /s$/n
      return [word, $`+$1]           if word =~ /(ss|sh)es$/n
      return [word, $`+'y', $`+$1]   if word =~ /(ie)s$/n
      return [word, $`+$1+$2, $`+$1] if word =~ /(s|z)(e)s$/n
      return [word, $`+$1, $`+$1+$2] if word =~ /(ch|x|o)(e)s$/n
      return [word, $`+$1]           if word =~ /([^s])s$/n
      return [word] 
    end

    if word =~ /(ed|ing)$/n
      stem = $`
      return [word, $`+'y', $`+$1] if word =~ /(ie)d$/n        
      if word =~ /eed$/n
	return [word,  word.chop]  if $` =~ /#{M}/o
      else
	if stem =~ /#{CV}/o
	  return [word, stem + 'e']                                         if stem =~ /(at|bl|v)$/n
	  return (stem.length > 3) ? [word, stem, stem.chop] : [word, stem] if stem =~ /(.)\1$/
	  return [word, stem, stem + 'e']                                   if stem =~ /#{C}#{C}$/o
	  return [word, stem + 'e', stem]
	end
      end
    end

    if word =~ /(er|est)$/n
      stem = $` # `
      return [word, $` + 'y', $`+$1] if word =~ /(ie)(r|st)$/n        
      if stem =~ /#{CV}/o
	return [word, stem + 'e']                                         if stem =~ /(at|bl|iz|nc|v)$/n 
	return (stem.length > 3) ? [word, stem, stem.chop] : [word, stem] if stem =~ /(.)\1$/
	return [word, stem, stem + 'e']                                   if stem =~ /#{C}#{C}$/o
	return [word, stem + 'e', stem]
      end
    end
    
    return [word]
  end
  
  def comb(n, m = n)
    if m == 0
      yield([])
    else
      comb(n, m - 1) do |x|
	((x.empty? ? 0 : x.last + 1)...n).each do |i|
	  yield(x+[i])
	end
      end
    end
  end

  def deploy_by_comb(array_of_word)
    pool_str = space = ''
    result = []
    i = j = array_of_word.size
    i.times do
      comb(i,j) do |x|
	pool_str = space = ''
	x.each do |y|
	  pool_str << space + array_of_word[y]
	  space = '\s+'
	end
	result.push(pool_str)
      end
      j -= 1
    end
    result
  end

  def stem(w)
    word = w.downcase
    if verb = IRREGULAR_VERB_LIST[word]
      return (word == verb) ? word : word + '|' + verb
    end
    result = or_notation = ''
    stem_impl(word).each do |x|
      result << or_notation + x
      or_notation = '|'
    end
    return result
  end

  def eliminate_word(word_array)
    word_array - ELIMINATE_WORD_LIST
  end

  def clear_eliminate_word
    ELIMINATE_WORD_LIST.clear
  end

  def add_eliminate_word(word)
    ELIMINATE_WORD_LIST.push(word) unless ELIMINATE_WORD_LIST.include?(word)
  end
  
  def eliminate_word_list
    ELIMINATE_WORD_LIST
  end

end

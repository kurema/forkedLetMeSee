# Copyright (C) 2002-2007  Kazuhiko <kazuhiko@fdiary.net>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#

#$KCODE = 'u'

require 'nkf'
require 'iconv'
require 'eb'
require 'cgi'
require './stem'
begin
	require 'erb_fast'
rescue LoadError
	begin
		require 'erb'
	rescue LoadError
		require 'erb/erbl'
		ERB = ERbLight
	end
end

LetMeSee_VERSION = '1.3.0'

# enhanced CGI class
class CGI
	def valid?( param, idx = 0 )
		begin
			self.params[param] and self.params[param][idx] and self.params[param][idx].length > 0
		rescue NameError # for Tempfile class of ruby 1.6
			self.params[param][idx].stat.size > 0
		end
	end
end

# let me see...
class LetMeSee
	attr_reader :dictlist, :dict, :query, :mode, :maxhit, :book
	attr_reader :section_anchor
	attr_reader :header, :footer, :index, :dicts
	attr_reader :num_columns, :ispell_command, :ispell_dict_list

	PATH = File::dirname( __FILE__ )

	IMG_STR = NKF::nkf('-We', '[画像]')
	AUDIO_STR = NKF::nkf('-We', '[音声]')
	VIDEO_STR = NKF::nkf('-We', '[動画]')

	def initialize( cgi, rhtml )
		@cgi, @rhtml = cgi, rhtml
		load_conf
		@query = (@cgi.params['query'][-1] || '')
		@ie = @cgi.params['ie'][0] || "UTF8"
		begin
			@query = Iconv.conv("utf-8", @ie, @query)
                rescue
			@query = NKF::nkf("-w -m0", @query)
		end
		@dict = @cgi.params['dict']
		@mode = @cgi.params['mode'][0] || 'search'
		@xml = @cgi.params['output'][0] == 'xml'
		@maxhit = (@cgi.params['maxhit'][0] || 10).to_i
		@book = @cgi.params['book'][0].to_i
		@decoration = []
		@dicts = []
		@dictlist.each do |item|
			if item.class == String
				dict = item
				appendix = nil
			else
				dict = item[0]
				appendix = item[1]
			end
			book=EB::Book.new
			book.bind(dict)
			0.upto(book.subbook_count-1) do |i|
				subbook=EB::Book.new
				subbook.bind(dict)
				if EB::RUBYEB_VERSION >= '2.5' && appendix
					subbook.appendix_path = appendix
				end
				subbook.set(i)
				@dicts.push subbook
			end
		end
		@dict = ("0"...@dicts.size.to_s).to_a if @dict.empty?
	end

	def html_output( str )
		r = str.gsub(/\\</, '<').gsub(/\\>/, '>').gsub(/\\"/, '"')
		r.gsub!(/<reference>(.+?)<\/reference (.+?)>/) { "<a href=\"#{@index}?mode=reference&amp;#{$2}\">#{$1}</a>" }
		r.gsub!(/<mono_graphic (.+?)>(.+?)<\/mono_graphic (.+?)>/) {"<img src=\"#{@index}?mode=mono_graphic&amp;#{$3}&amp;#{$1}\" alt=\"[画像]\">#{$2}" }
		return r
	end

	def eval_rhtml( )
		files = ["header.rhtml", @rhtml, "footer.rhtml"]
		rhtml = files.collect {|file|
			skel_dir = @xml ? "skelxml" : "skel2"
			path =  "#{PATH}/#{skel_dir}/#{file}"
			File::open( path , "r:utf-8" ) {|f| f.read }
		}.join
		r = ERB::new( rhtml.untaint, nil, 1 ).result( binding )
		r
	end

	def load_conf
		eval( File::open( "#{PATH}/letmesee.conf" ,"r:utf-8" ) { |f| f.read }.untaint )
		@num_columns = 3 unless @num_columns
		@ispell_command = "ispell" unless @ispell_command
		@ispell_dict_list = ['american'] unless @ispell_dict_list
		@fontsize = 16 unless @fontsize
		case @fontsize
		when 16
			@fontsize_n = 8; @fontsize_w = 16; @fontcode = EB::FONT_16
		when 24
			@fontsize_n = 12; @fontsize_w = 24; @fontcode = EB::FONT_24
		when 30
			@fontsize_n = 16; @fontsize_w = 32; @fontcode = EB::FONT_30
		when 48
			@fontsize_n = 24; @fontsize_w = 48; @fontcode = EB::FONT_48
		else
			@fontsize = 16; @fontsize_n = 8; @fontsize_w = 16; @fontcode = EB::FONT_16
		end
		@force_inline = false unless @force_inline
		@header = '' if !@header
		@footer = '' if !@footer
		@index = './' if !@index
		@theme = 'default' if !@theme && !@css
		@section_anchor = '' if !@section_anchor
	end

	def theme_url; 'theme'; end

	def css_tag
		if @theme and @theme.length > 0 then
			css = "#{theme_url}/#{@theme}/#{@theme}.css"
		else
			css = @css
		end
		<<-CSS
      <meta http-equiv="content-style-type" content="text/css">
      <link rel="stylesheet" href="#{css}" type="text/css" media="all">
		CSS
	end

	# スペル・チェック
	def spell_check (word, dict)
		begin
			result = nil
			IO.popen("#{@ispell_command} -a -m -C -d #{dict}", 'r+') do |io|
				io.write("#{Iconv.conv('iso-8859-1', 'utf-8', word)}\n")
				io.close_write()
				io.gets() # Ignore this header line.
				result = Iconv.conv('utf-8', 'iso-8859-1', io.read)
			end
			if $? == 0
				if /\A\+ (.*)/ =~ result
					root_word = $1
					return [root_word.downcase]
				elsif /\A\&[^:]*: (.*)/ =~ result
					words = $1
					return words.split(/[\n,]\s*/)
				end
			end
		rescue
		end
	end

        def convert_to_ascii(str)
		ret = str.gsub(/[À-ÖØ-Ýß-öø-ýÿ]/) do |s|
			case s
			when /[À-Å]/
				s = "A"
			when "Æ"
				s = "AE"
			when "Ç"
				s = "C"
			when /[È-Ë]/
				s = "E"
			when /[Ì-Ï]/
				s = "I"
			when "Ð"
				s = "D"
			when "Ñ"
				s = "N"
			when /[Ò-ÖØ]/
				s = "O"
			when /[Ù-Ü]/
				s = "U"
			when "Ý"
				s = "Y"
			when "ß"
				s = "ss"
			when /[à-å]/
				s = "a"
			when "æ"
				s = "ae"
			when "ç"
				s = "c"
			when /[è-ë]/
				s = "e"
			when /[ì-ï]/
				s = "i"
			when "ð"
				s = "d"
			when "ñ"
				s = "n"
			when /[ò-öø]/
				s = "o"
			when /[ù-ü]/
				s = "u"
			when "ý"
				s = "y"
			end
			s
		end
		return ret
        end

	# 検索 (完全一致/前方一致/後方一致/条件検索)
	def search ( book )
		b = @dicts[book]
		b.hookset = hookset(book)
		Stem::stem( NKF.nkf('-e', convert_to_ascii(@query)) ).split(/\|/).each do |i|
			if mode == 'keywordsearch'
				result = b.send(mode, i.split(/(\241\241|\s)/e), maxhit ).uniq
			else
				result = b.send(mode, i, maxhit ).uniq
			end
			return result if result.length > 0
		end
		return nil
        rescue RuntimeError
		return nil
	end

	# リファレンスの表示等
	def content (book)
		b = @dicts[book]
		b.hookset = hookset(book)
		page = @cgi.params['page'][0].to_i
		offset = @cgi.params['offset'][0].to_i
		return b.content(EB::Position.new(page, offset))
	end

	# メニュー
	def menu (book)
		b = @dicts[book]
		b.hookset = hookset(book)
		return b.menu if b.menu_available?
	end

	# 著作権表示
	def copyright (book)
		b = @dicts[book]
		b.hookset = hookset(book)
		return b.copyright if b.copyright_available?
	end

	# 全角外字の出力
	def gaiji_w
		code = @cgi.params['code'][0].to_i
		b = @dicts[@book]
                begin
                        b.fontcode = @fontcode
                rescue RuntimeError
                	# 適切な外字フォントがない場合は最小サイズにフォールバックします
                        b.fontcode = EB::FONT_16
                end
		print @cgi.header( {'type' => 'image/gif'} )
		print b.get_widefont(code).to_gif
	end

	# 半角外字の出力
	def gaiji_n
		code = @cgi.params['code'][0].to_i
		b = @dicts[@book]
                begin
                        b.fontcode = @fontcode
                rescue RuntimeError
                        b.fontcode = EB::FONT_16
                end
		print @cgi.header( {'type' => 'image/gif'} )
		print b.get_narrowfont(code).to_gif
	end

	# 画像の出力
	def mono_graphic
		b = @dicts[@book]
		page = @cgi.params['page'][0].to_i
		offset = @cgi.params['offset'][0].to_i
		width = @cgi.params['width'][0].to_i
		height = @cgi.params['height'][0].to_i
		pos = EB::Position.new(page, offset)
		print @cgi.header( {'type' => 'image/bmp'} )
		print b.read_monographic(pos, width, height) do |data|
			print data
		end
	end
	def bmp
		b = @dicts[@book]
		page = @cgi.params['page'][0].to_i
		offset = @cgi.params['offset'][0].to_i
		pos = EB::Position.new(page, offset)
		print @cgi.header( {'type' => 'image/bmp'} )
		b.read_colorgraphic(pos) do |data|
			print data
		end
	end
	def jpeg
		b = @dicts[@book]
		page = @cgi.params['page'][0].to_i
		offset = @cgi.params['offset'][0].to_i
		pos = EB::Position.new(page, offset)
		print @cgi.header( {'type' => 'image/jpeg'} )
		b.read_colorgraphic(pos) do |data|
			print data
		end
	end

	# 音声の出力
	def wave
		b = @dicts[@book]
		page = @cgi.params['page'][0].to_i
		offset = @cgi.params['offset'][0].to_i
		page2 = @cgi.params['page2'][0].to_i
		offset2 = @cgi.params['offset2'][0].to_i
		pos1 = EB::Position.new(page, offset)
		pos2 = EB::Position.new(page2, offset2)
		print @cgi.header( {'type' => 'audio/wav'} )
		b.read_wavedata(pos1, pos2) do |data|
			print data
		end
	end

	# 動画の出力
	def mpeg
		b = @dicts[@book]
		page = @cgi.params['page'][0].to_i
		offset = @cgi.params['offset'][0].to_i
		page2 = @cgi.params['page2'][0].to_i
		offset2 = @cgi.params['offset2'][0].to_i
		print @cgi.header( {'type' => 'video/mpeg'} )
		b.read_mpeg(page, offset, page2, offset2) do |data|
			print data
		end
	end

	# 各種フックの設定
	def hookset (book)
		h = EB::Hookset.new
		h.register(EB::HOOK_NEWLINE) do |eb2,argv|
			"\\<br /\\>\n"
		end
                h.register(EB::HOOK_WIDE_FONT) do |eb2,argv|
                        '\<img class=\"gaiji_wide\" src=\"' + @index + format('?book=%d;mode=gaiji_w;code=%d\" alt=\"_\" width=\"%d\" height=\"%d\" /\>',book, argv[0], @fontsize_w, @fontsize)
                end
                h.register(EB::HOOK_NARROW_FONT) do |eb2,argv|
                        '\<img class=\"gaiji_narrow\" src=\"' + @index + format('?book=%d;mode=gaiji_n;code=%d\" alt=\"_\" width=\"%d\" height=\"%d\" /\>',book, argv[0], @fontsize_n, @fontsize)
                end
		h.register(EB::HOOK_BEGIN_EMPHASIS) do |eb2,argv|
			'\<strong\>'
		end
		h.register(EB::HOOK_END_EMPHASIS) do |eb2,argv|
			'\</strong\>'
		end
		h.register(EB::HOOK_BEGIN_SUBSCRIPT) do |eb2,argv|
			'\<sub\>'
		end
		h.register(EB::HOOK_END_SUBSCRIPT) do |eb2,argv|
			'\</sub\>'
		end
		h.register(EB::HOOK_BEGIN_SUPERSCRIPT) do |eb2,argv|
			'\<sup\>'
		end
		h.register(EB::HOOK_END_SUPERSCRIPT) do |eb2,argv|
			'\</sup\>'
		end
		h.register(EB::HOOK_BEGIN_REFERENCE) do |eb2,argv|
			'\<span class=\"reference\"\>\<reference\>'
		end
		h.register(EB::HOOK_END_REFERENCE) do |eb2,argv|
			dictlist = ''
			self.dict.each do |dict|
				dictlist += ";dict=#{dict.to_i}"
			end
			format('\</reference book=%d;page=%d;offset=%d%s\>\</span\>',book, argv[1], argv[2], dictlist)
		end
		h.register(EB::HOOK_BEGIN_CANDIDATE) do |eb2,argv|
			'\<span class=\"reference\"\>\<reference\>'
		end
		h.register(EB::HOOK_END_CANDIDATE_GROUP) do |eb2,argv|
			dictlist = ''
			self.dict.each do |dict|
				dictlist += ";dict=#{dict.to_i}"
			end
			format('\</reference book=%d;page=%d;offset=%d%s\>\</span\>',book, argv[1], argv[2], dictlist)
		end
		h.register(EB::HOOK_BEGIN_MONO_GRAPHIC) do |eb2,argv|
			format('\<mono_graphic width=%d;height=%d\>', argv[3], argv[2])
		end
		h.register(EB::HOOK_END_MONO_GRAPHIC) do |eb2,argv|
			format('\</mono_graphic book=%d;page=%d;offset=%d\>',book, argv[1], argv[2])
		end
		h.register(EB::HOOK_BEGIN_COLOR_BMP) do |eb2,argv|
			if @force_inline
				%Q!\<img src=\"#{@index}?mode=bmp;book=#{book};page=#{argv[2]};offset=#{argv[3]}\" alt=\"#{IMG_STR}\" /\>!
			else
				%Q!\<a href=\"#{@index}?mode=bmp;book=#{book};page=#{argv[2]};offset=#{argv[3]}\">#{IMG_STR} !
			end
		end
		h.register(EB::HOOK_BEGIN_COLOR_JPEG) do |eb2,argv|
			if @force_inline
				%Q!\<img src=\"#{@index}?mode=jpeg;book=#{book};page=#{argv[2]};offset=#{argv[3]}\" alt=\"#{IMG_STR}\" /\>!
			else
				%Q!\<a href=\"#{@index}?mode=jpeg;book=#{book};page=#{argv[2]};offset=#{argv[3]}\">#{IMG_STR} !
			end
		end
		h.register(EB::HOOK_END_COLOR_GRAPHIC) do |eb2,argv|
			unless @force_inline
				'\</a\>'
			end
		end
		h.register(EB::HOOK_BEGIN_IN_COLOR_BMP) do |eb2,argv|
			%Q!\<img src=\"#{@index}?mode=bmp;book=#{book};page=#{argv[2]};offset=#{argv[3]}\" alt=\"#{IMG_STR}\" /\>!
		end if EB.const_defined?(:HOOK_BEGIN_IN_COLOR_BMP)
		h.register(EB::HOOK_BEGIN_IN_COLOR_JPEG) do |eb2,argv|
			%Q!\<img src=\"#{@index}?mode=jpeg;book=#{book};page=#{argv[2]};offset=#{argv[3]}\" alt=\"#{IMG_STR}\" /\>!
		end if EB.const_defined?(:HOOK_BEGIN_IN_COLOR_JPEG)
		h.register(EB::HOOK_BEGIN_WAVE) do |eb2,argv|
			%Q!\<a href=\"#{@index}?mode=wave;book=#{book};page=#{argv[2]};offset=#{argv[3]};page2=#{argv[4]};offset2=#{argv[5]}\">#{AUDIO_STR} !
		end
		h.register(EB::HOOK_END_WAVE) do |eb2,argv|
			'\</a\>'
		end
		h.register(EB::HOOK_BEGIN_MPEG) do |eb2,argv|
			%Q!\<a href=\"#{@index}?mode=mpeg;book=#{book};page=#{argv[2]};offset=#{argv[3]};page2=#{argv[4]};offset2=#{argv[5]}\">#{VIDEO_STR} !
		end
		h.register(EB::HOOK_END_MPEG) do |eb2,argv|
			'\</a\>'
		end
		if EB.const_defined?(:HOOK_BEGIN_DECORATION)
			h.register(EB::HOOK_BEGIN_DECORATION) do |eb2,argv|
				@decoration.push(argv[1])
				case argv[1]
				when 1
					'\<i\>'
				when 3
					'\<b\>'
				end
			end
			h.register(EB::HOOK_END_DECORATION) do |eb2,argv|
				case @decoration.pop
				when 1
					'\</i\>'
				when 3
					'\</b\>'
				end
			end
		end
		return h
	end

	def conv(str)
		NKF::nkf('-Ew -m0', str)
        end
end

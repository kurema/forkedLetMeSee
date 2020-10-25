#!/usr/bin/env ruby

def get_index()
        @path_cd = File::dirname( __FILE__ )
        @path =  "#{@path_cd}/skel2/index.html"
        File::open( @path , "r:utf-8" ) {|f| f.read }
end

begin
	require './letmesee.rb'
	@cgi = CGI.new
	is_index = false

	if @cgi.valid?( 'mode' ) then
		case @cgi.params['mode'][0]
			when 'menu', 'copyright'
			l = LetMeSee::new( @cgi, 'menu.rhtml' )
			when 'reference'
			l = LetMeSee::new( @cgi, 'reference.rhtml' )
			when 'search', 'exactsearch', 'endsearch', 'keywordsearch'
			l = LetMeSee::new( @cgi, 'search.rhtml' )
			when 'gaiji_w', 'gaiji_n', 'mono_graphic', 'bmp', 'jpeg', 'wave', 'mpeg'
			l = LetMeSee::new( @cgi, nil )
			l.send( l.mode )
			exit
			else			
#			l = LetMeSee::new( @cgi, 'help.rhtml' )
			is_index = true
		end
	elsif @cgi.valid?( 'query' ) then
		l = LetMeSee::new( @cgi, 'search.rhtml' )
	else
#		l = LetMeSee::new( @cgi, 'help.rhtml' )
		is_index = true
	end

	head = {
		'type' => 'text/html',
		'Vary' => 'User-Agent',
		'charset' => 'UTF-8'
	}
	body = is_index && @cgi.params['output'][0] != 'xml' ? get_index() : l.eval_rhtml
	#body = l.eval_rhtml
	head['Content-Length'] = body.size.to_s
	head['Pragma'] = 'no-cache'
	head['Cache-Control'] = 'no-cache'
	print @cgi.header( head )
	print body
rescue SystemExit
	# normal exit for binary data
rescue Exception
	print "Content-Type: text/plain\n\n"
	puts "#$! (#{$!.class})"
	puts ""
	puts $@.join( "\n" )
end


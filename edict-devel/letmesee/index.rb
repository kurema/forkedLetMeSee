#!/usr/bin/env ruby
begin
	require 'letmesee.rb'
	@cgi = CGI.new

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
			l = LetMeSee::new( @cgi, 'help.rhtml' )
		end
	elsif @cgi.valid?( 'query' ) then
		l = LetMeSee::new( @cgi, 'search.rhtml' )
	else
		l = LetMeSee::new( @cgi, 'help.rhtml' )
	end

	head = {
		'type' => 'text/html',
		'Vary' => 'User-Agent',
		'charset' => 'UTF-8'
	}
	body = l.eval_rhtml
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

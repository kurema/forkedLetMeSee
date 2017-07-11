NAME = letmesee
VERSION = `grep '^LetMeSee_VERSION' letmesee.rb | sed -e 's/.* //' -e "s/'//g"`

FILES =  AUTHORS ChangeLog COPYING INSTALL NEWS README TODO logo.png
FILES += letmesee.conf.sample dot.htaccess index.rb letmesee.rb
THEME_FILES = README default.css
SKEL_FILES =  footer.rhtml header.rhtml help.rhtml menu.rhtml reference.rhtml
SKEL_FILES += search.rhtml
ERB_FILES = compile.rb erbl.rb

dist: 
	rm -rf $(NAME)-$(VERSION) $(NAME)-$(VERSION).tar.gz
	mkdir $(NAME)-$(VERSION)
	for file in $(FILES); do \
		cp -p $$file $(NAME)-$(VERSION)/ || exit 1; \
	done
	mkdir -p $(NAME)-$(VERSION)/theme/default
	for file in $(THEME_FILES); do \
		cp -p theme/default/$$file $(NAME)-$(VERSION)/theme/default/ || exit 1; \
	done
	mkdir -p $(NAME)-$(VERSION)/skel
	for file in $(SKEL_FILES); do \
		cp -p skel/$$file $(NAME)-$(VERSION)/skel/ || exit 1; \
	done
	mkdir -p $(NAME)-$(VERSION)/erb
	for file in $(ERB_FILES); do \
		cp -p erb/$$file $(NAME)-$(VERSION)/erb/ || exit 1; \
	done
	tar cf - $(NAME)-$(VERSION)/ | \
		gzip -9 > $(NAME)-$(VERSION).tar.gz
	rm -rf $(NAME)-$(VERSION)

copy:
	scp -p $(NAME)-$(VERSION).tar.gz openlab.jp:edict/letmesee/dist/

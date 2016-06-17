SRC:=$(wildcard index.md 2014/*.md 2015/*.md 2016/*.md caffe-notes/*.md)
DST:=$(addprefix publish/, $(SRC:%.md=%.html))
CSS:=publish/github-markdown.css \
     publish/highlight.css \
     publish/lazyload.min.js \
     publish/jquery-3.0.0.min.js \
     publish/egg.min.js \
     publish/notes.js \
     publish/notes.css \
     publish/fork-me-on-github.png \

FROM := markdown+abbreviations
ifeq (,$(DUMB))
	FROM := $(FROM)+east_asian_line_breaks+emoji
endif

all: $(DST) $(CSS)
clean:
	rm -rf publish/*
gh:
	git add -A; git commit -m "`date`"; git push;

publish/index.html: index.md
	@mkdir -p $(@D)
	pandoc \
		-V ISINDEX=true \
		-S -s --ascii --mathjax \
		-f $(FROM) \
		--template meta/note.template \
		$< -o $@
publish/%/index.html: %/index.md
	@mkdir -p $(@D)
	pandoc \
		-V ISINDEX=true -V NOTBASE=true \
		-S -s --ascii --mathjax \
		-f $(FROM) \
		--template meta/note.template \
		$< -o $@
publish/%.html: %.md
	@mkdir -p $(@D)
	pandoc \
		-V NOTBASE=true \
		-S -s --ascii --mathjax \
		-f $(FROM) \
		--template meta/note.template \
		$< -o $@

publish/%: meta/%
	@mkdir -p $(@D)
	cp $< $@

note: n
n:
	$(EDITOR) index.md ./
m:
	$(EDITOR) Makefile

caffesync:
	@mkdir -p caffe-notes
	rsync ../caffe-notes/*.md caffe-notes/
caffereset:
	@rm -rf caffe-notes; 
	git submodule update --init --recursive
caffeupdate:
	cd caffe-notes; git pull origin master;
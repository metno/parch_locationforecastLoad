VERSION = 0.5.0

PROJECT = parch-util

SCRIPTS = parch_locationforecastLoad parch_stationlist parch_create_ncml_template
CONFIG_FILES = foreign_stations.txt
MAN_FILES = parch_locationforecastLoad.1 parch_stationlist.1 parch_create_ncml_template.1

BUILT_FILES = $(MAN_FILES)

bindir = /usr/bin
datarootdir = /usr/share/$(PROJECT)
sysconfdir = /etc/$(PROJECT)
mandir = /usr/share/man/man1


all:	$(BUILT_FILES)

install: all
	mkdir -p $(DESTDIR)$(sysconfdir)  && install -m644 -t$(DESTDIR)$(sysconfdir) $(CONFIG_FILES)
	mkdir -p $(DESTDIR)$(mandir)      && install -m644 -t$(DESTDIR)$(mandir) $(MAN_FILES)
	mkdir -p $(DESTDIR)$(bindir)      && install -t$(DESTDIR)$(bindir) $(SCRIPTS)


uninstall:
	@for F in $(MAN_FILES); do echo rm -f $(mandir)/$$F; done
	@for F in $(SCRIPTS); do echo rm -f $(bindir)/$$F; done
	@for F in $(CONFIG_FILES); do echo rm -f $(sysconfdir)/$$F; done

clean:
	rm -f $(BUILT_FILES)

distclean: clean

check:

installcheck: check

dist:	$(PROJECT)-$(VERSION).tar.gz

$(PROJECT)-$(VERSION).tar.gz: $(SCRIPTS) $(SQL_FILES) $(CONFIG_FILES) Makefile
	rm -rf $(PROJECT)-$(VERSION)
	mkdir $(PROJECT)-$(VERSION)
	cp $^ $(PROJECT)-$(VERSION)
	tar czf $@ $(PROJECT)-$(VERSION)
	rm -rf $(PROJECT)-$(VERSION)

debian: dist
	debuild -us -uc


.PHONY = all install uninstall clean distclean check installcheck dist


parch_locationforecastLoad.1: parch_locationforecastLoad
	help2man -n "Loads several locations from api.met.no/locationforecast into a wdb database" -N ./$< > $@

parch_stationlist.1:	parch_stationlist
	help2man -n "Obtain a list of stations to load into parch" -N ./$< > $@

parch_create_ncml_template.1: parch_create_ncml_template
	help2man -n "Generate a netcdf file for use with fimex' interpolate.template option" -N ./$< > $@
	
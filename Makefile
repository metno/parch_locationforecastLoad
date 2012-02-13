VERSION = 0.1.0

SCRIPTS = parch_locationforecastLoad
SQL_FILES = create_foreign_load_list.sql  create_norwegian_load_list.sql
CONFIG_FILES = foreign_stations.dat
MAN_FILES = parch_locationforecastLoad.1

BUILT_FILES = $(MAN_FILES)

bindir = /usr/bin
datarootdir = /usr/share/parch_locationforecastLoad
sysconfdir = /etc/parch_locationforecastLoad
mandir = /usr/share/man/man1


all:	$(BUILT_FILES)

install: all
	mkdir -p $(DESTDIR)$(sysconfdir)  && install -m644 -t$(DESTDIR)$(sysconfdir) $(CONFIG_FILES)
	mkdir -p $(DESTDIR)$(datarootdir) && install -m644 -t$(DESTDIR)$(datarootdir) $(SQL_FILES)
	mkdir -p $(DESTDIR)$(mandir)      && install -m644 -t$(DESTDIR)$(mandir) $(MAN_FILES)
	mkdir -p $(DESTDIR)$(bindir)      && install -t$(DESTDIR)$(bindir) $(SCRIPTS)


uninstall:
	@for F in $(MAN_FILES); do echo rm -f $(mandir)/$$F; done
	@for F in $(SCRIPTS); do echo rm -f $(bindir)/$$F; done
	@for F in $(SQL_FILES); do echo rm -f $(datarootdir)/$$F; done
	@for F in $(CONFIG_FILES); do echo rm -f $(sysconfdir)/$$F; done

clean:
	rm -f $(BUILT_FILES)

distclean: clean

check:

installcheck: check

dist:	parch-locationforecastload-$(VERSION).tar.gz

parch-locationforecastload-$(VERSION).tar.gz: $(SCRIPTS) $(SQL_FILES) $(CONFIG_FILES) Makefile
	rm -rf parch_locationforecastLoad-$(VERSION)
	mkdir parch_locationforecastLoad-$(VERSION)
	cp $^ parch_locationforecastLoad-$(VERSION)
	tar czf $@ parch_locationforecastLoad-$(VERSION)
	rm -rf parch_locationforecastLoad-$(VERSION)

debian: dist
	dpkg-buildpackage -i -us -uc -rfakeroot


.PHONY = all install uninstall clean distclean check installcheck dist


parch_locationforecastLoad.1: parch_locationforecastLoad
	help2man -n "Loads several locations from api.met.no/locationforecast into a wdb database" -N ./$< > $@
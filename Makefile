

include db.mk
LIGHTTPD_CONFIG_DIR=/etc/lighttpd/
LIGHTTPD_CONFIG=lighttpd.conf
PATCHESDIR=patches

all:compile preparemysql configurelighttpd

lighttpd:
	$(MAKE) -C build/ lighttpd

_diff:
	diff -u build/lighttpd-1.4.33/configure.ac build/lighttpd-1.4.33_patched/configure.ac > $(PATCHESDIR)/configure.ac.diff || exit 0
	diff -u build/lighttpd-1.4.33/src/Makefile.am build/lighttpd-1.4.33_patched/src/Makefile.am > $(PATCHESDIR)/Makefile.am.diff || exit 0

patch:lighttpd
	patch build/lighttpd-1.4.33/configure.ac < $(PATCHESDIR)/configure.ac.diff
	patch build/lighttpd-1.4.33/src/Makefile.am < $(PATCHESDIR)/Makefile.am.diff
	cp mod_mysql_accesslog.c build/lighttpd-1.4.33/src/


compile:patch installmissingpackages
	cd build/lighttpd-1.4.33/;./autogen.sh;./configure --with-mysql --prefix=/opt/lighttpd;make;make install
	
preparemysql:
	sed s/MYDBNAME/$(MYDBNAME)/g patches/db.sql | sed s/MYUSERNAME/$(MYUSERNAME)/g | sed s/MYPASSWORD/$(MYPASSWORD)/g > patches/.db.sql
	mysql -u $(MYUSERNAME) -p < patches/.db.sql

configurelighttpd:
	cp $(LIGHTTPD_CONFIG_DIR)/$(LIGHTTPD_CONFIG) lighttpd.original.conf
	sed s/mod_accesslog/mod_mysql_accesslog/g lighttpd.original.conf > $(LIGHTTPD_CONFIG_DIR)/$(LIGHTTPD_CONFIG)
	sed s/MYDBNAME/$(MYDBNAME)/g patches/1_mysql.conf | sed s/MYUSERNAME/$(MYUSERNAME)/g | sed s/MYPASSWORD/$(MYPASSWORD)/g > patches/.1_mysql.conf
	cp patches/.1_mysql.conf $(LIGHTTPD_CONFIG_DIR)/conf-enabled/1_mysql.conf
	service lighttpd stop
	pkill -KILL lighttpd || exit 0
	cp /etc/init.d/lighttpd lighttpd.init.script
	sed s:^DAEMON=.*:DAEMON=/opt/lighttpd/sbin/lighttpd: lighttpd.init.script > lighttpd.new.script
	cp lighttpd.new.script /etc/init.d/lighttpd
	service lighttpd start

installmissingpackages:
	apt-get update
	apt-get install libtool
	apt-get install pkg-config
	apt-get install libbz2-dev
	apt-get install libmariadbd-dev
	apt-get install libmariadbclient-dev


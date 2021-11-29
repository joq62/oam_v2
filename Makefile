all:
#	service
	rm -rf ebin *_ebin;
	rm -rf src/*.beam *.beam  test_src/*.beam test_ebin;
	rm -rf  *~ */*~  erl_cra*;
#	app
#	cp src/*.app ebin;
#	erlc -o ebin src/*.erl;
	echo Done
terminal:
	rm -rf ebin;
	mkdir ebin;
	erlc -o ebin ../common/src/*.erl;
	erlc -o ebin src/*.erl;
	erl -pa ebin -sname terminal -run oam start -setcookie cookie -hidden
unit_test:
	rm -rf ebin/* src/*.beam *.beam test_src/*.beam test_ebin;
	rm -rf  *~ */*~  erl_cra*;
	rm -rf host_configuration service.catalog;
	mkdir test_ebin;
	mkdir ebin;
#	service.catalog
	cp ../release/service_catalog/service.catalog .;
#	test configs
	mkdir host_configuration;
	cp ../infra/host/host_configuration/* host_configuration;
#	common
	erlc -D debug_flag -o ebin ../common/src/*.erl;
#	host
	cp ../infra/host/src/*.app ebin;
	erlc -D debug_flag -o ebin ../infra/host/src/*.erl;
#	sd
	cp ../infra/sd/src/*.app ebin;
	erlc -D debug_flag -o ebin ../infra/sd/src/*.erl;
#	bully
	cp ../infra/bully/src/*.app ebin;
	erlc -D debug_flag -o ebin ../infra/bully/src/*.erl;
#	dbase_infra
	cp ../infra/dbase_infra/src/*.app ebin;
	erlc -D debug_flag -o ebin ../infra/dbase_infra/src/*.erl;
#	app
	erlc -o ebin src/*.erl;
#	test application
	cp test_src/*.app test_ebin;
	erlc -o test_ebin test_src/*.erl;
	erl -pa ebin -pa test_ebin\
	    -setcookie cookie\
	    -sname oam\
	    -hidden\
	    -unit_test monitor_node production\
	    -unit_test cookie cookie\
	    -run unit_test start_test test_src/test.config

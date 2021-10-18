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
	mkdir test_ebin;
#	app
	cp src/*.app ebin;
	erlc -o ebin src/*.erl;
#	test application
	cp test_src/*.app test_ebin;
	erlc -o test_ebin test_src/*.erl;
	erl -pa ebin -pa test_ebin\
	    -setcookie production\
	    -sname production\
	    -hidden\
	    -unit_test monitor_node production\
	    -unit_test cluster_id production\
	    -unit_test cookie production\
	    -run unit_test start_test test_src/test.config

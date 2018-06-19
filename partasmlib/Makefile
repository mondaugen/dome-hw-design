sources=$(wildcard *.py)
sources+=$(wildcard test/*.py)

.res :
	mkdir .res

.res/libs : .res
	cp -r libs .res/libs

.res/circuit_test.scad : .res/libs $(sources)
	python test/circuittest.py > $@


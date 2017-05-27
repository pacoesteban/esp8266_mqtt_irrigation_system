#
# Makefile
# Paco Esteban, 2016-10-02 18:08
#

all:
	platformio -f -c vim run -s > /dev/null

upload:
	platformio -f -c vim run --target upload

clean:
	platformio -f -c vim run --target clean

program:
	platformio -f -c vim run --target program

uploadfs:
	platformio -f -c vim run --target uploadfs

update:
	platformio -f -c vim update

size:
	platformio -f -c vim run --target size


# vim:ft=make
#

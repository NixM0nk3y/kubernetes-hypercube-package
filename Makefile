bin:
	./build-deb.sh

clean:
	rm *.deb

.DEFAULT_GOAL := bin

install:
	docker build . -t tak0kada/python-docker-env
	chmod 755 ./dpython ./dipython
	mkdir -p ~/bin/
	mv ./dpython ~/bin/
	mv ./dipython ~/bin/

clean:
	docker image rm tak0kada/python-docker-env
	rm ~/bin/dpython
	rm ~/bin/dipython

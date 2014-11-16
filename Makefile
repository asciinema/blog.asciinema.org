all: build

build:
	hugo

server:
	hugo server --buildDrafts --watch

commit:
	git branch -D deploy
	git checkout -b deploy fresh-deploy
	cp -r public/* .
	git add .
	git commit -m 'Deploying'
	git checkout -

push:
	git push heroku deploy:master -f

deploy: build commit push

.PHONY: build server commit push deploy

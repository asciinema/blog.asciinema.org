all: build

build:
	bundle exec middleman build

commit:
	git branch -D deploy
	git checkout -b deploy fresh-deploy
	cp -r build/* .
	git add .
	git commit -m 'Deploying'
	git checkout -

push:
	git push heroku deploy:master -f

deploy: build commit push

.PHONY: build commit push deploy

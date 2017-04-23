checkout_deploy_branch:
	git checkout -B gh-pages

checkout_master_branch:
	git checkout master

elm_make:
	elm make Main.elm

commit:
	git add index.html && git commit -m "Update index.html"

push_remote:
	git push --force-with-lease origin gh-pages

deploy: checkout_deploy_branch elm_make commit push_remote checkout_master_branch

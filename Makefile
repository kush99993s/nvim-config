push_git:
	git add .
	git commit -m "pushed at $(shell date)"
	git push origin main

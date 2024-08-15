# Using .ONESHELL mostly for readability, and also because that's how I got it to work with windows. See https://www.gnu.org/software/make/manual/html_node/One-Shell.html
.ONESHELL:
BUILD-FOLDER = .\_build
ACTIVATE = @call conda activate phoenix-notebook


.PHONY: all clean build publish test make-environment

test: build
# after the build, open index.html with firefox
	@echo "Opening index.html in firefox"
	@start firefox .\_build\html\index.html

build: #clean
	$(ACTIVATE)
	@echo "Building book"
	jupyter-book build .
	@echo "Done"

clean:
	$(ACTIVATE)
	@echo "Removing old build"
	@jupyter-book clean .
	
environment:
	@echo "Creating mamba environment"
	@mamba env create -f environment-lock.yml
	@echo "Done"

mamba-update:
	$(ACTIVATE)
	@echo "Updating mamba environment"
	@call mamba env update -f environment.yml
# now saving the explicit environment to lockfile
	@echo "Saving environment to lockfile"
	@call mamba env export > environment-lock.yml
	@echo "Done"

commit:
	@git add -A
	@git commit
	@git push origin main
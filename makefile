# Using .ONESHELL mostly for readability, and also because that's how I got it to work with windows. See https://www.gnu.org/software/make/manual/html_node/One-Shell.html
.ONESHELL:
BUILD-FOLDER = .\_build
ACTIVATE = @call conda activate whoi-notebook


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
	@mamba env create -f environment.yml
	@echo "Done"

publish: build
# delete the _source folder in the _build directory using cmd
	@echo "Deleting _source folder"
	@rd / -q .\_build\html\_sources
# makes a cmd command which copies the html directory and copies it to the other shared drive
	@echo "Publishing book to OneDrive"
	@xcopy /E /I /Y .\_build\html "C:\Users\Jonathan\Woods Hole Oceanographic Institution\M365 Wang Lab Team - MARINE CHEMISTRY & GEOCHEMISTRY - Jonathan Lab Notebook - Jonathan Lab Notebook\html"
	@echo "Done with publishing"
	@git add -A
	@git commit
	@git push origin main


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
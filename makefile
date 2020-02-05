NAME=pashua-runner
NICE_NAME=Pashua Runner
NICE_NAME2=Pashua-Runner
SRC=$(CURDIR)/$(NAME).applescript
INFO_SRC=$(CURDIR)/Info.plist
#RES_SRC=$(CURDIR)/Resources/
BUILD=$(CURDIR)/build
APP_DST=$(BUILD)/$(NICE_NAME).app
APP_VER=$(shell defaults read "$(CURDIR)/Info.plist" "CFBundleVersion")
help:
	@echo "Targets: help, clean, build."
	@echo
	@echo "app_version: ${APP_VER}"
clean:
	@echo "Cleaning..."
	@if [[ -d "${BUILD}" ]]; then rm -Rf "${BUILD}"; fi
build: clean
	@echo "Building..."
	@if [[ ! -d "${BUILD}" ]]; then mkdir -p "${BUILD}"; fi
	@osacompile -x -o "${APP_DST}" "${SRC}"
	#@cp "${INFO_SRC}" "${APP_DST}/Contents"


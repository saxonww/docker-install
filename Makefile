SHELL:=/bin/bash
DISTROS:=centos-7 fedora-24 fedora-25 debian-wheezy debian-jessie debian-stretch ubuntu-trusty ubuntu-xenial ubuntu-yakkety ubuntu-zesty
VERIFY_INSTALL_DISTROS:=$(addprefix verify-install-,$(DISTROS))
CHANNEL_TO_TEST?=test
SHELLCHECK=shellcheck

.PHONY: shellcheck
shellcheck:
	$(SHELLCHECK) install.sh

.PHONY: check
check: $(VERIFY_INSTALL_DISTROS)

.PHONY: clean
clean:
	$(RM) verify-install-*

verify-install-%:
	mkdir -p build
	sed 's/DEFAULT_CHANNEL_VALUE="test"/DEFAULT_CHANNEL_VALUE="$(CHANNEL_TO_TEST)"/' install.sh > build/install.sh
	set -o pipefail && docker run \
		--rm \
		-v $(CURDIR):/v \
		-w /v \
		$(subst -,:,$*) \
		/v/verify-docker-install | tee $@

armhf-verify-install-raspbian-jessie:
	mkdir -p build
	sed 's/DEFAULT_CHANNEL_VALUE="test"/DEFAULT_CHANNEL_VALUE="$(CHANNEL_TO_TEST)"/' install.sh > build/install.sh
	set -o pipefail && docker run \
		--rm \
		-v $(CURDIR):/v \
		-w /v \
		resin/rpi-raspbian:jessie \
		/v/verify-docker-install | tee $@

armhf-verify-install-%:
	mkdir -p build
	sed 's/DEFAULT_CHANNEL_VALUE="test"/DEFAULT_CHANNEL_VALUE="$(CHANNEL_TO_TEST)"/' install.sh > build/install.sh
	set -o pipefail && docker run \
		--rm \
		-v $(CURDIR):/v \
		-w /v \
		arm32v7/$(subst -,:,$*) \
		/v/verify-docker-install | tee $@

aarch64-verify-install-%:
	mkdir -p build
	sed 's/DEFAULT_CHANNEL_VALUE="test"/DEFAULT_CHANNEL_VALUE="$(CHANNEL_TO_TEST)"/' install.sh > build/install.sh
	set -o pipefail && docker run \
		--rm \
		-v $(CURDIR):/v \
		-w /v \
		arm64v8/$(subst -,:,$*) \
		/v/verify-docker-install | tee $@

s390x-verify-install-%:
	mkdir -p build
	sed 's/DEFAULT_CHANNEL_VALUE="test"/DEFAULT_CHANNEL_VALUE="$(CHANNEL_TO_TEST)"/' install.sh > build/install.sh
	set -o pipefail && docker run \
		--rm \
		-v $(CURDIR):/v \
		-w /v \
		s390x/$(subst -,:,$*) \
		/v/verify-docker-install | tee $@

VAGRANT_PLAYBOOK ?= test
CHECK ?=
VERBOSE ?=
TAGS ?=
ANSIBLE_OPTS ?=
NETWORK ?=
VAULT ?= ${USER}

$(if ${CHECK},   $(eval ANSIBLE_OPTS += --check))
$(if ${VERBOSE}, $(eval ANSIBLE_OPTS += -${VERBOSE}))
$(if ${TAGS},    $(eval ANSIBLE_OPTS += --tags ${TAGS}))

install:
	ansible-playbook playbooks/install.yml --diff --ask-vault-pass ${ANSIBLE_OPTS}

arch:
	$(if ${NETWORK}, $(eval ANSIBLE_OPTS += --extra-vars "network=true"))
	ansible-playbook playbooks/archlinux.yml --diff --ask-become-pass --ask-vault-pass ${ANSIBLE_OPTS}

backup:
	$(eval ANSIBLE_OPTS += --vault-password-file vaulted_vars/system.txt)
	ansible-playbook playbooks/backup.yml --diff --ask-become-pass ${ANSIBLE_OPTS}

dotfiles:
	$(eval ANSIBLE_OPTS += --vault-password-file vaulted_vars/${VAULT}.txt)
	ansible-playbook playbooks/dotfiles.yml --diff --ask-become-pass ${ANSIBLE_OPTS}

deploy-vagrant:
	VAGRANT_VERBOSE=${VERBOSE} VAGRANT_TAGS=${TAGS} VAGRANT_PLAYBOOK=${VAGRANT_PLAYBOOK} vagrant provision

edit-vault:
	$(eval TARGET = vaulted_vars/${VAULT}.yml)
	$(eval ANSIBLE_OPTS += --vault-password-file vaulted_vars/${VAULT}.txt)
	ansible-vault edit ${TARGET} ${ANSIBLE_OPTS}

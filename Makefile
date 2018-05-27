VAGRANT_PLAYBOOK ?= test
CHECK ?=
VERBOSE ?=
TAGS ?=
ANSIBLE_OPTS ?=

$(if ${CHECK},   $(eval ANSIBLE_OPTS += --check))
$(if ${VERBOSE}, $(eval ANSIBLE_OPTS += -${VERBOSE}))
$(if ${TAGS},    $(eval ANSIBLE_OPTS += --tags ${TAGS}))

arch:
	$(eval ANSIBLE_OPTS += --vault-password-file vaulted_vars/system.txt)
	ansible-playbook playbooks/archlinux.yml --diff --ask-become-pass ${ANSIBLE_OPTS}

backup:
	$(eval ANSIBLE_OPTS += --vault-password-file vaulted_vars/system.txt)
	ansible-playbook playbooks/backup.yml --diff --ask-become-pass ${ANSIBLE_OPTS}

dotfiles:
	$(eval ANSIBLE_OPTS += --vault-password-file vaulted_vars/${USER}.txt)
	ansible-playbook playbooks/dotfiles.yml --diff --ask-become-pass ${ANSIBLE_OPTS}

deploy-vagrant:
	VAGRANT_VERBOSE=${VERBOSE} VAGRANT_TAGS=${TAGS} VAGRANT_PLAYBOOK=${VAGRANT_PLAYBOOK} vagrant provision

edit-vault:
	$(eval VAULT = vaulted_vars/${USER}.yml)
	$(eval ANSIBLE_OPTS += --vault-password-file vaulted_vars/${USER}.txt)
	ansible-vault edit ${VAULT} ${ANSIBLE_OPTS}

PLAYBOOK ?= archlinux
VAGRANT_PLAYBOOK ?= test
ANSIBLE_USER ?= local
TAGS ?=
VERBOSE ?=
CHECK ?=
VAULT ?= group_vars/${ANSIBLE_USER}/vault.yml
ANSIBLE_VAULT_PASSWORD_FILE = group_vars/${ANSIBLE_USER}/vault.txt
VAGRANT_OPTS = VAGRANT_VAULT_FILE=${ANSIBLE_VAULT_PASSWORD_FILE} VAGRANT_VERBOSE=${VERBOSE} VAGRANT_TAGS=${TAGS} VAGRANT_PLAYBOOK=${VAGRANT_PLAYBOOK}

ANSIBLE_OPTS = --vault-password-file ${ANSIBLE_VAULT_PASSWORD_FILE}
$(if ${CHECK},   $(eval ANSIBLE_OPTS += --check))
$(if ${VERBOSE}, $(eval ANSIBLE_OPTS += -${VERBOSE}))
$(if ${TAGS},    $(eval ANSIBLE_OPTS += --tags ${TAGS}))

deploy-local:
	ansible-playbook playbooks/${PLAYBOOK}.yml --diff --ask-become-pass ${ANSIBLE_OPTS}

backup:
	ansible-playbook playbooks/backup.yml --diff --ask-become-pass ${ANSIBLE_OPTS}

source-dotfiles:
	ansible-playbook playbooks/dotfiles.yml --diff --ask-become-pass ${ANSIBLE_OPTS}

deploy-vagrant:
	 ${VAGRANT_OPTS} vagrant provision

edit-vault:
	ansible-vault edit ${VAULT} ${ANSIBLE_OPTS}

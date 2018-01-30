PLAYBOOK ?= archlinux
VAGRANT_PLAYBOOK ?= test
TAGS ?=
VERBOSE ?=
CHECK ?=
VAULT ?= group_vars/local/vault.yml
ANSIBLE_VAULT_PASSWORD_FILE = group_vars/local/vault.txt
ANSIBLE_OPTS = --vault-password-file ${ANSIBLE_VAULT_PASSWORD_FILE}
VAGRANT_OPTS = VAGRANT_VAULT_FILE=${ANSIBLE_VAULT_PASSWORD_FILE} VAGRANT_VERBOSE=${VERBOSE} VAGRANT_TAGS=${TAGS} VAGRANT_PLAYBOOK=${VAGRANT_PLAYBOOK}

deploy-local:
	$(if ${CHECK},   $(eval ANSIBLE_OPTS += --check))
	$(if ${VERBOSE}, $(eval ANSIBLE_OPTS += -${VERBOSE}))
	$(if ${TAGS},    $(eval ANSIBLE_OPTS += --tags ${TAGS}))
	ansible-playbook playbooks/${PLAYBOOK}.yml --diff --ask-become-pass ${ANSIBLE_OPTS}

backup:
	$(if ${CHECK},   $(eval ANSIBLE_OPTS += --check))
	$(if ${VERBOSE}, $(eval ANSIBLE_OPTS += -${VERBOSE}))
	ansible-playbook playbooks/backup.yml --diff --ask-become-pass ${ANSIBLE_OPTS}

deploy-vagrant:
	 ${VAGRANT_OPTS} vagrant provision

edit-vault:
	ansible-vault edit ${VAULT} ${ANSIBLE_OPTS}

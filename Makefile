PLAYBOOK ?= archlinux
VAGRANT_PLAYBOOK ?= test
TAGS ?=
VERBOSE ?=
ANSIBLE_VAULT_PASSWORD_FILE = group_vars/local/vault.txt
ANSIBLE_OPTS = --vault-password-file ${ANSIBLE_VAULT_PASSWORD_FILE}
VAULT ?= group_vars/local/vault.yml

deploy-local:
	$(if ${TAGS}, $(eval ANSIBLE_OPTS += --tags ${TAGS}))
	$(if ${VERBOSE}, $(eval ANSIBLE_OPTS += -${VERBOSE}))
	ansible-playbook playbooks/${PLAYBOOK}.yml --diff --ask-become-pass ${ANSIBLE_OPTS}

deploy-vagrant:
	VAGRANT_VERBOSE=${VERBOSE} VAGRANT_TAGS=${TAGS} VAGRANT_PLAYBOOK=${VAGRANT_PLAYBOOK} vagrant provision

edit-vault:
	ansible-vault edit ${VAULT} ${ANSIBLE_OPTS}

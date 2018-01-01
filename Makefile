PLAYBOOK ?= main
VAGRANT_PLAYBOOK ?= test
TAGS ?=
ANSIBLE_VAULT_PASSWORD_FILE = group_vars/local/vault.sh
ANSIBLE_OPTS = --vault-password-file ${ANSIBLE_VAULT_PASSWORD_FILE}

deploy-local:
	$(if ${TAGS}, $(eval ANSIBLE_OPTS += --tags ${TAGS}))
	ansible-playbook playbooks/${PLAYBOOK}.yml --ask-become-pass ${ANSIBLE_OPTS}

deploy-vagrant:
	VAGRANT_TAGS=${TAGS} VAGRANT_PLAYBOOK=${VAGRANT_PLAYBOOK} vagrant provision

VAGRANT_PLAYBOOK ?= test
CHECK ?=
VERBOSE ?=
TAGS ?=
ANSIBLE_OPTS ?=
VAULT_OPTS ?=
VAULT ?= ${USER}

$(if ${CHECK},   $(eval ANSIBLE_OPTS += --check))
$(if ${VERBOSE}, $(eval ANSIBLE_OPTS += -${VERBOSE}))
$(if ${TAGS},    $(eval ANSIBLE_OPTS += --tags ${TAGS}))

ifneq ("$(wildcard vaulted_vars/${VAULT}.txt)", "")
  $(eval VAULT_OPTS += --vault-password-file vaulted_vars/${VAULT}.txt)
else
  $(eval VAULT_OPTS += --ask-vault-pass)
endif

install:
	ansible-playbook playbooks/install.yml --diff --ask-vault-pass ${ANSIBLE_OPTS}

arch:
	ansible-playbook playbooks/archlinux.yml --diff --ask-become-pass --ask-vault-pass ${ANSIBLE_OPTS}

dotfiles:
	ansible-playbook playbooks/dotfiles.yml --diff --ask-become-pass ${ANSIBLE_OPTS} ${VAULT_OPTS}

backup:
	ansible-playbook playbooks/backup.yml --diff --ask-become-pass --ask-vault-pass ${ANSIBLE_OPTS}

deploy-vagrant:
	VAGRANT_VERBOSE=${VERBOSE} VAGRANT_TAGS=${TAGS} VAGRANT_PLAYBOOK=${VAGRANT_PLAYBOOK} vagrant provision

edit-vault:
	ansible-vault edit vaulted_vars/${VAULT}.yml ${ANSIBLE_OPTS} ${VAULT_OPTS}

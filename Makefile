VAGRANT_PLAYBOOK ?= test
ANSIBLE_USER ?= local
CHECK ?=
VERBOSE ?=
TAGS ?=
ANSIBLE_OPTS ?=

$(if ${CHECK},   $(eval ANSIBLE_OPTS += --check))
$(if ${VERBOSE}, $(eval ANSIBLE_OPTS += -${VERBOSE}))
$(if ${TAGS},    $(eval ANSIBLE_OPTS += --tags ${TAGS}))

arch:
	$(eval ANSIBLE_OPTS += --vault-password-file vaulted_vars/system/vault.txt)
	ansible-playbook playbooks/archlinux.yml --diff --ask-become-pass ${ANSIBLE_OPTS}

backup:
	$(eval ANSIBLE_OPTS += --vault-password-file vaulted_vars/local/vault.txt)
	ansible-playbook playbooks/backup.yml --diff --ask-become-pass ${ANSIBLE_OPTS}

dotfiles:
	$(eval ANSIBLE_OPTS += --vault-password-file vaulted_vars/local/vault.txt)
	ansible-playbook playbooks/dotfiles.yml --diff --ask-become-pass ${ANSIBLE_OPTS}

work:
	$(eval ANSIBLE_OPTS += --vault-password-file vaulted_vars/work/vault.txt)
	ansible-playbook playbooks/work.yml --diff --ask-become-pass ${ANSIBLE_OPTS}

deploy-vagrant:
	 VAGRANT_VERBOSE=${VERBOSE} VAGRANT_TAGS=${TAGS} VAGRANT_PLAYBOOK=${VAGRANT_PLAYBOOK} vagrant provision

edit-vault:
	$(eval VAULT = vaulted_vars/${ANSIBLE_USER}/vault.yml)
	$(eval ANSIBLE_VAULT_PASSWORD_FILE = vaulted_vars/${ANSIBLE_USER}/vault.txt)
	ansible-vault edit ${VAULT} ${ANSIBLE_OPTS}

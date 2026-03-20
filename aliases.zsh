# shell stuff
alias ls="ls -lahG"
alias python="python3"

# Git shortcuts
alias gs="git status"
alias ga="git add -A"
alias gbl="git branch"
alias gl="git log --oneline"
alias gd="git diff"

# Fake data shortcuts
alias tsp="node -e 'console.log(new Date().toISOString())' | tr -d '\n' | pbcopy && pbpaste"
alias fml="fakemail | tr -d '\n' | pbcopy && pbpaste"
alias uid="uuid | tr -d '\n' | pbcopy && pbpaste"

# View/edit aliases
alias aliases="vim ~/.oh-my-zsh/custom/aliases.zsh && source ~/.zshrc"

# Vault login aliases
alias vault_login="vault login -method oidc -path azuread"
alias vault_prod="export VAULT_ADDR=https://vault.bestegg.com && vault_login"
alias vault_uat="export VAULT_ADDR=https://vault.uat.bestegg.com && vault_login"
alias vault_sbx="export VAULT_ADDR=https://vault.sbx.bestegg.com && vault_login"
alias vault_all="vault_sbx && vault_uat && vault_prod"

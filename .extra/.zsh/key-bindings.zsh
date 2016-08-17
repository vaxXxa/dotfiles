# GIT heart FZF
# -------------

is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

gf() {
  is_in_git_repo || return
  git -c color.status=always status --short |
  fzf-tmux -m --ansi --nth 2..,.. \
    --preview 'NAME="$(cut -c4- <<< {})" &&
               (git diff --color=always "$NAME" | sed 1,4d; cat "$NAME") | head -'$LINES |
  cut -c4-
}

gb() {
  is_in_git_repo || return
  git branch -a --color=always | grep -v HEAD | sort |
  fzf-tmux --ansi --multi --tac --preview-window right:70% \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -'$LINES |
  sed 's/^..//' | cut -d' ' -f1 |
  sed 's#^remotes/##'
}

gt() {
  is_in_git_repo || return
  git tag --sort -version:refname |
  fzf-tmux --multi --preview-window right:70% \
    --preview 'git show --color=always {} | head -'$LINES
}

gh() {
  is_in_git_repo || return
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph |
  fzf-tmux --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
    --header 'Press CTRL-S to toggle sort' \
    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -'$LINES |
  grep -o "[a-f0-9]\{7,\}"
}

gr() {
  is_in_git_repo || return
  git remote -v | awk '{print $1 " " $2}' | uniq |
  fzf-tmux --tac \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" $(cut -d" " -f1 <<< {}) | head -'$LINES |
  cut -d' ' -f1
}


# Checkout git commit
fzf-checkout-commit() {
    local commits commit
    commits=$(git log --graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr %C(auto)%C(blue)%cn") &&
        commit=$(echo "$commits" | fzf --ansi --no-sort --reverse --tiebreak=index) &&
        git checkout $(echo "$commit" | grep -o "[a-f0-9]\{7,\}")
}
bindkey -s '^Go' 'fzf-checkout-commit\n'

# Checkout git branch
fzf-checkout-branch() {
    local branches branch
    branches=$(git branch -a --color=always | grep -v HEAD | sort) &&
        branch=$(echo "$branches" |
    fzf --ansi --tac -d $(( 2 + $(wc -l <<< "$branches") )) +m +s) &&
        git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}
bindkey -s '^Gk' 'fzf-checkout-branch\n'

# Git log
fzf-log() {
    is_in_git_repo || return
    git log --graph --color=always \
        --format="%C(auto)%h%d %s %C(black)%C(bold)%cr %C(auto)%C(blue)%cn" "$@" |
    fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
        --bind "ctrl-m:execute:
    (grep -o '[a-f0-9]\{7\}' | head -1 |
    xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
    {}
    FZF-EOF"
    zle redisplay
}
zle -N fzf-log
bindkey '^Gl' fzf-log


join-lines() {
  local item
  while read item; do
    echo -n "${(q)item} "
  done
}

bind-git-helper() {
  local char
  for c in $@; do
    eval "fzf-g$c-widget() LBUFFER+=\$(g$c | join-lines)"
    eval "zle -N fzf-g$c-widget"
    eval "bindkey '^G$c' fzf-g$c-widget"
  done
}
bind-git-helper f b t r h
unset -f bind-git-helper
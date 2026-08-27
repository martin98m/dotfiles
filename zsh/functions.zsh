gfp() {
  echo -e "\033[2m→ git fetch --prune\033[0m"
  git fetch --prune
}

gpfl() {
  echo -e "\033[2m→ git push --force-with-lease\033[0m"
  git push --force-with-lease
}

gundo() {
  echo -e "\033[2m→ git reset --soft HEAD~1\033[0m"
  git reset --soft HEAD~1
}

gcane() {
  echo -e "\033[2m→ git commit --amend --no-edit\033[0m"
  git commit --amend --no-edit
}

gsync() {
  local main_branch="$(git_main_branch)"
  echo -e "\033[2m→ git fetch --prune && git rebase origin/$main_branch\033[0m"
  git fetch --prune && git rebase "origin/$main_branch"
}

gnb() {
  local branch="$1"
  local main_branch="$(git_main_branch)"
  echo -e "\033[2m→ git checkout $main_branch && git pull && git checkout -b $branch\033[0m"
  git checkout "$main_branch" && git pull && git checkout -b "$branch"
}

gsquash() {
  local against="${1:-$(git_main_branch)}"
  local base="$(git merge-base "$against" HEAD)"
  echo -e "\033[2m→ git reset --soft $base && git commit\033[0m"
  git reset --soft "$base" && git commit
}

gsquashundo() {
  echo -e "\033[2m→ git reset --soft ORIG_HEAD\033[0m"
  git reset --soft ORIG_HEAD
}

gsubinit() {
  echo -e "\033[2m→ git submodule update --init --recursive\033[0m"
  git submodule update --init --recursive
}

gsubdeinit() {
  echo -e "\033[2m→ git submodule deinit --all\033[0m"
  git submodule deinit --all
}

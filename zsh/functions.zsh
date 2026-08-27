gfp() {
  echo -e "\033[2m→ git fetch --prune\033[0m"
  git fetch --prune
}

gpfl() {
  echo -e "\033[2m→ git push --force-with-lease\033[0m"
  git push --force-with-lease
}

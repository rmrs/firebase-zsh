function is_firebase_project() {
  if [[ -e ./firebase.json ]]; then 
    echo 1
  fi
}

function firebase_exists() {
  if hash firebase 2>/dev/null; then
    echo 1
  fi
}

function is_logged_in() {
  # if logged in EMAIL holds the email; otherwise null
  local EMAIL=$(timeout -s KILL 1 firebase login | grep "Already logged in as" | awk 'END {print $NF}')
  echo $EMAIL
}

function is_logged_in_static() {
  local EMAIL=$(grep -E -o "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}\b" ~/.config/configstore/firebase-tools.json)
  echo $EMAIL
}

function current_project_id() {
  local CURRENT=$(firebase list | grep "(current)" | sed 's/│/|/g' | cut -d'|' -f3 | sed 's/[[:space:]]//g')
  echo $CURRENT
}

function firebase_status_eastwood() {
  if [ $(is_firebase_project) ] && [ $(firebase_exists) ] ; then
    local EMAIL=$(is_logged_in_static)
    if [ -z "$EMAIL" ]; then
      EMAIL="not_signed_in"
    fi
    echo -n %{$fg[yellow]%}"[$EMAIL]"%{$reset_color%}
  fi
}

function firebase_status_robbyrussell() {
  if [ $(is_firebase_project) ] && [ $(firebase_exists) ] ; then
    local EMAIL=$(is_logged_in_static)
    if [ -z "$EMAIL" ]; then
      EMAIL="not_signed_in"
    fi
    echo -n %{$fg_bold[yellow]%}"$EMAIL"%{$reset_color%}
  fi
}

function firebase_status() {
  firebase_status_eastwood
}

alias f='firebase'
alias fl='firebase list'

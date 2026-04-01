#!/bin/bash
# github_manager.sh - Automatiser Git avec API GitHub
# Auteur : Leonel-Magloire PENGOU MBA
# Usage  : ./github_manager.sh [commande]

GITHUB_TOKEN="${GITHUB_TOKEN}"
USER="leopen10"
API="https://api.github.com"

api_call() {
    curl -s -H "Authorization: token $GITHUB_TOKEN" \
         -H "Accept: application/vnd.github.v3+json" "$@"
}

list_repos() {
    echo "=== MES REPOS GITHUB ==="
    api_call "$API/users/$USER/repos?sort=updated&per_page=10" | \
    python3 -c "import sys,json; [print(f\"{r['name']:40} | {r['updated_at'][:10]} | Stars: {r['stargazers_count']}\") for r in json.load(sys.stdin)]"
}

list_branches() {
    REPO=$1
    echo "=== BRANCHES DE $REPO ==="
    api_call "$API/repos/$USER/$REPO/branches" | \
    python3 -c "import sys,json; [print(b['name']) for b in json.load(sys.stdin)]"
}

create_issue() {
    REPO=$1; TITLE=$2; BODY=$3
    echo "=== CREATION ISSUE : $TITLE ==="
    api_call -X POST "$API/repos/$USER/$REPO/issues" \
    -d "{\"title\":\"$TITLE\",\"body\":\"$BODY\"}" | \
    python3 -c "import sys,json; r=json.load(sys.stdin); print(f\"Issue #{r['number']} creee : {r['html_url']}\")"
}

list_issues() {
    REPO=$1
    echo "=== ISSUES DE $REPO ==="
    api_call "$API/repos/$USER/$REPO/issues" | \
    python3 -c "import sys,json; data=json.load(sys.stdin); [print(f\"#{i['number']:4} | {i['title']:40} | {i['state']}\") for i in data] if isinstance(data,list) else print(data)"
}

case $1 in
    repos)    list_repos ;;
    branches) list_branches $2 ;;
    issues)   list_issues $2 ;;
    issue)    create_issue $2 "$3" "$4" ;;
    *) echo "Usage: $0 {repos|branches <repo>|issues <repo>|issue <repo> <title> <body>}" ;;
esac

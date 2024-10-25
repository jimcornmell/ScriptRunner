#!/bin/bash

if [[ $# -ne 1 ]]; then
    exit
fi

# URLS/SETUP...
# Load you personal configuration:
if [[ -e ~/.config/scriptRunner/config.sh ]]; then
    source ~/.config/scriptRunner/config.sh
fi

# Your browser preference:
if [[ -z "$BROWSER" ]]; then
    BROWSER="google-chrome"
fi

# Your ticket URL preference:
if [[ -z "$TICKET_URL" ]]; then
    TICKET_URL="https://www.ecosia.org/search?method=index&q="
fi

# Your search engine preference:
if [[ -z "$SEARCH_ENGINE" ]]; then
    SEARCH_ENGINE="https://www.ecosia.org/search?method=index&q="
fi

MVN_REPO="https://mvnrepository.com/artifact"

# Your cve info preference:
CVE_LINK="https://ossindex.sonatype.org/vulnerability"
# CVE_LINK="https://nvd.nist.gov/vuln/detail"
# CVE_LINK="https://devhub.checkmarx.com/cve-details"
# CVE_LINK="https://cve.mitre.org/cgi-bin/cvename.cgi?name="

# Your hex preference:
HEX_LINK="https://www.colorhexa.com"

# Your repository preference:
REPO_LINK="https://github.com"

# Other values:
CHT_LINK="https://cheat.sh"
MANPAGE_LINK="https://linux.die.net/man/1"
TYPE="UNKNOWN"
FILE="none"
LINE="0"
COL="0"
CMD="run"
FILETYPE="bash"
FOLDER="$PWD"
WORD=$1

# Use the WORD to decide which site to go to......

# Is WORD a link????
if [[ "$WORD" =~ \"http ]]; then
    TYPE="URL"
    url=$(echo "$WORD" | sed -e 's/.*\"http/http/' -e 's/".*//')
elif [[ "$WORD" =~ " http" ]]; then
    TYPE="URL"
    url=$(echo "$WORD" | sed -e 's/.* http/http/' -e 's/ .*//')
elif [[ "$WORD" =~ http ]]; then
    TYPE="URL"
    url=$(echo "$WORD" | sed -e 's/.*http/http/' -e 's/[^-a-zA-Z0-9\/@:%._\+~#=].*//')

# Is WORD a cve?
elif [[ "${WORD,,}" =~ cve ]]; then
    TYPE="CVE"
    url=$(echo "${WORD,,}" | sed -e 's/<cve>//' -e 's/<\/cve>//' -e 's/.*cve/cve/' -e 's/[^0-9cve-].*//')
    url="$CVE_LINK/${url^^}"

# Is WORD a hex for a colour?
elif [[ $WORD =~ ^[0-9a-fA-F]{6}$ ]]; then
    TYPE="HEX"
    url="$HEX_LINK/$WORD"

# Is WORD a jira issue?
elif [[ $WORD =~ ^[a-zA-Z]{2,6}-[0-9]{2,7}$ ]]; then
    TYPE="JIRA"
    url="$TICKET_URL/${WORD^^}"

# Is WORD a git repo?
elif [[ $WORD =~ ^[0-9a-zA-Z-]{3,}/[0-9a-zA-Z]{3,} ]]; then
    TYPE="GIT"
    url="$REPO_LINK/$WORD"

# Is WORD a maven repo?
elif [[ "${WORD,,}" =~ groupid ]]; then
    TYPE="MVN GROUP"
    g=$(echo "$WORD" | sed -e 's/.*<groupid>//i' -e 's/<\/groupid>.*//i')
    url="$MVN_REPO/$g"
elif [[ "${WORD,,}" =~ artifactid ]]; then
    TYPE="MVN ARTIFACT"
    l=$(( LINE - 1 ))
    g=$(awk "NR==$l" "$FILE" | sed -e 's/.*<groupid>//i' -e 's/<\/groupid>.*//i')
    a=$(echo "$WORD" | sed -e 's/.*<artifactid>//i' -e 's/<\/artifactid>.*//i')
    url="$MVN_REPO/$g/$a"
elif [[ "${WORD,,}" =~ version ]]; then
    TYPE="MVN VERSION"
    l=$(( LINE - 2 ))
    g=$(awk "NR==$l" "$FILE" | sed -e 's/.*<groupid>//i' -e 's/<\/groupid>.*//i')
    l=$(( LINE - 1 ))
    a=$(awk "NR==$l" "$FILE" | sed -e 's/.*<artifactid>//i' -e 's/<\/artifactid>.*//i')
    v=$(echo "$WORD" | sed -e 's/.*<version>//i' -e 's/<\/version>.*//i')

    # Get version from parent pom, or self, if the version is a variable.
    if [[ $v =~ \$ ]]; then
        v=$(echo "$v" | sed -e 's/${//' -e 's/}//')
        v=$(find "$FOLDER/.." -type f -name pom.xml -exec grep "<$v>" {} \; | head -1)
        v=$(echo "$v" | sed -e 's/<\/.*//' -e 's/.*>//')
    fi

    url="$MVN_REPO/$g/$a/$v"
else
    # Is the WORD a command or alias?
    if [[ $(which "$WORD") ]]; then
        TYPE="CHT"

        url="$MANPAGE_LINK/$WORD"
        $BROWSER "$url">/dev/null 2>&1

        url="$CHT_LINK/$FILETYPE/$WORD"
    else
        TYPE="SEARCH_ENGINE"
        url="$SEARCH_ENGINE$WORD"
    fi
fi

if [[ "$url" =~ ^http ]]; then
    if [[ $CMD == test ]]; then
        echo "TEST = [$TYPE] $url"
        # TODO OPEN DIALOG
    else
        $BROWSER "$url">/dev/null 2>&1 &
    fi
fi


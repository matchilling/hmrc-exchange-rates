#!/usr/bin/env sh
set -eou pipefail

readonly SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
readonly PROJECT_DIR=$(cd "${SCRIPT_DIR}/.." && pwd)
readonly RATE_DIR=$(cd "${PROJECT_DIR}/rate" && pwd)

command -v python version >/dev/null 2>&1 || {
    echo >&2 "Please install python in your path before continuing."
    exit 1
}

read_json() {
    local SED_EXTENDED
    local UNAMESTR
    local VALUE

    UNAMESTR=$(uname)

    if [ 'Linux' = "$UNAMESTR" ]; then
        SED_EXTENDED='-r'
    elif [ 'Darwin' = "$UNAMESTR" ]; then
        SED_EXTENDED='-E'
    fi;

    VALUE=$(grep -m 1 "\"${2}\"" "${1}" | sed ${SED_EXTENDED} 's/^ *//;s/.*: *"//;s/",?//')

    if [ ! "$VALUE" ]; then
        printf "Error: Cannot find \"%s\" in %s" "${2}" "${1}" >&2;
        exit 1;
    else
        echo "$VALUE"
    fi;
}

readonly LATEST_START_DATE=$(read_json "$RATE_DIR/latest.json" "start")
readonly NEXT_YYYY=$(date -v+1m -j -f '%Y-%m-%d' "${LATEST_START_DATE}" "+%Y")
readonly NEXT_MM=$(date -v+1m -j -f '%Y-%m-%d' "${LATEST_START_DATE}" "+%m")
readonly HMRC_URL="http://www.hmrc.gov.uk/softwaredevelopers/rates/exrates-monthly-${NEXT_MM}${NEXT_YYYY: -2}.xml"

readonly STATUS_CODE=$(curl --silent -LI -X OPTIONS "${HMRC_URL}" -o /dev/null -w '%{http_code}')
if [ "$STATUS_CODE" != '200' ] ; then
    echo "No rates yet available for ${NEXT_YYYY}-${NEXT_MM}."
    exit 0;
fi

readonly TARGET_FILE="$RATE_DIR/${NEXT_YYYY}/${NEXT_MM}.json"
readonly TARGET_DIR="$(dirname "$TARGET_FILE")"
if [ ! -d "/path/to/dir" ]; then
    mkdir -p "${TARGET_DIR}"
fi

curl --silent -X GET "${HMRC_URL}" | "${SCRIPT_DIR}/to_json.sh" > "$TARGET_FILE"

# Update latest rates
cp "${TARGET_FILE}" "$RATE_DIR/latest.json"

# Update README.md
readonly README=$(cat "$SCRIPT_DIR/README_TEMPLATE.md")
readonly LATEST_M=$(date -v+1m -j -f '%Y-%m-%d' "${LATEST_START_DATE}" "+%b")
echo "${README}" | \
  sed 's/###LATEST_M_YYYY###/'"${LATEST_M} ${NEXT_YYYY}"'/g' | \
  sed 's/###LAST_UPDATE###/'"$(date -u)"'/g' \
  > "$PROJECT_DIR/README.md"

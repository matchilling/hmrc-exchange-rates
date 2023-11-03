#!/usr/bin/env bash
set -eu pipefail

readonly SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
readonly PROJECT_DIR=$(cd "${SCRIPT_DIR}/.." && pwd)
readonly RATE_DIR=$(cd "${PROJECT_DIR}/rate" && pwd)
readonly README=$(cat "$SCRIPT_DIR/README_TEMPLATE.md")

command -v python3 version >/dev/null 2>&1 || {
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

readonly LATEST_START_DATE=$(date -d $(read_json "$RATE_DIR/latest.json" "start"))
readonly NEXT_YYYY=$(date -d "${LATEST_START_DATE} +1 month" "+%Y")
readonly NEXT_MM=$(date -d "${LATEST_START_DATE} +1 month" "+%m")

# HMRC breaks its URL scheme sometimes 🤷‍, so we're trying different URLS
readonly HMRC_URL_01="https://www.trade-tariff.service.gov.uk/api/v2/exchange_rates/files/monthly_xml_${NEXT_YYYY}-${NEXT_MM}.xml"
readonly HMRC_URL_02="https://www.trade-tariff.service.gov.uk/api/v2/exchange_rates/files/monthly_xml_${NEXT_YYYY}-${NEXT_MM}.XML"
HMRC_URL="${HMRC_URL_01}"

readonly STATUS_CODE_01=$(curl --silent -LI -X GET "${HMRC_URL_01}" -o /dev/null -w '%{http_code}')
if [ "$STATUS_CODE_01" != '200' ]; then

    readonly STATUS_CODE_02=$(curl --silent -LI -X GET "${HMRC_URL_02}" -o /dev/null -w '%{http_code}')
    if [ "$STATUS_CODE_02" != '200' ]
        then
            echo "No rates for ${NEXT_YYYY}-${NEXT_MM} available yet."

            readonly LATEST_YYYY=$(date -d "${LATEST_START_DATE}" "+%Y")
            readonly LATEST_M=$(date -d "${LATEST_START_DATE}" "+%b")
            echo "${README}" | \
              sed 's/###LATEST_M_YYYY###/'"${LATEST_M} ${LATEST_YYYY}"'/g' | \
              sed 's/###LAST_UPDATE###/'"$(date -u)"'/g' \
              > "$PROJECT_DIR/README.md"

            exit 0;
        else
          HMRC_URL="${HMRC_URL_02}"
    fi
fi

readonly TARGET_FILE="$RATE_DIR/${NEXT_YYYY}/${NEXT_MM}.json"
readonly TARGET_DIR="$(dirname "$TARGET_FILE")"
if [ ! -d "/path/to/dir" ]; then
    mkdir -p "${TARGET_DIR}"
fi

curl --silent -X GET "${HMRC_URL}" | "${SCRIPT_DIR}/converter/from_xml.sh" > "$TARGET_FILE"

cp "${TARGET_FILE}" "$RATE_DIR/latest.json"

readonly LATEST_M=$(date -d "${LATEST_START_DATE} +1 month" "+%b")
echo "${README}" | \
  sed 's/###LATEST_M_YYYY###/'"${LATEST_M} ${NEXT_YYYY}"'/g' | \
  sed 's/###LAST_UPDATE###/'"$(date -u)"'/g' \
  > "$PROJECT_DIR/README.md"

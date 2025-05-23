#!/usr/bin/env bash
set -euo pipefail

# Enable debug - print commands
#set -x

#############
# FUNCTIONS #
#############

generateToc() {
  programNameList=()

  while read -r file; do
    programName=$(cut -d@ -f1 <<<"$file" | sed 's/.rb//')
    programNameList+=("$programName")
  done < <(find "$INPUT_FORMULA_FOLDER" -type f -name '*.rb' -exec basename {} \; | sort)

  if [[ ${#programNameList[@]} == "0" ]]; then
    echo "_n/a (no formula found)_"
    return
  fi

  printf "* \`%s\`\n" "${programNameList[@]}" | sort -u
}

###############
# CHECK INPUT #
###############

echo "Checking input"
if [[ -z "${INPUT_FORMULA_FOLDER:-}" ]]; then
    echo "ERROR: No formula-folder defined"
    exit 1
fi
echo "  formula-folder: $INPUT_FORMULA_FOLDER"

if [[ -z "${INPUT_REPLACE_IN:-}" ]]; then
    echo "ERROR: No replace-in defined"
    exit 1
fi
echo "  replace-in: $INPUT_REPLACE_IN"

if [[ -z "${INPUT_REPLACE_MARKER_START:-}" ]]; then
    echo "ERROR: No replace-marker-start defined"
    exit 1
fi
echo "  replace-marker-start: $INPUT_REPLACE_MARKER_START"

if [[ -z "${INPUT_REPLACE_MARKER_END:-}" ]]; then
    echo "ERROR: No replace-marker-end defined"
    exit 1
fi
echo "  replace-marker-start: $INPUT_REPLACE_MARKER_END"

##################
# SANITIZE INPUT #
##################

# Escape MARKER
markerSanitizeQuery='s_[]$.*[/\^]_\\&_g'
INPUT_REPLACE_MARKER_START=$(sed "$markerSanitizeQuery" <<<"$INPUT_REPLACE_MARKER_START")
INPUT_REPLACE_MARKER_END=$(sed "$markerSanitizeQuery" <<<"$INPUT_REPLACE_MARKER_END")

#######
# RUN #
#######

echo "Generating TOC..."
toc=$(generateToc)
echo "TOC:"
echo "----"
echo "$toc"
echo "----"

for file in ${INPUT_REPLACE_IN//,/ }; do
    # https://stackoverflow.com/questions/2699666/replace-delimited-block-of-text-in-file-with-the-contents-of-another-file
    sed -i -ne '/'"$INPUT_REPLACE_MARKER_START"'/ {p; r '<(cat <<<"$toc") -e ':a; n; /'"$INPUT_REPLACE_MARKER_END"'/ {p; b}; ba}; p' "$file"
done

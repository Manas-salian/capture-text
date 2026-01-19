#!/usr/bin/env bash

# ----------- MAIN MENU WITH NOTEBOOK (TABS) -----------
RESULT=$(yad --form \
  --undecorated \
  --fixed \
  --width=350 \
  --height=450 \
  --close-on-unfocus \
  --mouse \
  --text="<b>Select OCR options</b>" \
  --button=OK:0 \
  --field="Preserve layout:CHK" FALSE \
  --field="<b>Languages</b>:LBL" "" \
  --field="English (eng):CHK" FALSE \
  --field="German (deu):CHK" FALSE \
  --field="French (fra):CHK" FALSE \
  --field="Spanish (spa):CHK" FALSE \
  --field="Portuguese (por):CHK" FALSE \
  --field="Italian (ita):CHK" FALSE \
  --field="Dutch (nld):CHK" FALSE \
  --field="Russian (rus):CHK" FALSE \
  --field="Chinese - Simplified (chi_sim):CHK" FALSE \
  --field="Chinese - Traditional (chi_tra):CHK" FALSE \
  --field="Japanese (jpn):CHK" FALSE \
  --field="Korean (kor):CHK" FALSE \
  --field="Arabic (ara):CHK" FALSE \
  --field="Hindi (hin):CHK" FALSE \
  --field="Bengali (ben):CHK" FALSE \
  --field="Tamil (tam):CHK" FALSE \
  --field="Telugu (tel):CHK" FALSE \
  --field="Urdu (urd):CHK" FALSE \
  --field="Greek (ell):CHK" FALSE \
  --field="Hebrew (heb):CHK" FALSE \
  --field="Turkish (tur):CHK" FALSE)

# If user closed the dialog
[ -z "$RESULT" ] && exit 0

# ----------- PARSE RESULTS (POSIX compatible) -----------
# Save to temp variable and parse line by line
echo "$RESULT" | {
  IFS='|'
  read -r PRESERVE_LAYOUT LABEL \
    ENG DEU FRA SPA POR ITA NLD RUS \
    CHI_SIM CHI_TRA JPN KOR ARA HIN \
    BEN TAM TEL URD ELL HEB TUR

  # Build language string
  LANGUAGES=""
  [ "$ENG" = "TRUE" ] && LANGUAGES="${LANGUAGES}eng+"
  [ "$DEU" = "TRUE" ] && LANGUAGES="${LANGUAGES}deu+"
  [ "$FRA" = "TRUE" ] && LANGUAGES="${LANGUAGES}fra+"
  [ "$SPA" = "TRUE" ] && LANGUAGES="${LANGUAGES}spa+"
  [ "$POR" = "TRUE" ] && LANGUAGES="${LANGUAGES}por+"
  [ "$ITA" = "TRUE" ] && LANGUAGES="${LANGUAGES}ita+"
  [ "$NLD" = "TRUE" ] && LANGUAGES="${LANGUAGES}nld+"
  [ "$RUS" = "TRUE" ] && LANGUAGES="${LANGUAGES}rus+"
  [ "$CHI_SIM" = "TRUE" ] && LANGUAGES="${LANGUAGES}chi_sim+"
  [ "$CHI_TRA" = "TRUE" ] && LANGUAGES="${LANGUAGES}chi_tra+"
  [ "$JPN" = "TRUE" ] && LANGUAGES="${LANGUAGES}jpn+"
  [ "$KOR" = "TRUE" ] && LANGUAGES="${LANGUAGES}kor+"
  [ "$ARA" = "TRUE" ] && LANGUAGES="${LANGUAGES}ara+"
  [ "$HIN" = "TRUE" ] && LANGUAGES="${LANGUAGES}hin+"
  [ "$BEN" = "TRUE" ] && LANGUAGES="${LANGUAGES}ben+"
  [ "$TAM" = "TRUE" ] && LANGUAGES="${LANGUAGES}tam+"
  [ "$TEL" = "TRUE" ] && LANGUAGES="${LANGUAGES}tel+"
  [ "$URD" = "TRUE" ] && LANGUAGES="${LANGUAGES}urd+"
  [ "$ELL" = "TRUE" ] && LANGUAGES="${LANGUAGES}ell+"
  [ "$HEB" = "TRUE" ] && LANGUAGES="${LANGUAGES}heb+"
  [ "$TUR" = "TRUE" ] && LANGUAGES="${LANGUAGES}tur+"

  # Remove trailing +
  LANGUAGES="${LANGUAGES%+}"

  # Default to eng if nothing selected
  [ -z "$LANGUAGES" ] && LANGUAGES="eng"

  # Convert TRUE/FALSE to 1/0
  if [ "$PRESERVE_LAYOUT" = "TRUE" ]; then
    PRESERVE_LAYOUT=1
  else
    PRESERVE_LAYOUT=0
  fi

  # ---- Print results ----
  echo "Preserve layout = $PRESERVE_LAYOUT"
  echo "Selected languages = $LANGUAGES"
}

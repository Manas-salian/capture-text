#!/usr/bin/env bash

# Step 1: Main options
PRESERVE_LAYOUT=$(zenity --list \
  --title="OCR Options" \
  --text="Preserve layout?" \
  --radiolist \
  --column="Select" --column="Option" \
  TRUE "No" \
  FALSE "Yes" \
  --hide-header \
  --width=300 --height=200)

[ -z "$PRESERVE_LAYOUT" ] && exit 0

# Convert to 1/0
if [ "$PRESERVE_LAYOUT" = "Yes" ]; then
  PRESERVE_LAYOUT=1
else
  PRESERVE_LAYOUT=0
fi

# Step 2: Ask about languages
CONFIGURE_LANGS=$(zenity --question \
  --title="Language Configuration" \
  --text="Do you want to select specific languages?\n\n(Default is English only)" \
  --ok-label="Select Languages" \
  --cancel-label="Use Default (eng)" \
  --width=350)

if [ $? -eq 0 ]; then
  # Show language selection
  SELECTED=$(zenity --list \
    --title="Select OCR Languages" \
    --text="Choose one or more languages:" \
    --checklist \
    --column="Select" --column="Code" --column="Language" \
    --separator="+" \
    --width=400 --height=500 \
    FALSE "eng" "English" \
    FALSE "deu" "German" \
    FALSE "fra" "French" \
    FALSE "spa" "Spanish" \
    FALSE "por" "Portuguese" \
    FALSE "ita" "Italian" \
    FALSE "nld" "Dutch" \
    FALSE "rus" "Russian" \
    FALSE "chi_sim" "Chinese - Simplified" \
    FALSE "chi_tra" "Chinese - Traditional" \
    FALSE "jpn" "Japanese" \
    FALSE "kor" "Korean" \
    FALSE "ara" "Arabic" \
    FALSE "hin" "Hindi" \
    FALSE "ben" "Bengali" \
    FALSE "tam" "Tamil" \
    FALSE "tel" "Telugu" \
    FALSE "urd" "Urdu" \
    FALSE "ell" "Greek" \
    FALSE "heb" "Hebrew" \
    FALSE "tur" "Turkish" \
    --print-column=2)
  
  LANGUAGES="${SELECTED:-eng}"
else
  LANGUAGES="eng"
fi

echo "Preserve layout = $PRESERVE_LAYOUT"
echo "Selected languages = $LANGUAGES"

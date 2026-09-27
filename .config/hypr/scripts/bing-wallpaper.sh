#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/BingWallpapers"
API_URL="https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=fr-FR"
BING_BASE="https://www.bing.com"
TRANSITION_TYPE="grow"
TRANSITION_DURATION=2

mkdir -p "$WALLPAPER_DIR"

today=$(date +%Y-%m-%d)
wallpaper_path="$WALLPAPER_DIR/bing-$today.jpg"

if [ -f "$wallpaper_path" ]; then
    echo "Wallpaper du jour déjà présent : $wallpaper_path"
    awww img "$wallpaper_path" --transition-type "$TRANSITION_TYPE" --transition-duration "$TRANSITION_DURATION"
    exit 0
fi

response=$(curl -s "$API_URL")

if [ -z "$response" ]; then
    echo "Erreur : réponse vide de l'API Bing"
    exit 1
fi

image_url=$(echo "$response" | jq -r '.images[0].url')

if [ -z "$image_url" ] || [ "$image_url" = "null" ]; then
    echo "Erreur : impossible d'extraire l'URL de l'image"
    exit 1
fi

full_url="${BING_BASE}${image_url}"

echo "Téléchargement de : $full_url"
curl -s -o "$wallpaper_path" "$full_url"

if [ ! -f "$wallpaper_path" ] || [ ! -s "$wallpaper_path" ]; then
    echo "Erreur : téléchargement échoué"
    rm -f "$wallpaper_path"
    exit 1
fi

echo "Application du fond d'écran : $wallpaper_path"
awww img "$wallpaper_path" --transition-type "$TRANSITION_TYPE" --transition-duration "$TRANSITION_DURATION"

find "$WALLPAPER_DIR" -name "bing-*.jpg" -mtime +30 -delete

echo "Terminé."

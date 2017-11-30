#!/bin/bash
# Convert the original Breeze Dark theme to Zephyr colors
# This theme uses a base color of #709080 with a ligher active color #a2d5bb

# Exit on errors
set -e

# Recolor and tweak PNG assets
if [ ! -f assets/.converted ]; then
  # Temporarily move custom colored images
  mkdir -p assets-tmp
  mv assets/titlebutton-close*active* assets-tmp
  mv assets/titlebutton-close*hover* assets-tmp

  # Recolor blue images
  mogrify -modulate 100,41,72 assets/*.png

  # Move back custom colored images
  mv assets-tmp/* assets/
  rmdir assets-tmp

  # Mark that we've converted these images
  touch assets/.converted
fi

# Build Xfwm theme button images
bgactive='#709080'
bginactive='#363636'
function asset2xwfm ()
{
  convert "assets/titlebutton-$1.png" -background "$3" -alpha remove "xfwm4/$2.xpm"
}

asset2xwfm close close-active "$bgactive"
convert "xfwm4/src/close-backdrop.png" "assets/titlebutton-close-hover.png" \
  -gravity center -composite  \
  -background "$bgactive" -alpha remove "xfwm4/close-prelight.xpm"
convert "xfwm4/src/close-backdrop.png" "assets/titlebutton-close-active.png" \
  -gravity center -composite  \
  -background "$bgactive" -alpha remove "xfwm4/close-pressed.xpm"
asset2xwfm close-backdrop close-inactive "$bginactive"

asset2xwfm maximize maximize-active "$bgactive"
asset2xwfm maximize-hover maximize-prelight "$bgactive"
asset2xwfm maximize-active maximize-pressed "$bgactive"
asset2xwfm maximize-backdrop maximize-inactive "$bginactive"

asset2xwfm minimize hide-active "$bgactive"
asset2xwfm minimize-hover hide-prelight "$bgactive"
asset2xwfm minimize-active hide-pressed "$bgactive"
asset2xwfm minimize-backdrop hide-inactive "$bginactive"

asset2xwfm maximize-maximized maximize-toggled-active "$bgactive"
asset2xwfm maximize-maximized-hover maximize-toggled-prelight "$bgactive"
asset2xwfm maximize-maximized-active maximize-toggled-pressed "$bgactive"
asset2xwfm maximize-maximized-backdrop maximize-toggled-inactive "$bginactive"

function xfwm2xpm ()
{
  convert "xfwm4/src/$1.png" -background "$3" -alpha remove "xfwm4/$2.xpm"
}

xfwm2xpm shade shade-active "$bgactive"
xfwm2xpm shade-hover shade-prelight "$bgactive"
xfwm2xpm shade-active shade-pressed "$bgactive"
xfwm2xpm shade-backdrop shade-inactive "$bginactive"

xfwm2xpm shade-toggled shade-toggled-active "$bgactive"
xfwm2xpm shade-toggled-hover shade-toggled-prelight "$bgactive"
xfwm2xpm shade-toggled-active shade-toggled-pressed "$bgactive"
xfwm2xpm shade-toggled-backdrop shade-toggled-inactive "$bginactive"

xfwm2xpm stick stick-active "$bgactive"
xfwm2xpm stick-hover stick-prelight "$bgactive"
xfwm2xpm stick-active stick-pressed "$bgactive"
xfwm2xpm stick-backdrop stick-inactive "$bginactive"

xfwm2xpm stick-toggled stick-toggled-active "$bgactive"
xfwm2xpm stick-toggled-hover stick-toggled-prelight "$bgactive"
xfwm2xpm stick-toggled-active stick-toggled-pressed "$bgactive"
xfwm2xpm stick-toggled-backdrop stick-toggled-inactive "$bginactive"

# Update primary colors in theme files
sed -i -e 's/3daee9/708080/g' gtk-2.0/gtkrc
find . -type f -name '*.css' -exec sed -i -e 's/3daee9/708080/g' {} \;
find . -type f -name '*.css' -exec sed -i -e 's/2980b9/a2d5bb/g' {} \;
find . -type f -name '*.css' -exec sed -i -e 's/61, 174, 233, 0.5/112, 144, 128, 0.8/g' {} \;

# Update gradient colors
find . -type f -name '*.css' -exec sed -i -e 's/45b1ea/8aa597/g' {} \;
find . -type f -name '*.css' -exec sed -i -e 's/25a4e6/769585/g' {} \;
find . -type f -name '*.css' -exec sed -i -e 's/37, 164, 230/118, 149, 133/g' {} \;
find . -type f -name '*.css' -exec sed -i -e 's/44, 167, 231/122, 153, 137/g' {} \;
find . -type f -name '*.css' -exec sed -i -e 's/25, 152, 218/106, 137, 122/g' {} \;

# Update tab border color
find . -type f -name '*.css' -exec sed -i -e 's/61, 174, 233/133, 161, 147/g' {} \;

# Desaturate background colors
sed -i -e 's/31363b/363636/g' gtk-2.0/gtkrc
find . -type f -name '*.css' -exec sed -i -e 's/31363b/363636/g' {} \;
sed -i -e 's/232629/262626/g' gtk-2.0/gtkrc
find . -type f -name '*.css' -exec sed -i -e 's/232629/262626/g' {} \;

# Write new file metadata
sed -i 's/Breeze-gtk/Zephyr-gtk/' gtk-2.0/gtkrc
sed -i '2s/.*/# Description: Zephyr theme based on Breeze Dark for GTK+2.0/' gtk-2.0/gtkrc

# vim: set expandtab:shiftwidth=2:softtabstop=2

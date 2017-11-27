#!/bin/bash
# Convert the original Breeze Dark theme to Zephyr colors
# This theme uses a base color of #709080 with a ligher active color #a2d5bb

# Exit on errors
set -e

# Recolor PNG assets
# This moves non-primary-color files to another directory temporarily
if [ ! -f assets/.converted ]; then
  mkdir -p assets-tmp
  mv assets/titlebutton-close*active* assets-tmp
  mv assets/titlebutton-close*hover* assets-tmp
  mogrify -modulate 100,41,72 assets/*.png
  mv assets-tmp/* assets/
  rmdir assets-tmp
  touch assets/.converted
fi

# Build Xfwm theme button images
bgactive='#709080'
bginactive='#363636'
function asset2xwfm ()
{
  convert "assets/$1.png" -background "$3" -alpha remove "xfwm4/$2.xpm"
}
asset2xwfm titlebutton-close close-active "$bgactive"
asset2xwfm titlebutton-close-hover close-prelight "$bgactive"
asset2xwfm titlebutton-close-active close-pressed "$bgactive"
asset2xwfm titlebutton-close-backdrop close-inactive "$bginactive"

asset2xwfm titlebutton-maximize maximize-active "$bgactive"
asset2xwfm titlebutton-maximize-hover maximize-prelight "$bgactive"
asset2xwfm titlebutton-maximize-active maximize-pressed "$bgactive"
asset2xwfm titlebutton-maximize-backdrop maximize-inactive "$bginactive"

asset2xwfm titlebutton-minimize hide-active "$bgactive"
asset2xwfm titlebutton-minimize-hover hide-prelight "$bgactive"
asset2xwfm titlebutton-minimize-active hide-pressed "$bgactive"
asset2xwfm titlebutton-minimize-backdrop hide-inactive "$bginactive"

asset2xwfm titlebutton-maximize-maximized maximize-toggled-active "$bgactive"
asset2xwfm titlebutton-maximize-maximized-hover maximize-toggled-prelight "$bgactive"
asset2xwfm titlebutton-maximize-maximized-active maximize-toggled-pressed "$bgactive"
asset2xwfm titlebutton-maximize-maximized-backdrop maximize-toggled-inactive "$bginactive"

# Update primary colors in theme files
sed -i -e 's/3daee9/708080/g' gtk-2.0/gtkrc
find . -type f -name '*.css' -exec sed -i -e 's/3daee9/708080/g' {} \;
find . -type f -name '*.css' -exec sed -i -e 's/2980b9/a2d5bb/g' {} \;
find . -type f -name '*.css' -exec sed -i -e 's/61, 174, 233, 0.5/112, 144, 128, 0.8/g' {} \;

# Desaturate background colors
sed -i -e 's/31363b/363636/g' gtk-2.0/gtkrc
find . -type f -name '*.css' -exec sed -i -e 's/31363b/363636/g' {} \;
sed -i -e 's/232629/262626/g' gtk-2.0/gtkrc
find . -type f -name '*.css' -exec sed -i -e 's/232629/262626/g' {} \;

# Write new file metadata
sed -i 's/Breeze-gtk/Zephyr-gtk/' gtk-2.0/gtkrc
sed -i '2s/.*/# Description: Zephyr theme based on Breeze Dark for GTK+2.0/' gtk-2.0/gtkrc

# vim: set expandtab:shiftwidth=2:softtabstop=2

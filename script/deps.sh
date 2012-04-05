#! /bin/bash

Echo "# Install docsplit dependencies.."

echo "Installing graphicsmagick..."
brew install graphicsmagick --use-clang

echo "Installing poppler"
brew install poppler

echo "Installing tesseract"
brew install tesseract

echo "Installing ghost script"
brew install ghostscript

echo "Now you're going to have to go manually install pdftk: http://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/"
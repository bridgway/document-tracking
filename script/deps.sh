#! /bin/bash

Echo "# Install docsplit dependencies.."

echo "Installing graphicsmagick..."
brew install graphicsmagick --use-clang

echo "Installing poppler"
brew install poppler

echo "Installing tesseract"
brew install tesseract

echo "Installing pdftk"
brew install pdftk

#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../my-react-app" && pwd)"
BUILD_DIR="$PROJECT_DIR/dist"
DEPLOY_DIR="$(cd "$SCRIPT_DIR/.." && pwd)/.ci-deploy/ReactApp"
BACKUP_DIR="$(cd "$SCRIPT_DIR/.." && pwd)/.ci-deploy/Backups/$(date +%Y-%m-%d_%H%M%S)"

echo "Installing dependencies..."
cd "$PROJECT_DIR"
npm install --no-audit --no-fund

echo "Building React project..."
npm run build

if [ -d "$DEPLOY_DIR" ]; then
  echo "Backing up old version..."
  mkdir -p "$BACKUP_DIR"
  cp -R "$DEPLOY_DIR"/. "$BACKUP_DIR"/
fi

echo "Deploying new version..."
rm -rf "$DEPLOY_DIR"
mkdir -p "$DEPLOY_DIR"
cp -R "$BUILD_DIR"/. "$DEPLOY_DIR"/

echo "Deployment completed: $DEPLOY_DIR"

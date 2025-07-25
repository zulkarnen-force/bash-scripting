#!/bin/bash

set -e

# --- Usage Info ---
if [ "$#" -ne 4 ]; then
  echo "Usage: $0 <source_image> <new_tag> <env_file> <target_path>"
  echo "Example: $0 pckg.muhammadiyah.or.id/paymu:0.0.14 k8s-0.0.14 env_pay_k8s /var/www/html"
  exit 1
fi

# --- Parameters ---
SOURCE_IMAGE="$1"     # e.g., pckg.muhammadiyah.or.id/paymu:0.0.14
NEW_TAG="$2"          # e.g., k8s-0.0.14
ENV_FILE="$3"         # e.g., env_pay_k8s
TARGET_PATH="$4"      # e.g., /var/www/html or /app

# --- Derived ---
IMAGE_NAME=$(echo "$SOURCE_IMAGE" | cut -d':' -f1)
NEW_IMAGE="$IMAGE_NAME:$NEW_TAG"
TEMP_CONTAINER="tmp_env_update_$$"

# --- Validate .env source ---
if [ ! -f "$ENV_FILE" ]; then
  echo "❌ ERROR: .env file '$ENV_FILE' does not exist."
  exit 1
fi

# --- Actions ---
echo "==> Creating container from $SOURCE_IMAGE..."
docker create --name "$TEMP_CONTAINER" "$SOURCE_IMAGE"

echo "==> Copying $ENV_FILE to $TARGET_PATH/.env in container..."
docker cp "$ENV_FILE" "$TEMP_CONTAINER:$TARGET_PATH/.env"

echo "==> Committing container as new image: $NEW_IMAGE"
docker commit "$TEMP_CONTAINER" "$NEW_IMAGE"

echo "==> Pushing new image to registry..."
docker push "$NEW_IMAGE"

echo "==> Cleaning up..."
docker rm "$TEMP_CONTAINER"

echo "✅ Done. New image with updated .env pushed: $NEW_IMAGE"

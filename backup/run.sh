#!/bin/sh
set -eu

STAMP=$(date +"%Y%m%d-%H%M%S")
BACKUP_DIR=/backups/$STAMP
mkdir -p "$BACKUP_DIR"

# Database dump
mysqldump -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" --single-transaction --routines --events "$DB_NAME" \
  | gzip -9 > "$BACKUP_DIR/db.sql.gz"

# wp-content archive (plugins, themes, uploads)
mkdir -p /tmp/backup
cd /data
tar -czf "$BACKUP_DIR/wp-content.tgz" wp-content

# Optional: keep a small manifest for sanity checks
cat <<EOF > "$BACKUP_DIR/manifest.txt"
DATE=$STAMP
DB_NAME=$DB_NAME
FILES=wp-content.tgz
EOF

# Retention policy
find /backups -maxdepth 1 -type d -mtime +"${RETENTION_DAYS:-14}" -exec rm -rf {} + 2>/dev/null || true

echo "Backup completed: $BACKUP_DIR"

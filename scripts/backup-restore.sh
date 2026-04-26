#!/bin/bash
# OpenClaw Doctor - Backup & Restore Script
# 备份与恢复脚本

set -e

BACKUP_DIR="$HOME/.openclaw-backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

show_help() {
    echo "OpenClaw Backup & Restore Tool"
    echo ""
    echo "Usage: $0 <command> [options]"
    echo ""
    echo "Commands:"
    echo "  backup              Create a backup of OpenClaw configuration"
    echo "  restore <backup>    Restore from a backup"
    echo "  list                List available backups"
    echo "  clean               Remove old backups (keep last 10)"
    echo ""
    echo "Examples:"
    echo "  $0 backup"
    echo "  $0 restore 20260427_120000"
    echo "  $0 list"
    exit 0
}

backup() {
    echo "🔄 Creating OpenClaw backup..."
    echo ""
    
    # Create backup directory
    mkdir -p "$BACKUP_DIR"
    
    BACKUP_NAME="openclaw_backup_${TIMESTAMP}"
    BACKUP_PATH="$BACKUP_DIR/$BACKUP_NAME"
    
    mkdir -p "$BACKUP_PATH"
    
    # Backup config file
    if [ -f ~/.openclaw/openclaw.json ]; then
        echo "📄 Backing up openclaw.json..."
        cp ~/.openclaw/openclaw.json "$BACKUP_PATH/"
    else
        echo -e "${YELLOW}⚠️  openclaw.json not found${NC}"
    fi
    
    # Backup skills
    if [ -d ~/.openclaw/skills ]; then
        echo "📚 Backing up skills..."
        cp -r ~/.openclaw/skills "$BACKUP_PATH/"
    fi
    
    # Backup custom plugins (if any)
    if [ -d ~/.openclaw/plugins ]; then
        echo "🔌 Backing up custom plugins..."
        cp -r ~/.openclaw/plugins "$BACKUP_PATH/"
    fi
    
    # Create metadata
    cat > "$BACKUP_PATH/metadata.txt" << METADATA
Backup created: $(date)
Hostname: $(hostname)
OpenClaw version: $(openclaw --version 2>/dev/null || echo "unknown")
Node version: $(node --version 2>/dev/null || echo "unknown")
METADATA
    
    # Create archive
    echo "📦 Creating archive..."
    cd "$BACKUP_DIR"
    tar -czf "${BACKUP_NAME}.tar.gz" "$BACKUP_NAME"
    rm -rf "$BACKUP_NAME"
    
    echo ""
    echo -e "${GREEN}✅ Backup created successfully!${NC}"
    echo "Location: $BACKUP_DIR/${BACKUP_NAME}.tar.gz"
    echo "Size: $(du -h "$BACKUP_DIR/${BACKUP_NAME}.tar.gz" | awk '{print $1}')"
    echo ""
}

restore() {
    local backup_name="$1"
    
    if [ -z "$backup_name" ]; then
        echo -e "${RED}❌ Error: Backup name required${NC}"
        echo "Usage: $0 restore <backup_name>"
        echo ""
        echo "Available backups:"
        list
        exit 1
    fi
    
    BACKUP_FILE="$BACKUP_DIR/openclaw_backup_${backup_name}.tar.gz"
    
    if [ ! -f "$BACKUP_FILE" ]; then
        echo -e "${RED}❌ Error: Backup not found: $BACKUP_FILE${NC}"
        exit 1
    fi
    
    echo "🔄 Restoring from backup: $backup_name"
    echo ""
    
    # Confirm
    read -p "This will overwrite current configuration. Continue? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Restore cancelled"
        exit 0
    fi
    
    # Create safety backup of current state
    echo "📦 Creating safety backup of current state..."
    SAFETY_BACKUP="$BACKUP_DIR/pre_restore_${TIMESTAMP}.tar.gz"
    cd ~/.openclaw
    tar -czf "$SAFETY_BACKUP" . 2>/dev/null || true
    echo "Safety backup: $SAFETY_BACKUP"
    echo ""
    
    # Extract backup
    echo "📂 Extracting backup..."
    TEMP_DIR=$(mktemp -d)
    tar -xzf "$BACKUP_FILE" -C "$TEMP_DIR"
    
    # Restore files
    EXTRACTED_DIR="$TEMP_DIR/openclaw_backup_${backup_name}"
    
    if [ -f "$EXTRACTED_DIR/openclaw.json" ]; then
        echo "📄 Restoring openclaw.json..."
        cp "$EXTRACTED_DIR/openclaw.json" ~/.openclaw/
        chmod 600 ~/.openclaw/openclaw.json
    fi
    
    if [ -d "$EXTRACTED_DIR/skills" ]; then
        echo "📚 Restoring skills..."
        rm -rf ~/.openclaw/skills
        cp -r "$EXTRACTED_DIR/skills" ~/.openclaw/
    fi
    
    if [ -d "$EXTRACTED_DIR/plugins" ]; then
        echo "🔌 Restoring custom plugins..."
        rm -rf ~/.openclaw/plugins
        cp -r "$EXTRACTED_DIR/plugins" ~/.openclaw/
    fi
    
    # Cleanup
    rm -rf "$TEMP_DIR"
    
    echo ""
    echo -e "${GREEN}✅ Restore completed successfully!${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Restart Gateway: pkill -f openclaw-gateway && openclaw-gateway &"
    echo "  2. Verify configuration: cat ~/.openclaw/openclaw.json"
    echo ""
}

list() {
    echo "📋 Available backups:"
    echo ""
    
    if [ ! -d "$BACKUP_DIR" ] || [ -z "$(ls -A "$BACKUP_DIR"/*.tar.gz 2>/dev/null)" ]; then
        echo "No backups found"
        return
    fi
    
    for backup in "$BACKUP_DIR"/*.tar.gz; do
        if [ -f "$backup" ]; then
            FILENAME=$(basename "$backup")
            SIZE=$(du -h "$backup" | awk '{print $1}')
            DATE=$(echo "$FILENAME" | grep -o '[0-9]\{8\}_[0-9]\{6\}')
            FORMATTED_DATE=$(echo "$DATE" | sed 's/\([0-9]\{4\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)_\([0-9]\{2\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)/\1-\2-\3 \4:\5:\6/')
            
            echo "  • $DATE"
            echo "    Date: $FORMATTED_DATE"
            echo "    Size: $SIZE"
            echo "    File: $FILENAME"
            echo ""
        fi
    done
    
    echo "To restore: $0 restore <backup_date>"
    echo ""
}

clean() {
    echo "🧹 Cleaning old backups..."
    echo ""
    
    if [ ! -d "$BACKUP_DIR" ]; then
        echo "No backup directory found"
        return
    fi
    
    BACKUP_COUNT=$(ls -1 "$BACKUP_DIR"/*.tar.gz 2>/dev/null | wc -l)
    
    if [ "$BACKUP_COUNT" -le 10 ]; then
        echo "Only $BACKUP_COUNT backups found. Keeping all."
        return
    fi
    
    echo "Found $BACKUP_COUNT backups. Keeping last 10..."
    
    ls -t "$BACKUP_DIR"/*.tar.gz | tail -n +11 | while read backup; do
        echo "Removing: $(basename "$backup")"
        rm "$backup"
    done
    
    echo ""
    echo -e "${GREEN}✅ Cleanup completed${NC}"
    echo ""
}

# Main
case "${1:-}" in
    backup)
        backup
        ;;
    restore)
        restore "$2"
        ;;
    list)
        list
        ;;
    clean)
        clean
        ;;
    --help|-h|"")
        show_help
        ;;
    *)
        echo "Unknown command: $1"
        echo ""
        show_help
        ;;
esac

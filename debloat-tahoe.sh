#!/bin/bash
# ============================================================
# macOS 26 Tahoe - ULTIMATE Bloat Removal Script (v2.0)
# Run this in Recovery Mode Terminal AFTER disabling SIP
# ============================================================

# ---- CONFIGURATION ----
# Uncomment (remove #) any item you want to DELETE.
# Comment (add #) any item you want to KEEP.

APPS_TO_DELETE=(
    # --- Media & Entertainment ---
    "TV.app"
    "Podcasts.app"
    "Music.app"
    "Books.app"
    "News.app"
    "Stocks.app"
    "Home.app"
    "Photo Booth.app"
    
    # --- Lifestyle & Utilities ---
    "Maps.app"
    "Contacts.app"
    "Calendar.app"
    "Notes.app"
    "Reminders.app"
    "Shortcuts.app"
    "Voice Memos.app"
    "Calculator.app"
    "Clock.app"
    "Compass.app"
    "Measure.app"
    "Find My.app"
    "Freeform.app"
    
    # --- Games ---
    "Chess.app"
    "Game Center.app"
    
    # --- Creative ---
    "iMovie.app"
    
    # --- Optional: Uncomment to delete ---
    # "GarageBand.app"
    # "FaceTime.app"
    # "Messages.app"
    # "Safari.app"  # DANGER: Only if you have another browser
)

DAEMONS_TO_DELETE=(
    # --- CORE SYSTEM & INDEXING ---
    "com.apple.mds.plist"
    "com.apple.mds_stores.plist"
    "com.apple.corespotlightd.plist"

    # --- TIME MACHINE ---
    "com.apple.backupd.plist"
    "com.apple.backupd-helper.plist"

    # --- SIRI & VOICE STACK ---
    "com.apple.siri.acquisition.plist"
    "com.apple.sirittsd.plist"
    "com.apple.siriactionsd.plist"
    "com.apple.siriknowledged.plist"
    "com.apple.assistantd.plist"
    "com.apple.heard.plist"
    "com.apple.corespeechd.plist"
    "com.apple.naturallanguaged.plist"

    # --- APPLE INTELLIGENCE & AI PLATFORM ---
    "com.apple.intelligencecontextd.plist"
    "com.apple.intelligenceplatformd.plist"
    "com.apple.generativeexperiencesd.plist"
    "com.apple.aned.plist"              # NEW: Neural Engine Daemon
    "com.apple.aneuserd.plist"          # NEW: ANE User Daemon
    "com.apple.modelcatalogd.plist"     # NEW: AI Model Catalog
    "com.apple.modelmanagerd.plist"     # NEW: AI Model Manager
    "com.apple.ospredictiond.plist"     # NEW: OS Prediction

    # --- PRIVACY & TELEMETRY (The "Spy" Layer) ---
    "com.apple.analyticsd.plist"
    "com.apple.reportcrashd.plist"
    "com.apple.amsengagementd.plist"
    "com.apple.adid.plist"              # NEW: Device ID Telemetry
    "com.apple.applessdstatistics.plist" # NEW: App Store Stats
    "com.apple.bosreporter.plist"       # NEW: Boot Opt Telemetry
    "com.apple.boswatcher.plist"        # NEW: Boot Opt Watcher
    "com.apple.contextstored.plist"     # NEW: Context Storage
    "com.apple.dprivacyd.plist"         # NEW: Differential Privacy
    "com.apple.ecosystemanalyticsd.plist" # NEW: Ecosystem Tracking
    "com.apple.historicalaudiod.plist"  # NEW: Audio History
    "com.apple.perfpowermetricd.plist"  # NEW: Perf/Power Metrics
    "com.apple.powerexperiencedd.plist" # NEW: Power Experience
    "com.apple.rtcreportingd.plist"     # NEW: RTC Reporting
    "com.apple.symptomsd.plist"         # NEW: System Symptoms
    "com.apple.triald.system.plist"     # NEW: A/B Testing
    "com.apple.wifianalyticsd.plist"    # NEW: WiFi Analytics
    "com.apple.audioanalyticsd.plist"   # NEW: Audio Analytics
    "com.apple.biomed.plist"            # NEW: Biometric Data

    # --- SMART FEATURES & PREDICTION ---
    "com.apple.duetexpertd.plist"
    "com.apple.knowledgeconstructiond.plist"
    "com.apple.suggestd.plist"
    "com.apple.photoanalysisd.plist"
    "com.apple.studentd.plist"
    "com.apple.applespell.plist"
    "com.apple.homeenergyd.plist"
    "com.apple.financed.plist"

    # --- GAME CENTER ---
    "com.apple.gamed.plist"
    "com.apple.gamecenterd.plist"

    # --- ASSET CACHE ---
    "com.apple.AssetCacheLocatorService.plist"
    "com.apple.AssetCacheManager.plist"

    # --- CONDITIONAL: Read before uncommenting ---
    # "com.apple.rapportd.plist"         # BREAKS: AirDrop, Handoff, Universal Clipboard
    # "com.apple.nearbyd.plist"          # BREAKS: Nearby Discovery (Handoff/AirDrop)
    # "com.apple.icloud.searchpartyd.plist" # BREAKS: Find My Network
    # "com.apple.attentionawarenessd.plist" # BREAKS: FaceID Attention (Screen on)
    # "com.apple.handwritingd.plist"     # BREAKS: Handwriting Recognition
    # "com.apple.fairplayd.plist"        # BREAKS: DRM (Apple Music/TV)
    # "com.apple.photolibraryd.plist"    # BREAKS: Photos app entirely
    # "com.apple.remindd.plist"          # BREAKS: Reminders app
)

LAUNCH_AGENTS_TO_DELETE=(
    "com.apple.siri.acquisition.plist"
    "com.apple.sirittsd.plist"
    "com.apple.siriactionsd.plist"
    "com.apple.siriknowledged.plist"
    "com.apple.assistantd.plist"
)

INTELLIGENCE_DIRS_TO_DELETE=(
    "com_apple_MobileAsset_UAF_FM_GenerativeModels"
    "com_apple_MobileAsset_UAF_FM_Visual"
)

# ---- COLORS & LOGGING ----
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

LOG_FILE="/tmp/tahoe-cleanup-$(date +%Y%m%d-%H%M%S).log"

DELETED_COUNT=0
SKIPPED_COUNT=0
FAILED_COUNT=0

# ---- FUNCTIONS ----
delete_item() {
    local item_path="$1"
    local item_type="$2"
    
    if [ -e "$item_path" ] || [ -L "$item_path" ]; then
        if rm -rf "$item_path" >>"$LOG_FILE" 2>&1; then
            echo -e "  ${GREEN}✓ Deleted${NC} $item_type: $(basename "$item_path")"
            ((DELETED_COUNT++))
        else
            echo -e "  ${RED}✗ Failed${NC} $item_type: $(basename "$item_path")"
            ((FAILED_COUNT++))
        fi
    else
        echo -e "  ${YELLOW}⊘ Skipped${NC} $item_type: $(basename "$item_path") (Not found)"
        ((SKIPPED_COUNT++))
    fi
}

# ---- MAIN SCRIPT ----

echo ""
echo "============================================================"
echo "  macOS 26 Tahoe - ULTIMATE Bloat Removal (v2.0)"
echo "============================================================"
echo ""

# 1. Check SIP
SIP_STATUS=$(csrutil status 2>&1)
if echo "$SIP_STATUS" | grep -qi "enabled"; then
    echo -e "${RED}ERROR: SIP is still ENABLED.${NC}"
    echo "Run: csrutil disable"
    echo "Then run this script again."
    exit 1
fi
echo -e "${GREEN}[OK] SIP is disabled${NC}"

# 2. Mount Data Volume
echo ""
echo "Mounting Data volume..."
diskutil mount "Macintosh HD - Data" 2>/dev/null

DATA_PATH="/System/Volumes/Data"
if [ ! -d "$DATA_PATH" ]; then
    echo -e "${RED}ERROR: Data volume not found at $DATA_PATH${NC}"
    echo "Please ensure 'Macintosh HD - Data' is mounted."
    exit 1
fi
echo -e "${GREEN}[OK] Data volume mounted${NC}"

# 3. Delete Launch Daemons
echo ""
echo "---- Deleting Launch Daemons ----"
DAEMONS_DIR="$DATA_PATH/System/Library/LaunchDaemons"
for plist in "${DAEMONS_TO_DELETE[@]}"; do
    delete_item "$DAEMONS_DIR/$plist" "daemon"
done

# 4. Delete Launch Agents
echo ""
echo "---- Deleting Launch Agents ----"
AGENTS_DIR="$DATA_PATH/System/Library/LaunchAgents"
for plist in "${LAUNCH_AGENTS_TO_DELETE[@]}"; do
    delete_item "$AGENTS_DIR/$plist" "agent"
done

# 5. Delete Apps
echo ""
echo "---- Deleting Apps ----"
APPS_DIR="$DATA_PATH/System/Applications"
for app in "${APPS_TO_DELETE[@]}"; do
    delete_item "$APPS_DIR/$app" "app"
done

# 6. Delete Apple Intelligence Models
echo ""
echo "---- Deleting Apple Intelligence Models ----"
ASSETS_DIR="$DATA_PATH/System/Library/AssetsV2"
for dir in "${INTELLIGENCE_DIRS_TO_DELETE[@]}"; do
    delete_item "$ASSETS_DIR/$dir" "AI Model"
done

# 7. Sanity Check
echo ""
echo "---- Sanity Check ----"
CRITICAL_APPS=("Finder.app" "System Settings.app" "Terminal.app" "Preview.app" "Disk Utility.app")
MISSING_CRITICAL=false
for app in "${CRITICAL_APPS[@]}"; do
    if [ ! -e "$APPS_DIR/$app" ]; then
        echo -e "${RED}⚠ WARNING: $app is MISSING!${NC}"
        MISSING_CRITICAL=true
    fi
done

if [ "$MISSING_CRITICAL" = true ]; then
    echo -e "${RED}CRITICAL ERROR: Essential apps are missing. Do not reboot yet!${NC}"
    echo "Restore from backup or check your script configuration."
    exit 1
else
    echo -e "${GREEN}[OK] All critical apps intact.${NC}"
fi

# 8. Summary
echo ""
echo "============================================================"
echo "  SUMMARY"
echo "============================================================"
echo -e "  ${GREEN}Deleted:${NC}  $DELETED_COUNT items"
echo -e "  ${YELLOW}Skipped:${NC}  $SKIPPED_COUNT items (already gone)"
echo -e "  ${RED}Failed:${NC}   $FAILED_COUNT items"
echo ""
echo "  Log saved to: $LOG_FILE"
echo ""

# 9. Final Instructions
echo "============================================================"
echo -e "${YELLOW}NEXT STEPS:${NC}"
echo "  1. Run: csrutil enable"
echo "  2. Run: reboot"
echo "============================================================"
echo ""

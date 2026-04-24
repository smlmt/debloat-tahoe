# macOS 26 (Tahoe) - Ultimate Privacy & Bloat Removal Script

> ⚠️ **WARNING: This script is aggressive and irreversible.**  
> It permanently deletes system daemons, applications, and AI models.  
> **Use at your own risk.** A full backup is mandatory before proceeding.

This script is designed for users who want to transform their macOS 26 (Tahoe) installation into a lean, privacy-focused, local-only workstation. It removes Apple Intelligence, telemetry daemons, unused system apps, and Time Machine local snapshots to reclaim **storage space** and **RAM**.

It is particularly optimized for **Apple Silicon (A18 Pro, M-series)** devices where background AI processes consume significant resources.

## What This Script Removes

### 1. Apple Intelligence & AI Stack
Removes the core "brain" of Apple's on-device AI, freeing up ~8-9 GB of storage and stopping background ML processing.
- `intelligenceplatformd`, `generativeexperiencesd`, `intelligencecontextd`
- `aned`, `aneuserd`, `modelcatalogd`, `modelmanagerd`
- Apple Intelligence Model files (`MobileAsset_UAF_FM_*`)

### 2. Privacy & Telemetry Daemons
Stops the system from profiling your usage, sending diagnostics, or building knowledge graphs.
- `analyticsd`, `dprivacyd`, `ecosystemanalyticsd`, `adid`
- `siriknowledged`, `knowledgeconstructiond`, `contextstored`
- `transparencyd` (Note: Kept by default, see config)

### 3. Siri & Voice Processing
Disables all voice recognition and Siri background services.
- `siri.acquisition`, `sirittsd`, `siriactionsd`, `heard`, `rapportd`
- `corespeechd`, `naturallanguaged`, `assistantd`

### 4. System Bloat & Unused Apps
Deletes pre-installed apps you likely never use.
- **Media:** TV, Podcasts, Music, Books, News, Stocks, Home, Photo Booth
- **Utilities:** Maps, Contacts, Calendar, Notes, Reminders, Shortcuts, Voice Memos
- **Games:** Chess, Game Center
- **Creative:** iMovie (GarageBand is kept by default, but can be toggled)

### 5. Time Machine Local Snapshots
Automatically deletes existing local snapshots that eat up disk space.

## What This Script Preserves

To ensure your system remains bootable and functional, the following are **NEVER** touched:
- **Core System:** Finder, System Settings, Terminal, Preview, Disk Utility, Safari (unless manually uncommented).
- **Critical Drivers:** Bluetooth, WiFi, Audio, Graphics, USB.
- **Security:** FileVault, Secure Enclave, Gatekeeper, XProtect.
- **Communication:** Messages, FaceTime (unless manually uncommented).
- **Productivity:** Photos (unless `photolibraryd` is manually removed), Mail, Contacts (unless app is removed).

## Requirements

- **OS:** macOS 26 (Tahoe) or later.
- **Hardware:** Apple Silicon (M1/M2/M3/A18 Pro) recommended. Intel Macs may require path adjustments.
- **Permissions:** Administrator access.
- **Backup:** **Time Machine backup or full disk clone is REQUIRED.**
- **USB Drive:** To transfer the script to Recovery Mode (optional but recommended).

## Installation & Usage

### Step 1: Prepare the Script
1. Download `cleanup.sh` to your Mac.
2. Open the script in a text editor.
3. **Review the Configuration Section:**
   - Remove the `#` from any app or daemon you want to **DELETE**.
   - Add a `#` in front of any app or daemon you want to **KEEP**.
   - *Default settings are aggressive. Adjust to your needs.*

### Step 2: Backup Your Data
Run Time Machine or clone your drive. **Do not skip this.** If you delete the wrong file, you may need to reinstall macOS.

### Step 3: Boot into Recovery Mode
1. **Shut down** your Mac completely.
2. **Apple Silicon (M1/M2/A18):** Press and hold the **Power Button** until "Loading Startup Options" appears.
3. **Intel Macs:** Restart and immediately hold **Command (⌘) + R**.
4. Select **Options** > **Continue**.
5. Select your user and enter your password.

### Step 4: Disable System Integrity Protection (SIP)
1. In the Recovery menu bar, go to **Utilities** > **Terminal**.
2. Run:

   ```bash
   csrutil disable
   ```

3. Verify it worked:

   ```bash
   csrutil status
   ```

   *(Output should say "System Integrity Protection: disabled")*

### Step 5: Run the Script
1. **Mount your USB drive** (if using one) or copy the script to the Recovery Desktop.
2. Navigate to the script location:

   ```bash
   cd /Volumes/YourUSBName
   ```

3. Make it executable:

   ```bash
   chmod +x cleanup.sh
   ```

4. Run the script:

   ```bash
   ./cleanup.sh
   ```

   *The script will prompt you to mount the Data volume. Enter your user password when asked.*

### Step 6: Re-enable SIP & Reboot
Once the script finishes and shows the summary:
1. Re-enable SIP (Critical for security):

   ```bash
   csrutil enable
   ```

2. Reboot:

   ```bash
   reboot
   ```

## Expected Results

| Metric | Before Cleanup | After Cleanup |
| :--- | :--- | :--- |
| **Storage Freed** | ~18-20 GB (System Data) | ~8-12 GB (Lean System) |
| **RAM Usage** | High (Background AI/Siri) | Low (Only essential services) |
| **Running Daemons** | 50+ | ~20-25 |
| **Privacy** | Low (Telemetry active) | High (Local-only) |

## ⚠️ Known Limitations & Risks

- **Irreversible:** Deleted daemons and apps cannot be restored without reinstalling macOS.
- **Updates:** Major macOS updates (e.g., 26.1) may restore some deleted files. You may need to re-run the script after updates.
- **Features Lost:**
  - No Siri, no "Hey Siri".
  - No Spotlight file search (only app search).
  - No Time Machine local snapshots (external drive backups still work if configured).
  - No AirDrop/Handoff (if `rapportd` is removed).
  - No "Memories" in Photos (if `photoanalysisd` is removed).
- **FileVault:** You must enter your password to unlock the drive in Recovery Mode.

## Troubleshooting

- **"Operation not permitted"**: Ensure SIP is disabled (`csrutil disable`).
- **"Data volume not found"**: Ensure you are in Recovery Mode and the volume is mounted.
- **System won't boot**: Boot into Recovery, re-enable SIP, and restore from backup.
- **App crashes**: If an app crashes, it likely depends on a removed daemon. Re-run the script and comment out that specific daemon.

## Contributing

Found a bug? Have a suggestion for a new daemon to remove?
1. Fork the repository.
2. Create a branch.
3. Submit a Pull Request.

Please test thoroughly on a non-production machine before merging.

## License

MIT License. Use at your own risk. The author is not responsible for data loss or system instability.

---

**Disclaimer:** This script modifies system files. Proceed only if you understand the risks. Always maintain a backup.

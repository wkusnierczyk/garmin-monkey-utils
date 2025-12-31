# ================= CONFIGURATION =================
# Path to your Connect IQ SDK
SDK_HOME ?= /Users/waku/Library/Application_Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-8.4.0-2025-12-03-5122605dc
SDK_BIN := $(SDK_HOME)/bin

# JAR Location
MONKEYBRAINS_JAR := "$(SDK_BIN)/monkeybrains.jar"

# Path to your developer key (Required for tests)
DEV_KEY ?= ../garmin-keys/developer_key

# Device for testing
DEVICE ?= fenix7xpronowifi

# Output Files
BARREL_NAME := MonkeyUtils.barrel
TEST_PRG := test_runner.prg

# ================= COMMANDS =================
JAVA := java
MONKEYC := "$(SDK_BIN)/monkeyc"
MONKEYDO := "$(SDK_BIN)/monkeydo"

# ================= FLAGS =================
# 1. BARREL BUILD (Direct Java)
# Uses the standard monkey.jungle (Barrel Manifest)
BARREL_FLAGS := -Dfile.encoding=UTF-8 \
				-Dapple.awt.UIElement=true \
				-cp $(MONKEYBRAINS_JAR) \
				com.garmin.monkeybrains.MonkeyBarrelEntry \
				-o $(BARREL_NAME) \
				-f monkey.jungle \
				-w

# 2. TEST BUILD (Standard monkeyc)
# Uses monkey-test.jungle (Application Manifest) to satisfy the .prg builder
TEST_FLAGS := -w -y "$(DEV_KEY)" -d $(DEVICE) -f monkey-test.jungle --unit-test

.PHONY: all build test clean

all: build

# ----------------------------------------------------------------
# Build: Invokes the specific 'MonkeyBarrelEntry' Java class
# ----------------------------------------------------------------
build:
	@echo "----------------------------------------"
	@echo "Building Barrel: $(BARREL_NAME)"
	@$(JAVA) $(BARREL_FLAGS)
	@echo "Build complete: $(BARREL_NAME)"
	@echo "----------------------------------------"

# ----------------------------------------------------------------
# Test: Compiles PRG, Restarts Simulator, and Runs Tests
# ----------------------------------------------------------------
test:
	@echo "----------------------------------------"
	@echo "Building Unit Tests..."
	@$(MONKEYC) $(TEST_FLAGS) -o $(TEST_PRG)
	
	@echo "Restarting Simulator..."
	@killall ConnectIQ > /dev/null 2>&1 || true
	@sleep 1
	@"$(SDK_BIN)/connectiq" &
	@echo "Waiting for Simulator..."
	@sleep 5
	
	@echo "Running Tests..."
	@# 1. Run monkeydo
	@# 2. Pipe to 'tee /dev/tty' -> Prints full log to screen (so you see stack traces)
	@# 3. Pipe to 'grep' -> Prints the summary status line again at the very end
	@$(MONKEYDO) $(TEST_PRG) $(DEVICE) -t | tee /dev/tty | grep -q -E "PASSED|FAILED|Error"
	@echo "----------------------------------------"

clean:
	@rm -f $(BARREL_NAME) $(TEST_PRG) *.debug.xml
	@rm -rf bin/ deploy/ gen/ internal-mir/ external-mir/
	@echo "Clean complete."
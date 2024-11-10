import os

print("Starting Python App...")
feature_enabled = os.getenv("FEATURE_ENABLED", "false")

if feature_enabled.lower() == "true":
    print("Feature is ENABLED!")
    # Place feature-specific code here
else:
    print("Feature is DISABLED.")

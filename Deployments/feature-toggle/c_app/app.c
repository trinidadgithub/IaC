#include <stdio.h>
#include <stdlib.h>
#include <string.h> // Include this for strcmp

int main() {
    char *feature = getenv("FEATURE_ENABLED");

    printf("Starting C App...\n");
    if (feature && strcmp(feature, "true") == 0) {
        printf("Feature is ENABLED!\n");
        // Place feature-specific code here
    } else {
        printf("Feature is DISABLED.\n");
    }
    return 0;
}

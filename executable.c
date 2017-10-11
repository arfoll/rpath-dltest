#include <stdio.h>

#include "libnum.h"

int
main() {
    fprintf(stdout, "lib returned: %d\n", giveMeNum());
    return 0;
}

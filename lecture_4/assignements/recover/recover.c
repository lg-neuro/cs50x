#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

typedef uint8_t BYTE;
const int block = 512;

int main(int argc, char *argv[])
{
    // Accept a single command-line argument
    if (argc != 2)
    {
        printf("Usage: ./recover FILE\n");
        return 1;
    }

    // Open the memory card
    FILE *memory_card = fopen(argv[1], "r");
    if (memory_card == NULL)
    {
        printf("Could not open file.\n");
        return 1;
    }

    // Read 512 bytes while there's still data left in the memory card
    BYTE buffer[block];
    int i = 0;
    bool first_jpeg = false;
    char filename[9]; // Enough to contain ###.jpg and the '/0' (NUL character)
    FILE *img = NULL;

    while (fread(buffer, sizeof(BYTE), block, memory_card) == block)
    {
        // If start of a new `.jpg`
        if (buffer[0] == 0xff && buffer[1] == 0xd8 && buffer[2] == 0xff &&
            (buffer[3] & 0xf0) == 0xe0)
        // For the last boolean, this means 'take the first 4 bits and set the last 4 to 0'.
        {
            // If first `.jpg`, create new `.jpg` from the data
            if (first_jpeg == false)
            {
                first_jpeg = true;
                sprintf(filename, "%03i.jpg", i++);
                img = fopen(filename, "w");
                if (img == NULL)
                {
                    printf("Could not create a file.\n");
                    fclose(memory_card);
                    return 1;
                }
                fwrite(buffer, sizeof(BYTE), block, img);
            }
            // If not the first `.jpg`, close the current one and open another `.jpg` (with new
            // name)
            else
            {
                fclose(img);
                sprintf(filename, "%03i.jpg", i++);
                img = fopen(filename, "w");
                if (img == NULL)
                {
                    printf("Could not create a file.\n");
                    fclose(memory_card);
                    return 1;
                }
                fwrite(buffer, sizeof(BYTE), block, img);
            }
        }
        // If not the start of a new `.jpg`, continue to write
        else
        {
            if (img != NULL)
            {
                fwrite(buffer, sizeof(BYTE), block, img);
            }
        }
    }

    // Close any remaining open files
    if (img != NULL)
    {
        fclose(img);
    }

    // Close memory_card
    fclose(memory_card);
    return 0;
}

#include "helpers.h"
#include <math.h>

// Prototypes
BYTE cap(int byte);
RGBTRIPLE box_blur(int h, int w, int height, int width, RGBTRIPLE pixel[height][width]);

// Convert image to grayscale
void grayscale(int height, int width, RGBTRIPLE image[height][width])
{
    // For each pixel
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            // Calulate the average the RGB values
            BYTE avg =
                round((image[i][j].rgbtBlue + image[i][j].rgbtGreen + image[i][j].rgbtRed) / 3.0);

            // Set all the RGB for one pixel to the average
            image[i][j].rgbtBlue = (BYTE) avg;
            image[i][j].rgbtGreen = (BYTE) avg;
            image[i][j].rgbtRed = (BYTE) avg;
        }
    }
    return;
}

// Convert image to sepia
void sepia(int height, int width, RGBTRIPLE image[height][width])
{
    // For each pixel
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            // Set the RGB values to the new values after multiplying them for the "sepia
            // coefficiets"
            BYTE sepiaRed = cap(round(.393 * image[i][j].rgbtRed + .769 * image[i][j].rgbtGreen +
                                      .189 * image[i][j].rgbtBlue));
            BYTE sepiaGreen = cap(round(.349 * image[i][j].rgbtRed + .686 * image[i][j].rgbtGreen +
                                        .168 * image[i][j].rgbtBlue));
            BYTE sepiaBlue = cap(round(.272 * image[i][j].rgbtRed + .534 * image[i][j].rgbtGreen +
                                       .131 * image[i][j].rgbtBlue));
            image[i][j].rgbtBlue = (BYTE) sepiaBlue;
            image[i][j].rgbtGreen = (BYTE) sepiaGreen;
            image[i][j].rgbtRed = (BYTE) sepiaRed;
        }
    }
    return;
}

// Reflect image horizontally
void reflect(int height, int width, RGBTRIPLE image[height][width])
{
    // Take each pixel of the left half of the picture (as after that, we would obtain a two
    // specular right halfs of the original image)
    for (int i = 0; i < height; i++)
    {
        for (int j = 0, n = width / 2; j < n; j++)
        {
            // Store it in a temporary buffer
            RGBTRIPLE buffer = image[i][j];

            // Set the pixel on the left with its correspondig pixel to the right
            image[i][j] = image[i][width - 1 - j];

            // Set the pixels on the right with its corresponding pixel to the left which was
            // initially stored in the buffer
            image[i][width - 1 - j] = buffer;
        }
    }
}

// Blur image
void blur(int height, int width, RGBTRIPLE image[height][width])
{
    // Create a copy of the original image
    RGBTRIPLE copy[height][width];
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            copy[i][j] = image[i][j];
        }
    }

    // Set original image pixels to their blurred version (this won't impact the process as we take
    // the data from the copy and set them in the original)
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            image[i][j] = box_blur(i, j, height, width, copy);
        }
    }
    return;
}

// This function limits BYTE values to the range [0, 255] (`byte < 0` is not handled since BYTE type
// is an unsigned type, so it can't be negative.)
BYTE cap(int byte)
{
    if (byte > 255)
    {
        return 255;
    }
    else
        return byte;
}

// This function takes the 3x3 pixel box having the pixel of interest in the middle and set its RGB
// to the averages of the 9 pixel's RGBs. `int h`: height of the pixel of interest `int w`: width of
// the pixel of interest `int height`: height of the picture `int width`: width of the picture

RGBTRIPLE box_blur(int h, int w, int height, int width, RGBTRIPLE pixel[height][width])
{
    int valid_pixel = 0;

    int sumRed = 0;
    int sumGreen = 0;
    int sumBlue = 0;

    // Start considering the previous row and end with the following one
    for (int i = -1; i <= 1; i++)
    {
        // Start considering the previous row and end with the following one
        for (int j = -1; j <= 1; j++)
        {
            int new_h = h + i;
            int new_w = w + j;

            // Check if the pixels in the 3x3 box exists (since, we could be out of bounds)
            if (new_h >= 0 && new_h < height && new_w >= 0 && new_w < width)
            {
                // Sum each of the 3x3 R, G, and B values in their predisposed variable
                sumRed += pixel[new_h][new_w].rgbtRed;
                sumGreen += pixel[new_h][new_w].rgbtGreen;
                sumBlue += pixel[new_h][new_w].rgbtBlue;

                // Update counter if a pixel is valid
                valid_pixel++;
            }
        }
    }

    // Calculate the average for R, G, and B, store them in a variable and return it.
    // Typcasting the `sum-`s is necessary to prevent small rounding errors.
    RGBTRIPLE avg;
    avg.rgbtRed = cap(round((float) sumRed / (BYTE) valid_pixel));
    avg.rgbtGreen = cap(round((float) sumGreen / (BYTE) valid_pixel));
    avg.rgbtBlue = cap(round((float) sumBlue / (BYTE) valid_pixel));

    return avg;
}

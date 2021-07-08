// compile with: clang++ main.cpp -o image_exmple -lSDL2 -lSDL2_image
#include <SDL.h>
#include <SDL_image.h>
#include <cstdio>
#include <string>

#define SCREEN_WIDTH 640
#define SCREEN_HEIGHT 480

SDL_Window *window = NULL;
SDL_Surface *screenSurface = NULL;

static bool init() {
  if (SDL_Init(SDL_INIT_VIDEO) < 0) {
    fprintf(stderr, "could not initialize sdl2: %s\n", SDL_GetError());
    return false;
  }
  if (!(IMG_Init(IMG_INIT_PNG) & IMG_INIT_PNG)) {
    fprintf(stderr, "could not initialize sdl2_image: %s\n", IMG_GetError());
    return false;
  }
  window = SDL_CreateWindow(
			    "hello_sdl2",
			    SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
			    SCREEN_WIDTH, SCREEN_HEIGHT,
			    SDL_WINDOW_SHOWN
			    );
  if (window == NULL) {
    fprintf(stderr, "could not create window: %s\n", SDL_GetError());
    return false;
  }
  screenSurface = SDL_GetWindowSurface(window);
  if (screenSurface == NULL) {
    fprintf(stderr, "could not get window: %s\n", SDL_GetError());
    return false;
  }
  return true;
}

static SDL_Surface* loadImage(std::string path) {
  SDL_Surface* img = IMG_Load(path.c_str());
  if (img == NULL) {
    fprintf(stderr, "could not load image: %s\n", IMG_GetError());
    return NULL;
  }
  SDL_Surface* optimizedImg = SDL_ConvertSurface(img, screenSurface->format, 0);
  if (optimizedImg == NULL) fprintf(stderr, "could not optimize image: %s\n", SDL_GetError());
  SDL_FreeSurface(img);
  return optimizedImg;
}

static void close() {
  SDL_FreeSurface(screenSurface); screenSurface = NULL;
  SDL_DestroyWindow(window); window = NULL;
  SDL_Quit();
}

int main(int argc, char* args[]) {
  if (!init()) return 1;

  SDL_Surface* img = loadImage("hello_world.png");
  if (img == NULL) return 1;

  SDL_BlitSurface(img, NULL, screenSurface, NULL);
  SDL_UpdateWindowSurface(window);

  SDL_Event event;
  bool running = true;

  // Main loop
  while (running) {	
    // Event loop
    while (SDL_PollEvent(&event) != 0) {
      // check event type
      switch (event.type) {
        case SDL_QUIT:
          // shut down
          running = false;
          break;
      }
    }	

    // Wait before next frame
    SDL_Delay(100);
  }

  SDL_FreeSurface(img); img = NULL;
  close();

  return 0;
}

// // A simple program that computes the square root of a number
// #include <cmath>
// #include <iostream>
// #include <string>
// #include "TutorialConfig.h"

// int main(int argc, char* argv[])
// {
//   if (argc < 2) {
//     // report version
//     std::cout << argv[0] << " Version " << Tutorial_VERSION_MAJOR << "."
//               << Tutorial_VERSION_MINOR << std::endl;
//     std::cout << "Usage: " << argv[0] << " number" << std::endl;
//     return 1;
//   }

//   // convert input to double
//   const double inputValue = std::stod(argv[1]);

//   // calculate square root
//   const double outputValue = sqrt(inputValue);
//   std::cout << "The square root of " << inputValue << " is " << outputValue
//             << std::endl;
//   return 0;
// }
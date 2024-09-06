# Fractal-Viewer
![](assets/bundle_android.png)
Fractal Viewer is an interactive & customizable Mandelbrot viewer, made with Flutter.
It's UI uses Material You along with system code adaptibility.

[![PlayStore](assets/PlayStoreButton.png)](https://play.google.com/store/apps/details?id=page.puzzak.fractals)[![GitHub](assets/GHButton.png)](https://github.com/Puzzaks/Fractal-Viewer/releases)
### Features
 - Image streaming
 - Color customizability
 - Automatic resolution change
 - Native Android performance (4-20 fps rendering live view)
### Image Streaming
The app has two main parts, generator and the UI (Backend and Frontend if you wish). UI displays fractal and overlays telemetry and controls over it, controls color, resolution and movement within the Fractal. Generator takes info from frontend and generates a stream of images while panning/scaling in lower resolution (preview) and renders full-res image when user stops panning.
### Color Customizability
App monitors system accent colors and theme to reflect them in UI and color the Fractal accordingly. It uses default theming on older devices and receives actual theme data on devices with Material You support (Android 13+ and Chrome OS).
### Autmatic Resolution Change
Depending on whether user pans/zooms the fractal, or doesn't do that, UI reports different resolution scaling. Once user touches the screen, generator starts sending low-res preview in 0.075 scale, to enable real-time interaction.
Once user lifts finger(-s), generator renders full image in 1 to 1 scale to device resolution, achieving highest level of details possible.
### Native Performance
The app is built with Dart, using Flutter. This means that on Android and Chrome OS app will run natively and thus frame display and generation are unobstructed in performance.
### More Screenshots
![](assets/T1.png)![](assets/T2.png)![](assets/T3.png)![](assets/T4.png)
![](assets/C1.png)![](assets/C2.png)![](assets/C3.png)![](assets/C4.png)

---
## Contributing
 - If you want to create your own app based on this one, you are welcome to do so. Just create a fork and do whatever you want, just don't use OG name and icon please :)
 - If you can find any mistakes or propose any optimisations - please, create new GitHub issue and post all possible details about what do you think.
  - Ideas, feedback and proposals are encouraged. You can make project better, and your opinion matters. Thank you!
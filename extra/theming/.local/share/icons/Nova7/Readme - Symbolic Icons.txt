A NOTE CONCERNING THE 'SYMBOLIC' ICONS IN THIS THEME

This icon theme contains duplicates of some of its icons to which the suffix -symbolic has been added. This was done in order to force KDE Plasma 5 to draw Nova7's own icons instead of monochromatic alternatives from the Breeze theme if/when it requests a 'symbolic' icon.

From my testing, KDE Plasma 5 will use Breeze 'symbolic' icons instead of 'ordinary' ones even if Breeze is not listed under the 'inherits' heading in the index.theme file. Plasma 6 changes this behaviour, and first tries to load a non-symbolic icon from the theme itself before it attempts to load a fallback icon from the Breeze icon theme.

Unfortunately, Plasma 5 is not consistent in how it treats colourful icons with the -symbolic suffix. Whereas often it appears to render these icons as intended, it sometimes converts them into monochromatic, black-and-white icons. This can be seen in the 'Download New Icons' window, accessible via system settings: the 'Recent' button will load the clock icon correctly, whereas the 'Show Most Recent First' menu entry will render the same icon as a completely black circle.

Interestingly, Breeze also contains icons which only come in the 'symbolic' variety. That is to say, icons that do not have equivalents that only have the 'base' file name. An example of this is file-search-symbolic: at the time of writing, Breeze does not contain an icon called file-search. This theme provides its own alternatives for such icons, too.


WHAT TO DO IF CERTAIN ICONS DON'T 'TAKE'

I have noticed that, sometimes, KDE Plasma does not load some of the small icons provided, using Breeze equivalents instead. If this happens, please try switching to another icon theme in System Settings (one that is neither Nova7 nor Breeze) and then switching back to Nova7.

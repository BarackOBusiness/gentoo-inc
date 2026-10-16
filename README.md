# Business Inc. - A gentoo overlay
This personal overlay hosts some niche software and community forks of things that I use.
It is also a place to experiment with some system configuration.

This overlay depends on the GURU overlay for some packages, unless I determine their ebuild to need reimplementation here for my uses.

# Notes
This section details usage notes people should know if trying to use this overlay themselves
### games-util/steam-launcher
This package is merely the steam-launcher ebuild taken from the steam overlay with all abi_x86_32 deps removed.
* the steam client must be subscribed to the beta branch before use
* your kernel must be configured with IA32_EMULATION
* you must still have multilib support in libc (so just stick to the multilib profile)
* win64 games will run with no abi_x86_32 packages
* win32 games will only run with proton wow64 enabled with no abi_x86_32 packages
* linux 64b games will run so long as the 32b gameoverlayrenderer.so is stripped from LD_PRELOAD
* linux 32b games require normal 32b libs; the graphics driver and anything not in the steam runtime

## TODO
- [ ] Be better, get gooder, increase ebuild skill

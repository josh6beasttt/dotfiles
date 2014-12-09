"""
Color Scheme Tweaker (for sublime text)
Licensed under MIT
Copyright (c) 2013 Isaac Muse <isaacmuse@gmail.com>
"""
from __future__ import absolute_import
from .rgba import RGBA
import re

FILTER_MATCH = re.compile(r'^(?:(brightness|saturation|hue|colorize|glow)\((-?[\d]+|[\d]*\.[\d]+)\)|(sepia|grayscale|invert))(?:@(fg|bg))?$')


class ColorSchemeTweaker(object):
    def _apply_filter(self, color, f_name, value=None):
        if isinstance(color, RGBA):
            if value is None:
                color.__getattribute__(f_name)()
            else:
                color.__getattribute__(f_name)(value)

    def _filter_colors(self, *args, **kwargs):
        global_settings = kwargs.get("global_settings", False)
        dual_colors = False
        if len(args) == 1:
            fg = args[0]
            bg = None
        elif len(args) == 2:
            fg = args[0]
            bg = args[1]
            if not global_settings:
                dual_colors = True
        else:
            return None, None

        try:
            assert(fg is not None)
            rgba_fg = RGBA(fg)
        except:
            rgba_fg = fg
        try:
            assert(bg is not None)
            rgba_bg = RGBA(bg)
        except:
            rgba_bg = bg

        for f in self.filters:
            name = f[0]
            value = f[1]
            context = f[2]
            if name in ["grayscale", "sepia", "invert"]:
                if context != "bg":
                    self._apply_filter(rgba_fg, name)
                if context != "fg":
                    self._apply_filter(rgba_bg, name)
            elif name in ["saturation", "brightness", "hue", "colorize"]:
                if context != "bg":
                    self._apply_filter(rgba_fg, name, value)
                if context != "fg":
                    self._apply_filter(rgba_bg, name, value)
            elif name == "glow" and dual_colors and isinstance(rgba_fg, RGBA) and (bg is None or bg.strip() == ""):
                rgba = RGBA(rgba_fg.get_rgba())
                rgba.apply_alpha(self.bground if self.bground != "" else "#FFFFFF")
                bg = rgba.get_rgb() + ("%02X" % int((255.0 * value)))
                try:
                    rgba_bg = RGBA(bg)
                except:
                    rgba_bg = bg
        return (
            rgba_fg.get_rgba() if isinstance(rgba_fg, RGBA) else rgba_fg,
            rgba_bg.get_rgba() if isinstance(rgba_bg, RGBA) else rgba_bg
        )

    def tweak(self, tmtheme, filters):
        self.filters = []
        for f in filters.split(";"):
            m = FILTER_MATCH.match(f)
            if m:
                if m.group(1):
                    self.filters.append([m.group(1), float(m.group(2)), m.group(4) if m.group(4) else "all"])
                else:
                    self.filters.append([m.group(3), 0.0, m.group(4) if m.group(4) else "all"])

        if len(self.filters):
            general_settings_read = False
            for settings in tmtheme["settings"]:
                if not general_settings_read:
                    for k, v in settings["settings"].items():
                        if k in ["background", "gutter", "lineHighlight", "selection"]:
                            _, v = self._filter_colors(None, v, global_settings=True)
                        else:
                            v, _ = self._filter_colors(v, global_settings=True)
                        settings["settings"][k] = v
                    general_settings_read = True
                    continue
                self.bground = RGBA(tmtheme["settings"][0]["settings"].get("background", '#FFFFFF')).get_rgb()
                self.fground = RGBA(tmtheme["settings"][0]["settings"].get("foreground", '#000000')).get_rgba()
                foreground, background = self._filter_colors(
                    settings["settings"].get("foreground", None),
                    settings["settings"].get("background", None)
                )
                if foreground is not None:
                    settings["settings"]["foreground"] = foreground
                if background is not None:
                    settings["settings"]["background"] = background

        return tmtheme

    def _get_filters(self):
        filters = []
        for f in self.filters:
            if f[0] in ["invert", "grayscale", "sepia"]:
                filters.append(f[0])
            elif f[0] in ["hue", "colorize"]:
                filters.append(f[0] + "(%d)" % int(f[1]))
            elif f[0] in ["saturation", "brightness"]:
                filters.append(f[0] + "(%f)" % f[1])
            else:
                continue
            if f[2] != "all":
                filters[-1] = filters[-1] + ("@%s" % f[2])
        return filters

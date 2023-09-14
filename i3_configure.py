#!/usr/bin/env python3

import re
from subprocess import run

OFFSET_PERCENT = 100


if __name__ == '__main__':
    i3_var_tpl = "    bindsym {} move position {} {}"

    out = run(
        ["xrandr"], capture_output=True,
    ).stdout.decode("utf-8").strip()

    matches = (
        re.findall(r"(?<=connected )\d+x\d+", out)
        or re.findall(r"(?<=connected primary )\d+x\d+", out)
    )
    if matches:
        width, height = [int(v) for v in matches[0].split("x")]
        offset_x = width // OFFSET_PERCENT
        offset_y = height // OFFSET_PERCENT

        half_width = width // 2
        half_height = height // 2

        left_up_x = offset_x
        left_up_y = offset_y

        left_down_x = offset_x
        left_down_y = half_height + offset_y

        right_up_x = half_width + offset_x
        right_up_y = offset_y

        right_down_x = half_width + offset_x
        right_down_y = half_height + offset_y

        insert = [
            i3_var_tpl.format("q", left_up_x, left_up_y),
            i3_var_tpl.format("w", right_up_x, right_up_y),
            i3_var_tpl.format("a", left_down_x, left_down_y),
            i3_var_tpl.format("s", right_down_x, right_down_y),
            ""
        ]

        with open("i3/config.tpl", "r") as conf:
            lines = conf.read().split("\n")
        move_mode_line = lines.index("mode $move_mode {")
        lines = lines[:move_mode_line+1] + insert + lines[move_mode_line+1:]

        with open("i3/config", "w") as conf:
            for line in lines:
                conf.write(f"{line}\n")

    else:
        raise RuntimeError("Problem parsing xrandr output.")


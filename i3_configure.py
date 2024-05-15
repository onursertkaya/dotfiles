#!/usr/bin/env python3

# pylint: disable=missing-module-docstring,missing-function-docstring
import re
from subprocess import run

OFFSET_PERCENT = 100


def gaps():
    out = (
        run(
            ["i3", "--version"],
            capture_output=True,
            check=True,
        )
        .stdout.decode("utf-8")
        .strip()
    )

    match = re.search(r"(?<=i3 version )\d+\.\d+", out)

    # assume semantic version
    major, minor = match.group(0).split(".")
    if int(major) == 4 and int(minor) > 22:
        with open("i3/config", "a", encoding="utf-8") as conf:
            conf.write("\n")
            conf.write("gaps inner 20px\n")
            conf.write("gaps outer 20px\n")


def _calculate_move_step(width: int, height: int):
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

    i3_var_tpl = "    bindsym {} move position {} {}"
    return [
        i3_var_tpl.format("q", left_up_x, left_up_y),
        i3_var_tpl.format("w", right_up_x, right_up_y),
        i3_var_tpl.format("a", left_down_x, left_down_y),
        i3_var_tpl.format("s", right_down_x, right_down_y),
        "",
    ]


def move_mode():
    out = (
        run(
            ["xrandr"],
            capture_output=True,
            check=True,
        )
        .stdout.decode("utf-8")
        .strip()
    )

    matches = re.findall(r"(?:(?<=connected primary )|(?<=connected ))\d+x\d+", out)
    if matches:
        width, height = [int(v) for v in matches[0].split("x")]
    else:
        width, height = 1920, 1080
        print(f"problem parsing xrandr output, using default {width=} {height=}")

    with open("i3/config.tpl", "r", encoding="utf-8") as conf:
        lines = conf.read().split("\n")
    move_mode_line = lines.index("mode $move_mode {")
    insert = _calculate_move_step(width, height)
    lines = lines[: move_mode_line + 1] + insert + lines[move_mode_line + 1 :]

    with open("i3/config", "w", encoding="utf-8") as conf:
        for line in lines:
            conf.write(f"{line}\n")


if __name__ == "__main__":
    move_mode()
    gaps()

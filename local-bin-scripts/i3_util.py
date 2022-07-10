#!/usr/bin/env python3
import subprocess
import json
from dataclasses import dataclass
from pprint import pprint
from typing import Dict, List, Tuple


@dataclass(frozen=True)
class Rect:

    width: int
    height: int


def run(cmd: str, *args) -> Dict:
    assert cmd in ["get_workspaces", "get_tree", "command"]
    full_cmd = ["i3-msg", "-t", cmd, *args]
    out = subprocess.run(
        full_cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )
    if out.returncode != 0:
        print(full_cmd)
        print(out.stderr.decode("utf-8"))
    return json.loads(out.stdout.decode("utf-8").strip("\n"))


def get_workspaces() -> List:
    return run("get_workspaces")


def filter_by_name(obj: Dict, name: str) -> Dict:
    return next(
        filter(lambda n: n["name"] == name, obj)
    )


def get_screen_geometry() -> Rect:
    rect = get_tree()["rect"]
    return Rect(width=int(rect["width"]), height=int(rect["height"]))


def get_tree() -> Dict:
    return run("get_tree")


def get_current_workspace() -> Dict:
    return next(
        filter(
            lambda ws: ws["visible"] == True and ws["focused"] == True, get_workspaces()
        )
    )


def get_current_workspace_windows() -> Tuple[Dict, Dict]:
    current_ws = get_current_workspace()

    current_ws_id = current_ws["num"]
    current_ws_output_device = current_ws["output"]

    root = get_tree()
    focused_device = next(
        filter(lambda n: n["name"] == current_ws_output_device, root["nodes"])
    )
    focused_device_content = next(
        filter(lambda n: n["name"] == "content", focused_device["nodes"])
    )

    focused_ws_nodes = next(
        filter(lambda n: n["num"] == current_ws_id, focused_device_content["nodes"])
    )

    floating = focused_ws_nodes["floating_nodes"]
    tiling = focused_ws_nodes["nodes"]

    print(json.dumps(focused_ws_nodes, indent=2))
    exit()

    return tiling, floating


def toggle_windows_by_name(name: str):
    tiling, _ = get_current_workspace_windows()

    for t in tiling:
        window_class = t["window_properties"]["class"]
        if window_class== name:
            window_id = t["window"]
            run("command", f"[id={window_id}] floating enable")

    g = get_screen_geometry()

    _, floating = get_current_workspace_windows()

    s_h = 0.4
    s_v = (1.0 / len(floating)) * 0.9

    size_x = int(s_h * g.width)
    size_y = int(s_v * g.height)

    start_pos_x = int((g.width*1.2) // 2)
    start_pos_y =int(g.height * 0.05)
    vert_pos = start_pos_y

    for f in floating:
        for node in f["nodes"]:
            window_id = node["window"]
            run("command", f"[id={window_id}] resize set {size_x} {size_y}")

            run("command", f"[id={window_id}] move window position {start_pos_x} {vert_pos}")
            vert_pos += int(size_y*1.05)


toggle_windows_by_name("Gnome-terminal")


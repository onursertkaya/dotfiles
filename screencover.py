#!/usr/bin/env python3
from subprocess import run, Popen, PIPE
from tkinter import ttk

import signal
from shlex import split
from time import sleep
import tkinter as tk


def _capture_blur():
    grab_proc = Popen(split("import -window root png:-"), stdout=PIPE)
    blur_proc = Popen(
        split("convert png:- -filter Gaussian -blur 0x8 png:-"),
        stdin=grab_proc.stdout,
        stdout=PIPE,
    )
    grab_proc.wait()
    blurred, _ = blur_proc.communicate()
    return blurred


def make_bg(parent, bg):
    label = tk.Label(
        parent,
        image=bg,
        borderwidth=0,
    )
    label.pack()


class ScreenOff:
    def __init__(self, delay=None):
        self._delay = delay

    def __call__(self):
        if self._delay is not None:
            sleep(self._delay)
        run(split("xset dpms force off"))


def make_button(parent):
    s = ttk.Style()

    s.configure(
        "Nice.TButton",
        font=("Roboto", 22),
        padx=80,
        pady=40,
        background="#666688",
        activebackground="#555577",
        foreground="#FFFFFF",
        borderwidth=0,
    )

    btn_unlock = ttk.Button(
        parent,
        text="unlock",
        command=parent.destroy,
        style="Nice.TButton",
    )
    btn_unlock.place(relx=0.5, rely=0.6, anchor="center")

    btn_screen = ttk.Button(
        parent,
        text="screen off",
        command=ScreenOff(1),
        style="Nice.TButton",
    )
    btn_screen.place(relx=0.5, rely=0.65, anchor="center")


def setup_signals(parent):
    for s in (signal.SIGTERM, signal.SIGINT):
        signal.signal(s, lambda *_: parent.destroy())


def main():
    root = tk.Tk()
    root.title("cover")

    root.attributes("-fullscreen", True)
    root.attributes("-topmost", True)
    root.configure(background="black")

    blurred = _capture_blur()
    bg = tk.PhotoImage(data=blurred, format="png")
    make_bg(root, bg)
    make_button(root)
    setup_signals(root)

    root.after(2000, ScreenOff())
    root.mainloop()


if __name__ == "__main__":
    main()

import gi
gi.require_version("Gtk", "4.0")
gi.require_version("Adw", "1")
from gi.repository import Gtk, GLib, Adw

from threading import Thread

import torch
from transformers import AutoModelForCausalLM, AutoTokenizer

MODEL = "facebook/opt-1.3b"

print("Loading model...")
model = AutoModelForCausalLM.from_pretrained(MODEL)

print("Loading tokenizer...")
tokenizer = AutoTokenizer.from_pretrained(MODEL, use_fast=False)


class MainWindow(Gtk.ApplicationWindow):
    def __init__(self, *args, **kwargs):
        super().__init__(
            *args, **kwargs,
            title="Scribe",
            default_width=600,
            default_height=250
        )

        self.main_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.set_child(self.main_box)

        self.overlay = Gtk.Overlay()
        self.main_box.append(self.overlay)

        self.entry = Gtk.TextView(wrap_mode=Gtk.WrapMode.WORD_CHAR, vexpand=True)
        self.overlay.set_child(self.entry)

        self.spinner = Gtk.Spinner(
            halign=Gtk.Align.END,
            margin_end=10,
            valign=Gtk.Align.END,
            margin_bottom=5
        )
        self.overlay.add_overlay(self.spinner)

        self.button_box = Gtk.Box(
            orientation=Gtk.Orientation.HORIZONTAL,
            margin_start=5,
            margin_end=5,
            margin_top=5,
            margin_bottom=5,
            spacing=5,
            homogeneous=True
        )
        self.main_box.append(self.button_box)

        self.buttons = []
        self.create_add_button(1)
        self.create_add_button(5)
        self.create_add_button(25)
        self.create_add_button(100)

    def create_add_button(self, token_count):
        overlay = Gtk.Overlay()
        self.button_box.append(overlay)

        button = Gtk.Button(label=f"Add {token_count}")
        button.connect("clicked", lambda e: self.add(token_count))
        overlay.set_child(button)

        self.buttons.append(button)

    def add(self, token_count):
        self.entry.set_editable(False)

        for button in self.buttons:
            button.set_sensitive(False)

        self.spinner.start()

        start = self.entry.get_buffer().get_start_iter()
        end = self.entry.get_buffer().get_end_iter()
        text = self.entry.get_buffer().get_text(start, end, True)

        Thread(target=self.add_thread, args=(token_count, text)).start()

    def add_thread(self, token_count, text):
        input_ids = tokenizer(text, return_tensors="pt").input_ids
        generated_ids = model.generate(
            input_ids,
            num_return_sequences=1,
            max_new_tokens=token_count,
            do_sample=True,
            temperature=1,
            top_k=25
        )
        result = tokenizer.batch_decode(generated_ids, skip_special_tokens=True)

        GLib.idle_add(self.show_output, result[0])

    def show_output(self, result):
        self.entry.get_buffer().set_text(result)

        self.spinner.stop()

        for button in self.buttons:
            button.set_sensitive(True)

        self.entry.set_editable(True)


class MyApp(Adw.Application):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.connect("activate", self.on_activate)

    def on_activate(self, app):
        self.win = MainWindow(application=app)
        self.win.present()


def main():
    app = MyApp(application_id="me.danth.Scribe")
    app.run()

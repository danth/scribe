import gi
gi.require_version("Gtk", "4.0")
gi.require_version("Adw", "1")
from gi.repository import Gtk, GLib, Adw

from threading import Thread

import torch
from transformers import AutoModelForCausalLM, AutoTokenizer

MODELS = {
    "OPT 125M": "facebook/opt-125m",
    "OPT 350M": "facebook/opt-350m",
    "OPT 1.3B": "facebook/opt-1.3b",
    "OPT 2.7B": "facebook/opt-2.7b"
}
MODEL_NAMES = list(MODELS.keys())
DEFAULT_MODEL = "OPT 1.3B"

class MainWindow(Gtk.ApplicationWindow):
    def __init__(self, *args, **kwargs):
        super().__init__(
            *args, **kwargs,
            title="Scribe",
            default_width=600,
            default_height=250
        )

        self.header_bar = Gtk.HeaderBar()
        self.set_titlebar(self.header_bar)

        self.model_dropdown = Gtk.DropDown.new_from_strings(MODEL_NAMES)
        self.model_dropdown.connect('notify::selected-item', self.load_selected_model)
        self.header_bar.pack_start(self.model_dropdown)

        self.main_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.set_child(self.main_box)

        self.info_bar = Gtk.InfoBar()
        self.main_box.append(self.info_bar)

        self.info_label = Gtk.Label(halign=Gtk.Align.START, hexpand=True)
        self.info_bar.add_child(self.info_label)

        self.info_spinner = Gtk.Spinner()
        self.info_bar.add_child(self.info_spinner)

        self.entry = Gtk.TextView(
            wrap_mode=Gtk.WrapMode.WORD_CHAR,
            vexpand=True,
            margin_start=5,
            margin_end=5,
            margin_top=5,
            margin_bottom=5
        )
        self.main_box.append(self.entry)

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

        self.load_model(DEFAULT_MODEL)

    def create_add_button(self, token_count):
        overlay = Gtk.Overlay()
        self.button_box.append(overlay)

        button = Gtk.Button(label=f"Add {token_count}")
        button.connect("clicked", lambda e: self.add(token_count))
        overlay.set_child(button)

        self.buttons.append(button)

    def load_selected_model(self, _dropdown, _pspec):
        item = self.model_dropdown.props.selected_item
        if item is not None:
            self.load_model(item.props.string)

    def load_model(self, model_name):
        self.start_working(f"Loading {model_name}", editable=True)

        # Usually the model to load is already selected, but not during initialisation
        selected_index = MODEL_NAMES.index(model_name)
        self.model_dropdown.set_selected(selected_index)

        Thread(target=self.load_model_thread, args=(model_name,)).start()

    def load_model_thread(self, model_name):
        # Ensure the previous model is unloaded first, to reduce peak memory usage
        if hasattr(self, "model"):
            del self.model
            del self.tokenizer

        model_path = MODELS[model_name]

        self.model = AutoModelForCausalLM.from_pretrained(model_path)
        self.tokenizer = AutoTokenizer.from_pretrained(model_path, use_fast=False)

        GLib.idle_add(self.stop_working)

    def add(self, token_count):
        self.start_working("Generating text")

        start = self.entry.get_buffer().get_start_iter()
        end = self.entry.get_buffer().get_end_iter()
        text = self.entry.get_buffer().get_text(start, end, True)

        Thread(target=self.add_thread, args=(token_count, text)).start()

    def add_thread(self, token_count, text):
        input_ids = self.tokenizer(text, return_tensors="pt").input_ids

        generated_ids = self.model.generate(
            input_ids,
            num_return_sequences=1,
            max_new_tokens=token_count,
            do_sample=True,
            temperature=1,
            top_k=25
        )

        result = self.tokenizer.batch_decode(generated_ids, skip_special_tokens=True)

        GLib.idle_add(self.show_output, result[0])

    def show_output(self, result):
        self.entry.get_buffer().set_text(result)

        self.stop_working()

    def start_working(self, message, editable=False):
        self.info_bar.set_revealed(True)
        self.info_spinner.start()
        self.info_label.set_text(message)

        self.entry.set_editable(editable)

        self.model_dropdown.set_sensitive(False)
        for button in self.buttons:
            button.set_sensitive(False)

    def stop_working(self):
        self.info_bar.set_revealed(False)
        self.info_spinner.stop()

        self.entry.set_editable(True)

        self.model_dropdown.set_sensitive(True)
        for button in self.buttons:
            button.set_sensitive(True)


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

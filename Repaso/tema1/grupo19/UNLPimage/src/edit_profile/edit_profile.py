import PySimpleGUI as sg
from PIL import Image
import os

from UNLPimage.common.const import WINDOW_SIZE, THEME, FONT_BODY, FONT_TITLE
from UNLPimage.common.path import PATH_BACK_ICO, PATH_IMAGE_AVATAR
import UNLPimage.src.edit_profile.edit_profile_functions as edit_functions
import UNLPimage.src.new_profile.new_profile_functions as new_functions
from UNLPimage.src.classes.log import Log


def edit_profile_window():
    """Esta funcion retorna el alayout de la ventana edit_profile"""
    sg.set_options(font=FONT_BODY)
    sg.theme(THEME)
    components_left = [
        [sg.Text("Editar Perfil", font=FONT_TITLE)],
        [sg.Text("Nick o Alias", font=FONT_BODY, pad=((10, 10), (10, 10)))],
        [
            sg.Input(
                key="-NICK-",
                font=("Arial", 12, "italic"),
                size=(35, 2),
                readonly=True,
                pad=((10, 10), (8, 8)),
                disabled_readonly_background_color="#86a6df",
                tooltip="Campo inmutable",
            )
        ],
        [sg.Text("Nombre", font=FONT_BODY, pad=((10, 10), (10, 10)))],
        [
            sg.Input(
                key="-NAME-",
                font=FONT_BODY,
                size=(35, 2),
                enable_events=True,
                pad=((10, 10), (8, 8)),
            )
        ],
        [sg.Text("Edad", font=FONT_BODY, pad=((10, 10), (10, 10)))],
        [
            sg.Input(
                key="-AGE-",
                font=FONT_BODY,
                size=(35, 2),
                enable_events=True,
                pad=((10, 10), (8, 8)),
            )
        ],
        [sg.Text("Genero Autopercibido", font=FONT_BODY, pad=((10, 10), (8, 8)))],
        [
            sg.Combo(
                (
                    "Varon cis",
                    "Varon trans",
                    "Mujer cis",
                    "Mujer trans",
                    "No Binarie",
                    "Otre",
                ),
                key="-GENDER-",
                font=FONT_BODY,
                auto_size_text=True,
                readonly=True,
                pad=((10, 10), (8, 8)),
            )
        ],
        [
            sg.Checkbox(
                "Otro",
                font=FONT_BODY,
                key="-CHECKBOX-",
                enable_events=True,
                pad=((10, 10), (8, 8)),
            )
        ],
        [
            sg.Input(
                "Complete el Genero",
                font=FONT_BODY,
                key="-GENDER INPUT-",
                size=(35, 2),
                visible=False,
                enable_events=True,
                pad=((10, 10), (8, 8)),
            )
        ],
    ]
    components_right = [
        [
            sg.Image(
                source=PATH_BACK_ICO,
                subsample=2,
                key="-EXIT-",
                enable_events=True,
                pad=((380, 0), (0, 0)),
            )
        ],
        [sg.Image(key="AVATAR", pad=((90, 0), (25, 0)))],
        [
            sg.Input(
                key="-AVATAR URL-", font=FONT_BODY, visible=False, enable_events=True
            ),
            sg.FileBrowse(
                "Seleccionar Avatar",
                key="SELECCIONAR AVATAR EDIT",
                pad=((140, 0), (45, 0)),
                initial_folder=PATH_IMAGE_AVATAR,
            ),
        ],
        [
            sg.Push(),
            sg.Button("Guardar", key="-EDIT-", border_width=0, pad=((350, 0), (40, 0))),
        ],
    ]
    layout = [
        [
            sg.Column(components_left),
            sg.Column(components_right),
        ]
    ]
    return sg.Window(
        "UNLPimage - Editar Perfil",
        layout,
        size=WINDOW_SIZE,
        finalize=True,
        enable_close_attempted_event=True,
    )


def run(initial_user):
    """Esta funcion contiene la logica de la ventana edit_profile"""
    window = edit_profile_window()
    edit_functions.fill_inputs(window, initial_user)

    while True:
        event, values = window.read()
        match event:
            case "-EXIT-":
                window.Hide()
                new_functions.delete_img_before_back("temporary_img")
                return initial_user
            case sg.WIN_CLOSE_ATTEMPTED_EVENT:
                confirm = sg.popup_yes_no("¿Está seguro que desea salir?")
                if confirm == "Yes":
                    exit()
            case "-NICK-":
                new_functions.clear_input(window["-NICK-"])
            case "-NAME-":
                new_functions.clear_input(window["-NAME-"])
            case "-AGE-":
                new_functions.clear_input(window["-AGE-"])
            case "-GENDER INPUT-":
                new_functions.clear_input(window["-GENDER INPUT-"])
            case "-CHECKBOX-":
                new_functions.change_gender_input(
                    window["-GENDER INPUT-"], window["-GENDER-"]
                )
            case "-EDIT-":
                confirm = sg.popup_yes_no("¿Está seguro que desea editar el usuario?")
                if confirm == "Yes":
                    user, ok = edit_functions.edit_user(window, values, initial_user)
                    new_functions.delete_img_before_back("temporary_img")
                    if ok:
                        window.Hide()
                        if initial_user.values() != user.values():
                            Log.nick = user["nick"]
                            Log.write_log("Edito su usuario")
                            return user
                        else:
                            return initial_user
                    else:
                        sg.popup("Verifique los datos ingresados")
            case "-AVATAR URL-":
                img_url = window["-AVATAR URL-"].get()
                window["AVATAR"].update(img_url, subsample=4)
                new_functions.create_user_img(img_url, "temporary_img")
    window.close()

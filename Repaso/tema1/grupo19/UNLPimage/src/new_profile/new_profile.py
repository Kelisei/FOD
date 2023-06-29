import os
import PySimpleGUI as sg

from UNLPimage.common.const import (
    WINDOW_SIZE,
    THEME,
    FONT_BODY,
    FONT_TITLE,
    AVATAR_DEFAULT,
)
from UNLPimage.common.path import PATH_IMAGE_AVATAR, PATH_BACK_ICO
from UNLPimage.src.classes.log import Log
import UNLPimage.src.new_profile.new_profile_functions as new_functions
import UNLPimage.src.main.main as main_window


def new_profile_window():
    """Esta funcion retorna el alayout de la ventana new_profile"""
    sg.set_options(font=FONT_BODY)
    sg.theme(THEME)
    components_left = [
        [sg.Text("Nuevo Perfil", font=FONT_TITLE)],
        [sg.Text("Nick o Alias", font=FONT_BODY, pad=((10, 10), (10, 10)))],
        [
            sg.Input(
                key="-NICK-",
                font=FONT_BODY,
                size=(35, 2),
                enable_events=True,
                pad=((10, 10), (8, 8)),
            )
        ],
        [
            sg.Text("Nombre", font=FONT_BODY, pad=((10, 10), (10, 10))),
        ],
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
                disabled=False,
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
                key="IR MENU INICIO",
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
                key="SELECCIONAR AVATAR",
                pad=((140, 0), (45, 0)),
                initial_folder=PATH_IMAGE_AVATAR,
            ),
        ],
        [sg.Button("Guardar", key="-SAVE-", border_width=0, pad=((350, 0), (40, 0)))],
    ]
    layout = [
        [
            sg.Column(components_left),
            sg.Column(components_right),
        ]
    ]
    return sg.Window(
        "UNLPimage - Nuevo Perfil",
        layout,
        size=WINDOW_SIZE,
        finalize=True,
        enable_close_attempted_event=True,
    )


def run():
    """Esta funcion contiene la logica de la ventana new_profile"""
    window = new_profile_window()
    default_img_path = os.path.join(PATH_IMAGE_AVATAR, AVATAR_DEFAULT)
    window["AVATAR"].update(source=default_img_path, subsample=4)
    window["-AVATAR URL-"].update(default_img_path)

    while True:
        event, values = window.read()

        match event:
            case "IR MENU INICIO":
                new_functions.delete_img_before_back("temporary_img")
                break
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
            case "-SAVE-":
                confirm = sg.popup_yes_no("¿Está seguro que desea crear el usuario?")
                if confirm == "Yes":
                    user, ok = new_functions.new_user(window, values)
                    if ok:
                        window.Hide()
                        Log.nick = user["nick"]
                        Log.try_open_logs()
                        Log.write_log("Dio de alta su usuario")
                        new_functions.delete_img_before_back("temporary_img")
                        main_window.run(user)
                        break
                    else:
                        sg.popup("Verifique los datos ingresados")
            case "-AVATAR URL-":
                img_url = window["-AVATAR URL-"].get()
                new_functions.create_user_img(img_url, "temporary_img")
                temporary_img_url = os.path.join(PATH_IMAGE_AVATAR, 'temporary_img.png')
                window["AVATAR"].update(temporary_img_url, subsample=4)

    window.close()

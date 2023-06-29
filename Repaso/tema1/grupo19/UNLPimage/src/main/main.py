import PySimpleGUI as sg
from UNLPimage.common.const import FONT_BODY, WINDOW_SIZE, THEME
from UNLPimage.common.path import PATH_HELP_ICO
from UNLPimage.common.path import PATH_SETTINGS_ICO, PATH_PFP_ICO
from UNLPimage.common.path import PATH_BACK_ICO
import UNLPimage.src.collage.collage_patterns as window_collage
import UNLPimage.src.help.help as window_help
import UNLPimage.src.meme.meme as window_meme_generator
import UNLPimage.src.edit_profile.edit_profile as window_edit_profile
import UNLPimage.src.labelling.labelling as window_labelling
import UNLPimage.src.settings.settings as window_settings
from UNLPimage.src.main.main_functions import load
from UNLPimage.src.classes.log import Log


def menu(dicci: dict):
    """ "Genera el menu principal de la  app
    @param dicci: Diccionario que contiene la info de usuario,
    usado para mostrar su info"""
    name = dicci["nick"]
    sg.set_options(font=FONT_BODY)
    sg.theme(THEME)
    layout = [
        [
            sg.Image(
                source=PATH_BACK_ICO, subsample=2, key="-BACK-", enable_events=True
            ),
            sg.Image(
                source=PATH_PFP_ICO,
                subsample=2,
                key="-EDIT_PROFILE-",
                enable_events=True,
            ),
            sg.Push(),
            sg.Image(
                source=PATH_SETTINGS_ICO,
                subsample=2,
                key="-SETTINGS-",
                enable_events=True,
            ),
            sg.Image(
                source=PATH_HELP_ICO, subsample=2, key="-HELP-", enable_events=True
            ),
        ],
        [sg.Image(key="-PFP-")],
        [
            sg.Text(
                "- " + name.upper() + " -",
                auto_size_text=True,
            )
        ],
        [
            sg.Button(
                "Etiquetar imagenes",
                key="-LABELLING-",
                size=(25, 2),
                pad=((3, 3), (30, 3)),
            ),
            sg.Button(
                "Generar meme", key="-MEME-", size=(25, 2), pad=((3, 3), (30, 3))
            ),
        ],
        [
            sg.Button(
                "Generar collage", size=(25, 2), key="-COLLAGE-", pad=((3, 3), (3, 3))
            ),
            sg.Exit("Salir", key="-EXIT-", size=(25, 2), pad=((3, 3), (3, 3))),
        ],
    ]
    return sg.Window(
        "UNLPimage - MENU Principal",
        layout,
        element_justification="c",
        size=WINDOW_SIZE,
        finalize=True,
        enable_close_attempted_event=True,
    )


def run(dicci):
    """Funcion que inicia el menu de la app.
    @param dicci: recibe diccionario con info de usuario usado para
    mostrar su info, y enviarsla a editar usuario.
    """
    Log.nick = dicci["nick"]
    Log.try_open_logs()

    menu_window = menu(dicci)  # menu2
    while True:
        load(menu_window, dicci)

        event, values = menu_window.read()

        match event:
            case "-EXIT-" | sg.WIN_CLOSE_ATTEMPTED_EVENT:
                confirm = sg.popup_yes_no("¿Está seguro que desea salir?")
                if confirm == "Yes":
                    exit()
            case "-HELP-":
                menu_window.hide()
                window_help.run()
                menu_window.un_hide()
            case "-BACK-":
                break
            case "-COLLAGE-":
                menu_window.hide()
                window_collage.run()
                menu_window.un_hide()
            case "-EDIT_PROFILE-":
                menu_window.Hide()
                dicci = window_edit_profile.run(dicci)
                Log.nick = dicci["nick"]
                menu_window.un_hide()
            case "-MEME-":
                menu_window.hide()
                window_meme_generator.run()
                menu_window.un_hide()
            case "-LABELLING-":
                menu_window.hide()
                window_labelling.run(dicci["nick"])
                menu_window.un_hide()
            case "-SETTINGS-":
                menu_window.hide()
                window_settings.run()
                menu_window.un_hide()
    menu_window.close()

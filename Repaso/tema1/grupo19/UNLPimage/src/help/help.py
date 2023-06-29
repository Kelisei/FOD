import PySimpleGUI as sg
import UNLPimage.src.help.windows as windows_help
import UNLPimage.src.help.about_us as about_us
import UNLPimage.src.help.how_to_use as windows_how
from UNLPimage.common.const import WINDOW_SMALL_SIZE, FONT_BODY
from UNLPimage.common.path import PATH_BACK_ICO


def help():
    """ "Genera la ventana de menu  sobre ayudas en la app"""
    layout = [
        [sg.T("AYUDA", font=FONT_BODY), sg.Push()],
        [sg.B("Como Funciona UNLPImage", key="-HOW-", size=(25, 2))],
        [sg.B("INFO Ventanas", key="-WINDOWS-", size=(25, 2))],
        [sg.B("Quienes Somos", key="-ABOUT-US-", size=(25, 2))],
        [
            sg.Push(),
            sg.Image(
                source=PATH_BACK_ICO,
                subsample=2,
                enable_events=True,
                key="-RETURN-",
                pad=((0, 0), (0, 0)),
            ),
        ],
    ]
    return sg.Window(
        "UNLPimage - Ayuda",
        layout,
        element_justification="c",
        size=WINDOW_SMALL_SIZE,
        finalize=True,
        enable_close_attempted_event=True,
    )


def run():
    help_window = help()
    while True:
        event, values = help_window.read()
        match event:
            case sg.WIN_CLOSE_ATTEMPTED_EVENT:
                confirm = sg.popup_yes_no("¿Está seguro que desea salir?")
                if confirm == "Yes":
                    exit()
            case "-RETURN-":
                break
            case "-HOW-":
                windows_how.run()
            case "-WINDOWS-":
                windows_help.run()
            case "-ABOUT-US-":
                about_us.run()
    help_window.close()

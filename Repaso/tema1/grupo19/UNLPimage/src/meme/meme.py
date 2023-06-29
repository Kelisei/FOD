import PySimpleGUI as sg
from UNLPimage.common.const import WINDOW_FULL_SIZE, THEME
from UNLPimage.common.path import PATH_BACK_ICO


def meme():
    """ "Genera el layout de pestaña memes"""

    layout = [
        [sg.Text("ACA VA LA EDICION DE IMAGENES DE MEME", pad=((0, 0), (150, 0)))],
        [
            sg.Push(),
            sg.Image(
                source=PATH_BACK_ICO,
                subsample=2,
                key="-RETURN-",
                enable_events=True,
                pad=((0, 0), (450, 0)),
            ),
        ],
    ]
    return sg.Window(
        "UNLPimage - Crear Meme",
        layout,
        element_justification="c",
        size=WINDOW_FULL_SIZE,
        finalize=True,
        enable_close_attempted_event=True,
    )


def run():  # en caso de uso de parametros pasarlo al run
    sg.theme(THEME)
    meme_window = meme()
    while True:
        event, values = meme_window.read()
        if event == sg.WIN_CLOSE_ATTEMPTED_EVENT:
            confirm = sg.popup_yes_no("¿Está seguro que desea salir?")
            if confirm == "Yes":
                exit()
        if event == "-RETURN-":
            break
    meme_window.close()

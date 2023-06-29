import PySimpleGUI as sg
from UNLPimage.common.const import WINDOW_ABOUT_US_SIZE, FONT_BODY, FONT_TITLE
from UNLPimage.common.path import PATH_BACK_ICO


def help():
    """Genera ventana de Quienes somos."""
    text = """
            Somos estudiantes y amigos de diversas carreras de la Facultad de
            Infomatica de la UNLP quienes generamos este trabajo a partir del
            acompañamiento de los profesores y ayudantes de la materia:
                    "Seminario de Lenguajes de Programaciona - Python 2023".
            Durante la cursada pudimos incorporar nuevos conocimientos
            utilizados para crear este proyecto, sin los cuales nos
            hubiese sido un trabajo imposible de realizar. Es por ello
            que agradecemos su tiempo, y esfuerzo dedicados a darnos
            herramientas que podremos utilizar en el futuro.
            Muchas gracias:
                Percara Francisco - Lic. en Informatica
                Bruschi Tomas - Lic. en Informatica
                Alvarez Ayrton - Analista programador Universitario
                Massera Felipe - ATIC
        """
    layout = [
        [sg.T("Quienen somos...", font=FONT_TITLE), sg.Push()],
        [sg.T(text, font=FONT_BODY)],
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
        "UNLPimage - Quienes somos",
        layout,
        element_justification="c",
        size=WINDOW_ABOUT_US_SIZE,
        finalize=True,
        enable_close_attempted_event=True,
    )


def run():
    help_window = help()
    while True:
        event, values = help_window.read()
        if event == "-RETURN-":
            break
        if event == sg.WIN_CLOSE_ATTEMPTED_EVENT:
            confirm = sg.popup_yes_no("¿Está seguro que desea salir?")
            if confirm == "Yes":
                exit()
    help_window.close()

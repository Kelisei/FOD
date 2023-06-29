import PySimpleGUI as sg
import os
import UNLPimage.src.collage.collage as collage_w
from UNLPimage.common.const import WINDOW_SIZE, FONT_TITLE, THEME
from UNLPimage.common.path import (
    PATH_BACK_ICO,
    PATH_BOX_2H,
    PATH_BOX_2V,
    PATH_BOX_2D,
    PATH_BOX_3H,
    PATH_BOX_3I,
    PATH_BOX_3,
    PATH_BOX_4,
    PATH_BOX_6,
)


def collage(list1, list2):
    """funcion que recibe dos listas de nombres de imagenes, usadas
    para mostrar los botones de seleccion de patrones de diseño de
    collage.

    Args:
        list1 (_list_): lista que tiene nombres de imagenes para mostrar
        los iconos de patrones de diseño.
        list2 (_list_): lista que tiene nombres de imagenes para mostrar
        los iconos de patrones de diseño.

    Returns:
        _layout_: retorna la ventana de collage
    """
    layout = [
        [
            sg.Text("Seleccionar diseño de collage", font=FONT_TITLE),
            sg.Push(),
        ],
        [
            [
                sg.Image(
                    source=elem,
                    subsample=1,
                    key=os.path.basename(elem),
                    enable_events=True,
                    pad=((10, 10), (10, 10)),
                )
                for elem in list1
            ],
        ],
        [
            [
                sg.Image(
                    source=elem,
                    subsample=1,
                    key=os.path.basename(elem),
                    enable_events=True,
                    pad=((10, 10), (10, 10)),
                )
                for elem in list2
            ],
        ],
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
        "UNLPimage - Seleccionar patron de Collage",
        layout,
        element_justification="c",
        size=WINDOW_SIZE,
        finalize=True,
        enable_close_attempted_event=True,
    )


def run():
    """funcion que genera una la ventana de seleccion del tipo de collage"""
    list1 = [PATH_BOX_2H, PATH_BOX_2V, PATH_BOX_2D, PATH_BOX_3]
    list2 = [PATH_BOX_3H, PATH_BOX_3I, PATH_BOX_4, PATH_BOX_6]
    sg.theme(THEME)
    window = collage(list1, list2)

    while True:
        event, values = window.read()
        match event:
            case sg.WIN_CLOSE_ATTEMPTED_EVENT:
                confirm = sg.popup_yes_no("¿Está seguro que desea salir?")
                if confirm == "Yes":
                    exit()
            case "-RETURN-":
                break
            case _:
                window.hide()
                collage_w.run(event)
                window.un_hide()
    window.close()

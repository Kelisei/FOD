import json
import PySimpleGUI as sg
from UNLPimage.common.path import PATH_JSON


def save_config(values):
    """
    Crea o sobreescribe el archivo json donde estarian los distintos
    directorios donde se guardan las imagenes, collages o memes,
    y guarda lo que esta en los distintos inputs en el mismo.
    Ya que la informacion anterior esta cargada en los inputs, no se pierde.
    Si no hay espacio en memoria genera un ventana que informa del error.
    @param values: Datos devueltos por el PySimpleGUI.
    @return:
    """
    try:
        directories = open(PATH_JSON, "w")
        directories.write(
            json.dumps(
                {
                    clave: valor
                    for clave, valor in values.items()
                    if not clave.startswith("Browse")
                },
                indent=4,
            )
        )
        directories.close()
    except MemoryError:
        sg.popup_error("ERROR: no hay espacio en memoria")


def reset(paths: dict, window: object):
    """
    Esta funcion resetea los inputs así si le erramos al elegir
    se pone como estuvo al entrar a la ventana.
    @param paths: Diccionario con los caminos a los repositorios
    @param window: Ventana actual de configuracion
    @return: None
    """
    window["-IMAGEPATH-"].update(paths.get("-IMAGEPATH-", ""))
    window["-COLLAGEPATH-"].update(paths.get("-COLLAGEPATH-", ""))
    window["-MEMEPATH-"].update(paths.get("-MEMEPATH-", ""))

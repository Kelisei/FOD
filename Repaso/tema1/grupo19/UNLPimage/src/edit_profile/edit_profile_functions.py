import os
import json
from PIL import Image, ImageDraw

from UNLPimage.common.path import PATH_IMAGE_AVATAR, PATH_DATA_JSON
import UNLPimage.src.new_profile.new_profile_functions as new_functions


# FUNCION PARA EDITAR UN USUARIO EN EL ARCHIVO JSON
def edit_json_user(user: dict) -> None:
    """Esta funcion recibe un diccionario con los datos del usuario buscado.
    Al encontrarlo modifica los datos del mismo (excepto el campo nick)"""
    path = PATH_DATA_JSON
    path_file = os.path.join(path, "usuarios.json")

    with open(path_file, "r", encoding="utf8") as file:
        JSON = json.load(file)
        data = JSON

    for dicc in data:
        if dicc["nick"] == user["nick"]:
            dicc["name"] = user["name"]
            dicc["age"] = user["age"]
            dicc["gender"] = user["gender"]
            dicc["avatar"] = user["avatar"]

    with open(path_file, "w", encoding="utf8") as file:
        file.write(json.dumps(data, indent=4))


# FUNCION PARA VALIDAR SI SE EDITARA O NO UN USUARIO EN EL ARCHIVO JSON
def edit_user(window: object, value: dict, initial_user: dict) -> tuple[(dict, bool)]:
    """Esta funcion recibe la 'window', y 'value'
    (diccionario con valores de los eventos)
    para luego editar el usuario existente en archivo 'usuarios.json'"""
    user = new_functions.read_inputs(window, value, initial_user)
    if new_functions.valid_user(user, window):
        edit_json_user(user)
        new_functions.create_user_img(window["-AVATAR URL-"].get(), user["nick"])
        return (user, True)
    else:
        return (user, False)


# FUNCION PARA SABER SI EL CAMPO GENERO PERTENECE A LAS OPCIONES PREDETERMINADAS
def chosen_gender(gender: str) -> bool:
    """Esta funcion recibe el genero que tiene un usuario en el archivo
    'usuarios.json' si es una de las opciones del elemento combo (masculino
    , femenino, no binario) retornamos true, en cualquier otro caso
    retornamos false"""
    match (gender):
        case "varon cis":
            ok = True
        case "varon trans":
            ok = True
        case "mujer cis":
            ok = True
        case "mujer trans":
            ok = True
        case "no binarie":
            ok = True
        case "otre":
            ok = True
        case _:
            ok = False
    return ok


# FUNCION PARA LLENAR LOS INPUTS CON LOS DATOS DEL USUARIO RECIBIDO COMO PARAMETRO
def fill_inputs(window: object, user: dict) -> None:
    """Esta funcion recibe la ventana, y el usuario:dict en sesion.
    verifica y coloca en pantalla los datos del usuario'"""
    window["-NICK-"].update(user["nick"])
    window["-NAME-"].update(user["name"])
    window["-AGE-"].update(user["age"])
    if chosen_gender(user["gender"]):
        window["-GENDER-"].update(user["gender"])
    else:
        window["-CHECKBOX-"](value=True)
        window["-GENDER INPUT-"](visible=True)
        window["-GENDER INPUT-"].update(user["gender"])
        window["-GENDER-"].update(disabled=(not window["-GENDER-"].Disabled))
    path_avatar = os.path.join(PATH_IMAGE_AVATAR, user["avatar"])
    window["-AVATAR URL-"].update(path_avatar)
    window["AVATAR"].update(source=path_avatar, subsample=4)

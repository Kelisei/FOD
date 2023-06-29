import json
import os
import PySimpleGUI as sg
from UNLPimage.common.const import FONT_BODY
from UNLPimage.common.const import FONT_TITLE
from UNLPimage.common.const import THEME
from UNLPimage.common.const import WINDOW_SIZE
from UNLPimage.common.const import AVATAR_DEFAULT
from UNLPimage.common.path import PATH_IMAGE_AVATAR
from UNLPimage.common.path import PATH_DATA_JSON
from UNLPimage.common.path import PATH_PLUS_ICO
from UNLPimage.src.functions.files_functions import get_user


# INICIO DE LA VENTANA
def start():
    """Crea la ventana con el tema y el layout deseados"""
    sg.theme(THEME)
    layout = [
        [sg.Text("UNLPImage", font=FONT_TITLE), sg.Push()],
        [
            sg.Push(),
            sg.Image(key="-PROFILE_3-", enable_events=True, pad=((0, 0), (100, 0))),
            sg.Image(key="-PROFILE_2-", enable_events=True, pad=((0, 0), (100, 0))),
            sg.Image(key="-PROFILE_1-", enable_events=True, pad=((0, 0), (100, 0))),
            sg.Image(key="-PROFILE_0-", enable_events=True, pad=((0, 0), (100, 0))),
            sg.Image(
                key="-CREATE-",
                source=PATH_PLUS_ICO,
                enable_events=True,
                subsample=0,
                pad=((0, 0), (100, 0)),
            ),
            sg.Push(),
        ],
        [
            sg.Button(
                "Ver mas", key="-SEE_MORE-", font=FONT_BODY, pad=((350, 0), (50, 0))
            )
        ],
    ]
    return sg.Window(
        "Inicio",
        layout,
        size=WINDOW_SIZE,
        finalize=True,
        enable_close_attempted_event=True,
    )


# LECTURA DE USUARIOS
def read_users():
    """Lee el json de usuarios y lo retorna.
    En caso de que no este el archivo indicara que este no existe"""
    route = os.path.join(PATH_DATA_JSON, "usuarios.json")
    try:
        with open(route, "r", encoding="utf-8") as file:
            users = json.load(file)
        return users
    except FileNotFoundError:
        print("EL ARCHIVO QUE INTENTA ABRIR NO EXISTE")


# ACTUALIZAION DE IMAGENES
def set_image(window, users, counter, i, current_users):
    """Recibe window que es la ventana de inico, users que
    es la lista con todos los usuarios y sus datos, counter que
    es un auxiliar que permite tomar el usuario correcto de users,
    i que es un auxiliar para saber que perfil de usuario es el
    que se esta modificando y current_users que es la lista de
    la funcion button_imgs donde se guardan los usuarios de
    acuerdo al counter.
    La funcion toma la imagen del usuario y la actualiza en
    la ventana de inicio para luego agregar el usuario a la lista
    recibida por button_imgs y devolver el counter restandole 1.
    si no tiene imagen de perfil actualiza la ventana con la
    default"""
    img_name = users[counter]["avatar"]
    img_route = os.path.join(PATH_IMAGE_AVATAR, img_name)
    if os.path.exists(img_route):
        window[f"-PROFILE_{i}-"].update(source=img_route, subsample=8)
    else:
        avatar_img = os.path.join(PATH_IMAGE_AVATAR, AVATAR_DEFAULT)
        window[f"-PROFILE_{i}-"].update(source=avatar_img, subsample=8)
    current_users.append(users[counter])
    return counter - 1


# ACTUALIZACION DE BOTONES CON LOS PERFILES A REPRESENTAR
def button_imgs(qty_users, counter, window, users):
    """Recibe qty_users que es la cantidad de usuarios,
    counter que es un auxiliar para elegir los usuarios
    que van a aparecer, window que es la ventana de inicio y
    users que es la lista con todos los usuarios y sus datos.
    La funcion lee los usuarios y los asigna a los
    perfiles en la ventana. Retorna el auxiliar counter para
    ubicar donde seguir en proximas lecturas y asignaciones y
    current_users que son los usuarios que estan siendo
    representados"""
    current_users = []
    for i in range(0, 4):
        if counter >= 0:
            counter = set_image(window, users, counter, i, current_users)
        else:
            if qty_users < 3:
                counter = qty_users
                break
            else:
                counter = qty_users
                counter = set_image(window, users, counter, i, current_users)
    return counter, current_users


# ACTUALIZACION DE IMAGES POST MODIFICACIONES EN OTRAS PANTALLAS
def profile_modifications(profiles, window, i):
    """Recibe profiles que son los usuarios representados
    en la ventana, la ventana que es la ventana de inicio
    e i que es el indice de que perfil es.
    La funcion actualiza la imagen del perfil al
    volver de la ventana main"""
    profiles[i] = get_user(profiles[i]["nick"])
    img_name = profiles[i]["avatar"]
    img_route = os.path.join(PATH_IMAGE_AVATAR, img_name)
    if os.path.exists(img_route):
        window[f"-PROFILE_{i}-"].update(source=img_route, subsample=8)
    else:
        avatar_img = os.path.join(PATH_IMAGE_AVATAR, AVATAR_DEFAULT)
        window[f"-PROFILE_{i}-"].update(source=avatar_img, subsample=8)
        profiles[i]["avatar"] = AVATAR_DEFAULT
    return profiles

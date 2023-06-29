import os
import json
from PIL import Image, ImageDraw
import PySimpleGUI as sg

from UNLPimage.common.path import PATH_DATA_JSON, PATH_IMAGE_AVATAR


# FUNCION PARA DAR DE ALTA UN USUARIO
def new_user(window: object, value: dict) -> bool:
    """Esta funcion recibe la 'window', y 'valor'
    (diccionario con valores de los eventos), luego de validar datos
    ingresados, agrega el usuario nuevo al archivo 'usuarios.json'"""
    user = read_inputs(window, value)
    ok = validate_new_user(user, window)
    if ok:
        add_json_user(user)
        create_user_img(window["-AVATAR URL-"].get(), user["nick"])
    return (user, ok)


# ARMAMOS UN DICCIONARIO CON LOS VALORES INGRESADOS SEGUN SI ESTA O NO EL CHECKBOX
def read_inputs(window: object, value: dict, default="DEFAULT_ICON.png") -> dict:
    """Esta funcion va a tomar los datos del usuario en pantalla en funcion
    de si esta o no seleccionado el 'checkbox'.
    En el caso de los datos personales del usuario 'lee' los inputs
    correspondientes."""
    nick = value["-NICK-"].lower().replace(" ", "")
    name = value["-NAME-"].lower().replace(" ", "")
    age = value["-AGE-"].lower().replace(" ", "")
    gender = value["-GENDER-"].lower()
    gender_input = value["-GENDER INPUT-"].lower().replace(" ", "")

    if not window["-CHECKBOX-"].get():
        user = {
            "nick": nick,
            "name": name,
            "age": age,
            "gender": gender,
            "avatar": f"{nick}.png",
        }
    else:
        user = {
            "nick": nick,
            "name": name,
            "age": age,
            "gender": gender_input,
            "avatar": f"{nick}.png",
        }
    return user


# FUNCION PARA VALIDAR SI PUEDO DAR DE ALTA UN USUARIO
def validate_new_user(user: dict, window: object) -> bool:
    """Esta funcion recibe un usuario:dict y una ventana y retorna
    - TRUE si se puede agregar el usuario
    - FALSE si no se debe agregar"""
    if user_exist(user["nick"]):
        window["-NICK-"].update(background_color="IndianRed4")
        window["-NICK-"].update("el nick ingresado ya existe")
    else:
        if valid_user(user, window):
            return True
        else:
            return False


# FUNCION PARA VERIFICAR SI EL USUARIO INGRESADO ES VALIDO
def valid_user(user: dict, window: object) -> bool:
    """Esta funcion recibe un diccionario y retorna true si alguno de sus
    valores presenta un problema para dar de alta o editar un usuario.
    Tiene en cuenta:
    -nick:  si es vacio
    -name: si es vacio o si tiene numeros
    -age:   si es vacio, si tiene una letra o si esta en rango (18 > age < 75)
    -gender: si es vacio"""
    nick, name, age, gender, avatar = user.values()
    ok = True
    if (nick == "") or (len(nick) < 4) or (len(nick) > 12):
        validate_nick_input(nick, window["-NICK-"])
        ok = False
    if (name == "") or (not name.isalpha()) or (len(name) < 4) or (len(name) > 12):
        validate_name_input(name, window["-NAME-"])
        ok = False
    if (age == "") or (not age.isnumeric()) or ((int)(age) > 75) or ((int)(age) < 18):
        validate_age_input(age, window["-AGE-"])
        ok = False
    if gender == "":
        validate_gender_input(gender, window["-GENDER INPUT-"], window["-GENDER-"])
        ok = False
    return ok


# FUNCION PARA VERIFICAR SI EL NICK INGRESADO ES VALIDO
def validate_nick_input(nick: str, input: sg.Input) -> None:
    """Esta funcion 'lee' el input 'nick', y cuando hay un error
    y en funcion de las validaciones se coloreara el input
    - campo obligatorio
    - entre 4 y 12 caracteres"""

    # SOLO VOY A VALIDAR EL NICK CUANDO ES UN NUEVO PERFIL, EN EDIT TENDRIA ERROR DE NICK EXISTENTE
    if input.ReadOnly == False:
        if nick == "":
            input.update(background_color="IndianRed4")
            input.update("el campo es obligatorio")
        elif (len(nick) < 4) or (len(nick) > 12):
            input.update(background_color="IndianRed4")
            input.update("El nick debe tener entre 4 y 12 letras")


# FUNCION PARA VERIFICAR SI EL NAME INGRESADO ES VALIDO
def validate_name_input(name: str, input: sg.Input) -> None:
    """Esta funcion 'lee' el input 'name', y cuando hay un error
    y en funcion de las validaciones se coloreara el input
    - campo obligatorio
    - solo letras
    - entre 4 y 12 caracteres"""
    if name == "":
        input.update(background_color="IndianRed4")
        input.update("el campo es obligatorio")
    elif not name.isalpha():
        input.update(background_color="IndianRed4")
        input.update("El nombre debe contener solo letras")
    elif (len(name) < 4) or (len(name) > 12):
        input.update(background_color="IndianRed4")
        input.update("El nombre debe tener entre 4 y 12 letras")


# FUNCION PARA VERIFICAR SI AGE INGRESADO ES VALIDO
def validate_age_input(age: str, input: sg.Input) -> None:
    """Esta funcion 'lee' el input 'age', y cuando hay un error
    y en funcion de las validaciones se coloreara el input
    - campo obligatorio
    - solo numeros
    - entre 18 y 75 años"""
    if age == "":
        input.update(background_color="IndianRed4")
        input.update("el campo es obligatorio")
    elif not age.isnumeric():
        input.update(background_color="IndianRed4")
        input.update("El campo solo acepta numeros")
    elif (int)(input.get().replace(" ", "")) > 75 or (int)(
        input.get().replace(" ", "")
    ) < 18:
        input.update(background_color="IndianRed4")
        input.update("Ingrese edad entre 18 y 75 años")


# FUNCION PARA VERIFICAR SI EL GENDER INGRESADO ES VALIDO
def validate_gender_input(gender: str, input: sg.Input, combo: sg.Combo) -> None:
    """Esta funcion 'lee' el combo 'gender', y cuando hay un error
    y en funcion de las validaciones se coloreara el input
    - campo obligatorio (combo)
    - campo obligatorio (input opcional)"""
    if gender == "":
        input.update(background_color="IndianRed4")
        input.update("el campo es obligatorio")
        combo.BackgroundColor = "IndianRed4"
    # COMO CAMBIAR DE COLOR EL COMBO DESPUES DE QUE YA ESTE DECLARADO(EN LA DECLARACION FUNCIONA)
    # YA PROBE .UPDATE(BACK....) Y BACKGROUND_COLOR = ...


# FUNCION QUE MODIFICA EL NOMBRE DE UNA IMAGEN
def rename_img(old_name: str, new_name: str) -> None:
    """Esta funcion recibe un nombre viejo y un nombre nuevo e intercambia
    el nombre del viejo por el nuevo (archivos .png) en la carpeta de avatares"""
    actual_path = os.path.join(PATH_IMAGE_AVATAR, old_name)
    new_path = os.path.join(PATH_IMAGE_AVATAR, f"{new_name}.png")
    os.rename(actual_path, new_path)


# FUNCION PARA DAR DE ALTA UN USUARIO EN EL ARCHIVO 'USUARIOS.JSON'
def add_json_user(user: dict) -> None:
    """Esta funcion recibe un diccionario
    {"nick":str,"name":str,"age":str,"gender":str}
    y lo da de alta en el archivo 'usuarios.json'"""
    path = PATH_DATA_JSON
    path_file = os.path.join(path, "usuarios.json")

    try:
        with open(path_file, "r", encoding="utf8") as file:
            data = json.load(file)
            data.append(user)
    except FileNotFoundError:
        data = [user]

    with open(path_file, "w+", encoding="utf8") as file:
        file.write(json.dumps(data, indent=4))


# FUNCION QUE BLANQUEA EL INPUT
def clear_input(input: sg.Input) -> None:
    """Esta funcion verifica la cantidad de caracteres en el input,
    ya que puede haber sido coloreado por un error anteriormente
    (car < 3 entonces input = #86a6df)"""
    if len(input.get()) < 3:
        input.update(background_color="#86a6df")


# FUNCION PARA VERIFICAR SI UN NICK EXISTE EN EL ARCHIVO 'USUARIOS.JSON'
def user_exist(nick: str) -> bool:
    """Esta funcion recibe un nick y retorna true si el usuario existe
    en el archivo 'usuarios.json', de lo contrario retorna false"""
    path = PATH_DATA_JSON
    path_file = os.path.join(path, "usuarios.json")

    try:
        with open(path_file, "r", encoding="utf8") as file:
            JSON = json.load(file)
            data = JSON

        for dicc in data:
            if dicc["nick"] == nick:
                return True

    except FileNotFoundError:
        return False


# FUNCION QUE FORMATEA LA RUTA DEL AVATAR
def get_img_name(url: str, default="DEFAULT_ICON") -> str:
    """Esta funcion recibe un string con el path de un archivo y
    un parametro por opcional que
    - si el url ingresado es vacio va a retornar el avatar default
    o el valor ingresado como parametro opcional

    retorna solo el nombre del archivo.
    Tiene en cuenta 2 situaciones dependiendo del sistema operativo.
    1- si los directorios estan separados con '/'
    2- si los directorios estan separados con \\"""
    if url == "":
        return default
    if "/" in url:
        name = url.split("/")[-1]
    elif "\\" in url:
        name = url.split("\\")[-1]
    return name


# FUNCION QUE TOMA UNA IMAGEN, LA REDONDEA Y LUEGO LO GUARDA
# EN IMAGE/IMAGE/AVATAR COMO "nick_usuario.png"
def create_user_img(img_path: str, name="DEFAULT_ICON") -> str:
    """Esta funcion recibe una ventana y una ruta de imagen,
    genera una nueva imagen, la guarda en '/image/image/avatar'
    con forma redondeada y con un resize de (1024x1024)"""
    img = Image.open(img_path)
    image = img.resize((1024, 1024))

    mask = Image.new("L", image.size, 0)
    draw = ImageDraw.Draw(mask)
    draw.ellipse((0, 0, image.size[0], image.size[1]), fill=255, outline="black")

    rounded_image = Image.new("RGBA", image.size, 0)
    rounded_image.paste(image, (0, 0), mask=mask)

    path = os.path.join(PATH_IMAGE_AVATAR, name + ".png")
    try:
        rounded_image.save(path)
    except ValueError:
        pass


# FUNCION QUE ELIMINA LA IMAGEN DEL USUARIO QUE NO LLEGO A CREARSE
def delete_img_before_back(nick) -> None:
    """Esta funcion verifica si es necesario eliminar
    una imagen antes de volver al menu de inicio sin crear un perfil"""
    if not nick == "":
        to_delete_nick = f"{nick}.png"
        if os.path.exists(os.path.join(PATH_IMAGE_AVATAR, to_delete_nick)):
            os.remove(os.path.join(PATH_IMAGE_AVATAR, to_delete_nick))


# FUNCION QUE MANEJA CHECKBOX O INPUT DE GENERO
def change_gender_input(input: sg.Input, combo: sg.Combo) -> None:
    """Esta funcion cambia el estado del checkbox (tildado y destildado)
    en funcion de eso, tambien hara visible el input opcional de genero"""
    input.update(visible=(not input.visible))
    combo.update(disabled=(not combo.Disabled))

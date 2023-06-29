import PySimpleGUI as sg
import UNLPimage.src.functions.files_functions as skov
import os
import PIL.Image
import PIL.ImageTk
import PIL.ImageOps
import PIL.ImageDraw


def layout_collage(pattern):
    """Funcion que recibe el nombre de la patron de diseño
    que usaremos para implementar el collage

    Args:
        pattern (_string_): Es el nombre de la imagen de patron seleccionada
        en la ventana "Seleccionar Patron"

    Returns:
        _dict_: devuelve el diccionario con la info del patron de diseño
        de la imagen collage
    """
    try:
        list_dict = skov.open_json("patterns_collage.json")
        filtered_dict = next(
            filter(lambda item: item.get("name") == pattern, list_dict), None
        )
        return filtered_dict
    except FileExistsError:
        raise


def open_csv():
    """Abre el archivo csv "metadata.csv" para filtrar los nombres de
    las imagenes previamente etiquetadas.

    Returns:
        _list_: Lista que contiene los nombres de las imagenes previamente
        etiquetadas
    """
    try:
        data_csv = skov.open_csv("metadata.csv")
        list_relative_path = [element["relative_path"] for element in data_csv]
        list_names_images = [os.path.basename(path) for path in list_relative_path]
        return list_names_images
    except FileExistsError:
        raise


def string_to_tupple(modification_string):
    """funcion que convierte un string a una tupla de numeros
    usados para coordenadas o modificacion de las imagenes

    Args:
        modification_string (_string_): recibe un string con formato par de
        numeros ej: "0,0"

    Returns:
        _tuple_: tupla de numeros usados para modificar o pegar imagenes
    """
    return tuple(map(int, modification_string.split(",")))


def new_pil_image(window):
    """_Funcion que genera una nueva ventana pillow vacia,
    donde posicionaremos nuestras imagenes del collage, actualiza
    la ventana sg.Image  en el layout(components_left) _

    Args:
        window (_PySimpleGUI.PySimpleGUI.Window_): Layout de collage.py

    Returns:
        _PIL.Image.Image_: retorna una imagen modificable usada en collage
    """
    IMAGE_SIZE = 400, 400
    new_image = PIL.Image.new("RGB", IMAGE_SIZE, color="black")
    collage = PIL.ImageTk.PhotoImage(new_image)
    window["-COLLAGE-"].update(data=collage)
    return new_image


def draw_title_on_image(collage, title):
    """Funcion que dibuja sobre la image un texto recibido como
    parametro ingesado por el usuario.

    Args:
        collage (_PIL.Image.Image_): recibe una imagen editable la
        cual sera usada para pegar sobre ella un texto.
        title (_string_): Titulo de la imagen, ingresado en sg.Imput

    Returns:
        _PIL.Image.Image_: devuelve una imagen modificada con texto embebido
    """
    collage_copy = collage.copy()
    draw = PIL.ImageDraw.Draw(collage_copy)
    draw.text((10, 382), title, fill="white")
    return collage_copy


def show_image(window, values, dict_pattern, images_path):
    """Funcion que modifica una imagen principal pegando fotos sobre ellas,
    estas fotos se reciben de metadata.csv, en la cual filtramos el nombre
    de ellas.

    Args:
        window (_PySimpleGUI.PySimpleGUI.Window_): Layout de collage.py
        values (_dict_): diccionario que contiene eventos y valores del
        la ventana.
        dict_pattern (_dict_): diccionario que contiene la info sobre cantidad
        de imagenes a mostrar, los formatos de cada imagen para modificar sus
        medidas y las coordenadas donde seran pegadas las imagenes
        images_path (_string_): Es la ruta relativa que uniremos al nombre
        de las imagenes para poder generar una ruta para cargar la imagen.

    Returns:
        collage  _PIL.Image.Image_ : imagen modificable
        names_list _list_: lista de nombres de imagenes usadas en el collage
        title: Titulo ingresado en el evento sg.Imput
    """
    collage = new_pil_image(window)
    title = values["-TITLE-"]
    names_list = []
    for i in range(int(dict_pattern["number_images"])):
        if values[f"-IMAGE-{i}-"] != "":
            route_image = os.path.join(images_path, values[f"-IMAGE-{i}-"])
            try:
                image = PIL.Image.open(route_image)
                dimension_fit = string_to_tupple(dict_pattern[f"fit_{i}"])
                image = PIL.ImageOps.fit(image, dimension_fit)
                cardinal_paste = string_to_tupple(dict_pattern[f"axes_{i}"])
                collage.paste(image, cardinal_paste)
                names_list.append(values[f"-IMAGE-{i}-"])
            except FileNotFoundError:
                sg.popup_error("Imagen no encontrada")
    if title != "":
        collage = draw_title_on_image(collage, title)
    collage_copy = collage.copy()
    collage_copy = PIL.ImageTk.PhotoImage(collage_copy)
    window["-COLLAGE-"].update(data=collage_copy)
    return collage, names_list, title


def save_image(img, save_path, title="base"):
    """funcion que graba una imagen en la carpeta previamente seleccionada
    en configuracion.

    Args:
        img (_PIL.Image.Image_): imagen pillow que se grabara en memoria.
        save_path (_str_): ruta relativa donde se almacenara la imagen
        title (str, optional): Titulo con el que se almacenara la imagen.
    """
    route = os.path.join(save_path, title + ".jpg")
    img.convert(mode="RGB").save(route)

import PySimpleGUI as sg
import UNLPimage.src.collage.collage_function as collage_function
import UNLPimage.src.classes.log as skov
import UNLPimage.src.functions.files_functions as open_json
from UNLPimage.common.path import PATH_BACK_ICO
import PIL.ImageTk
from UNLPimage.common.const import WINDOW_SIZE, FONT_TITLE, FONT_BODY, THEME


def collage(images_number, images_names):
    """Genera la ventana de programa

    Args:
        images_number (_int_): Recibe el numero de imagenes que componen el
        collage
        images_names (_list_): Lista que contiene el nombre de imagenes
        previamente etiquetadas, para mostrarse en los sg.Combo

    Returns:
        _layout_: retorna la ventana principal de collage
    """
    components_left = [
        [
            sg.Combo(
                images_names,
                key=f"-IMAGE-{elem}-",
                size=(15, 5),
                pad=((10, 50), (10, 0)),
                enable_events=True,
                readonly=True,
            )
        ]
        for elem in range(images_number)
    ]
    title = [
        sg.Text("Generar Collage", font=FONT_TITLE),
        sg.Push(),
        sg.Image(
            source=PATH_BACK_ICO,
            subsample=2,
            key="-RETURN-",
            enable_events=True,
            pad=((0, 0), (0, 0)),
        ),
    ]
    menu_list = [
        [sg.Text("Titulo", font=FONT_BODY, pad=((10, 10), (10, 0)))],
        [
            sg.Input(
                key="-TITLE-",
                font=FONT_BODY,
                size=(35, 2),
                enable_events=False,
                pad=((10, 10), (10, 00)),
            )
        ],
        [sg.B("Actualizar", key="-UPLOAD-", pad=((10, 10), (10, 10)))],
    ]
    components_left += menu_list
    components_right = [
        [sg.Image(key="-COLLAGE-", pad=((0, 0), (0, 0)))],
        [sg.Button("Guardar", key="-SAVE-", border_width=0, pad=((0, 20), (0, 0)))],
    ]
    layout = [
        [
            title,
            sg.Column(components_left),
            sg.Push(),
            sg.Column(components_right),
        ]
    ]
    return sg.Window(
        "UNLPimage - Generar Collage",
        layout,
        element_justification="",
        size=WINDOW_SIZE,
        finalize=True,
        enable_close_attempted_event=True,
    )


def run(pattern_name):
    """Funcion que genera la iteracion de la ventana de collage, recibe como parametro el
    nombre del diseño de patron para la generar la ventana, captando eventos
    de los diferentes elementos que la componen, posibilita la creacion de la image,
    su modificacion y su guardado en memoria, en caso de guardar la imagen crea una
    entrada en el log y almacena los datos del evento.

    Args:
        pattern_name (_str_): recibe el nombre de la imagen del patron
        de diseño previamente seleccionada en la ventana "Seleccion de collage"
    """
    sg.theme(THEME)
    try:
        images_names = collage_function.open_csv()
    except FileExistsError:
        images_names = []
        sg.popup_error("Archivo 'metadata.csv' no encontrado")
    try:
        dict_pattern = collage_function.layout_collage(pattern_name)
        collage_window = collage(int(dict_pattern["number_images"]), images_names)
        image = collage_function.new_pil_image(collage_window)
        image = PIL.ImageTk.PhotoImage(image)
        collage_paths = open_json.open_record()
        names = []
        title = ""
        while True:
            event, values = collage_window.read()
            match event:
                case sg.WIN_CLOSE_ATTEMPTED_EVENT:
                    confirm = sg.popup_yes_no("¿Está seguro que desea salir?")
                    if confirm == "Yes":
                        exit()
                case "-RETURN-":
                    break
                case "-SAVE-":
                    answer = sg.popup_yes_no("¿Confirma los cambios?")
                    if answer == "Yes":
                        collage_function.save_image(
                            image, collage_paths["-COLLAGEPATH-"], title
                        )
                        skov.Log.write_log("generó collage", names, title)
                        break
                case _:
                    image, names, title = collage_function.show_image(
                        collage_window,
                        values,
                        dict_pattern,
                        collage_paths["-IMAGEPATH-"],
                    )
    except FileExistsError:
        sg.popup_error("Archivo 'patterns_collage.json' no encontrado")
    collage_window.close()

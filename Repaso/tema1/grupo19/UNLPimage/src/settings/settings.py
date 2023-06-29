from UNLPimage.common.const import FONT_BODY, FONT_TITLE, THEME, WINDOW_SIZE
from UNLPimage.common.path import PATH_BACK_ICO
import PySimpleGUI as sg
import UNLPimage.src.settings.settings_functions as fran
from UNLPimage.src.functions.files_functions import open_record
from UNLPimage.src.classes.log import Log


def run():
    """
    Esta funcion maneja la ventana de configuracion.
    La funcionalidad principal de esta ventana esta dada por 3 inputs
    y 3 folderbrowse, usando la funcion open_record() creamos un json
    si no esta creado o recuperamos los valores ya guardados
    de los caminos de los distintos repositorios que maneja la app
    y los pone en los inputs.
    Cuando el usuario clickea el folderbrowse y elije un camino este se pone
    en el input, luego si se apreta
    el boton de guardar la nueva informacion se guarda en el json.
    @return: None
    """
    paths_dict = open_record()
    sg.set_options(font=FONT_BODY)
    sg.theme(THEME)

    layout = [
        [
            sg.Text("Configuración", font=FONT_TITLE, pad=(0, 10)),
            sg.P(),
            sg.Image(
                source=PATH_BACK_ICO,
                subsample=2,
                enable_events=True,
                key="-BACK-",
                pad=(0, 10),
            ),
        ],
        [
            sg.Text("Directorio de imagenes"),
            sg.P(),
            sg.InputText(
                default_text=paths_dict.get("-IMAGEPATH-", ""),
                disabled=True,
                key="-IMAGEPATH-",
                pad=(0, 30),
            ),
            sg.FolderBrowse(),
        ],
        [
            sg.Text("Directorio de collages"),
            sg.P(),
            sg.InputText(
                default_text=paths_dict.get("-COLLAGEPATH-", ""),
                disabled=True,
                key="-COLLAGEPATH-",
                pad=(0, 30),
            ),
            sg.FolderBrowse(),
        ],
        [
            sg.Text("Directorio de memes"),
            sg.P(),
            sg.InputText(
                default_text=paths_dict.get("-MEMEPATH-", ""),
                disabled=True,
                key="-MEMEPATH-",
                pad=(0, 30),
            ),
            sg.FolderBrowse(),
        ],
        [
            sg.Button("Guardar", key="-SAVEDIRECTORY-", pad=((0, 10), (125, 0))),
            sg.Button("Resetear", key="-RESET-", pad=((0, 10), (125, 0))),
        ],
    ]
    window = sg.Window(
        "Configuration",
        layout,
        size=WINDOW_SIZE,
        finalize=True,
        element_justification="c",
        enable_close_attempted_event=True,
    )

    while True:
        event, values = window.read()
        if event == "-EXIT-" or event == sg.WIN_CLOSE_ATTEMPTED_EVENT:
            confirm = sg.popup_yes_no("¿Está seguro que desea salir?")
            if confirm == "Yes":
                exit()
        if event == "-BACK-":
            break
        if event == "-SAVEDIRECTORY-":
            answer = sg.popup_yes_no("¿Confirma los cambios?")
            if answer == "Yes":
                fran.save_config(values)
                Log.write_log("Modificación de la configuración")
                break
        if event == "-RESET-":
            answer = sg.popup_yes_no("¿Confirma el reseteo?")
            if answer == "Yes":
                fran.reset(paths_dict, window)
    window.close()

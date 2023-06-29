import PySimpleGUI as sg
from UNLPimage.common.const import WINDOW_ABOUT_US_SIZE, FONT_BODY, FONT_TITLE
from UNLPimage.common.path import PATH_BACK_ICO


def help():
    """Genera la ventana acerca de como se usa la app ULPimage"""
    text = """
    Al iniciar el programa UNLPimage estaras en la ventana de inicio de
    la aplicacion, en ella podras crear un nuevo usuario o elegir uno
    entre los creados. En caso que no aparezca tu perfil podras presionar
    el boton <Ver mas>, el cual actualizara los usuarios en pantalla.
    Una vez seleccionado el perfil la app te mostrara la pantalla de menu
    donde podras elegir entre editar tu perfil, cambiar tus configuraciones,
    visitar la pantalla de ayudas, etiquetar tus fotos, generar memes y
    collage.
    En la ventana "Configuración" podremos configurar las carpetas que utiliza
    la aplicación para busqueda y almacenamiento de nuestras imagenes.
    En la ventana "Etiquetar imágenes" podras realizar diferentes etiquetados
    y cambios en la descripción de las imágenes, así como ver sus datos.
    Tanto la ventana de "Generar meme" y "Generar collage" ,aun no tienen
    funcionalidad.
    """

    layout = [
        [sg.T("Como se usa UNLPimage", font=FONT_TITLE), sg.Push()],
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
        "UNLPimage - Como se usa",
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

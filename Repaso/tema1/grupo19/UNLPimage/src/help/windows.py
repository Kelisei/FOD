import PySimpleGUI as sg
from UNLPimage.common.const import FONT_BODY, WINDOW_SIZE, THEME
from UNLPimage.common.path import PATH_BACK_ICO


def run():
    """Genera la ventana de ayuda. La ventana esta implementada con pestanas
    donde se detalla informacion de funciones de botones de cada ventana"""
    start = [[sg.T(start_txt)]]
    menu = [[sg.T(menu_txt)]]
    new_edit = [[sg.T(new_edit_txt)]]
    collage = [[sg.T(collage_txt)]]
    meme = [[sg.T(meme_txt)]]
    label = [[sg.T(label_txt)]]
    setting = [[sg.T(setting_txt)]]

    tab_group = [
        [
            sg.TabGroup(
                [
                    [
                        sg.Tab("Inicio", start, font=FONT_BODY),
                        sg.Tab(
                            "Nuevo perfil // Editar Perfil", new_edit, font=FONT_BODY
                        ),
                        sg.Tab("Menu", menu, font=FONT_BODY),
                        sg.Tab("Editor Collage", collage, font=FONT_BODY),
                        sg.Tab("Editor Memes", meme, font=FONT_BODY),
                        sg.Tab("Etiquetar de imagenes", label, font=FONT_BODY),
                        sg.Tab("Configuracion", setting, font=FONT_BODY),
                    ]
                ],
                tab_location="centertop",
            )
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

    window = sg.Window("Ayuda - Ventanas", tab_group, size=WINDOW_SIZE)
    sg.theme(THEME)
    while True:
        event, value = window.read()
        match event:
            case sg.WIN_CLOSED | "-RETURN-":
                break
    window.close()


start_txt = """
            En la ventana de inicio podremos seleccionar el perfil con el
            cual queremos realizar las tareas de edicion, etiquetado,
            y creacion de Memes y Collage.
            Tendremos un boton <+> en el lado derecho de los perfiles,
            que nos pemitira acceder a la ventana de creacion de nuevo perfil.
            El boton <Ver Mas> nos permitira ver todos los perfiles
            registrados en la plataforma.
    """
new_edit_txt = """
            Nuevo perfil: Podremos ingresar a la ventana a partir de la ventana
                          de inicio de la aplicacion (Margen Superior derecho).
            Editar perfil: Podremos ingresar desde el icono colocado en ventana
                        de menu (margen superior izquierdo).
            Tanto en la ventana de Nuevo_Perfil // Editar_perfil podremos crear
            nuevos perfiles, para ello necesitaremos ingresar datos:
                    -Nick o Alias: Admite caracteres alfanumerico.
                    -Nombre: Admite caracteres alfanumerico.
                    -Edad: Se podra poner edades admitidas (hasta 85 años).
                    -Genero Autopercibido: Podes elegir en el menu desplegable
                            tu genero, en caso de no sentirte representado por
                            los mostrados en el menu, podras seleccionar "Otro"
                            e ingresar tu genero customizado.
                    -Seleccionar Avatar: Podras elegir entre los avatares
                            predeterminados del sistema. O los tuyos propios,
                            cuyo formato debe ser .PNG .JPG.
            Al presionar "Guardar" se registraran los cambios de perfil y nos
            redireccionaremos a la ventana <Menu>.
    """
menu_txt = """
        En el Menu podremos invocar las tareas de :
            -Volver Atras: Icono en el margen superior izquierdo <Flecha>
                que nos dirigira a la ventana de inicio.
            -Editar Perfil: Icono en el margen superior izquierdo <Persona>
                nos dirigira a la ventana de editar perfil.
            -Configuracion: Icono en el margen superior derecho <Llave>
                nos dirigira a la ventana  de configuracion.
            -Ayuda: Icono en el margen superior derecho (<?>) que nos dirigira
                a la ventana de ayuda.
            -Etiquetar Imagenes: Boton que nos dirigira a la ventana
                de etiquetar imagenes.
            -Generar Collage: Boton que nos dirigira a la ventana de
                generar collage.
            -Generar memes: Boton que nos dirigira a la ventana de
                generar memes.
            -Salida: Boton que al ser presionado cerrara la ventana,
                posterior a la confirmacion de la accion.
    """
collage_txt = """ Aun no tenemos claro la funcion de la ventana.
    """
meme_txt = """ Aun no tenemos claro la funcion de la ventana.
    """
label_txt = """
        La pestaña de etiquetado provee la funcionalidad para ver, revisar y
        ordenar las imágenes para luego utilizar en la pestaña de creación de
        memes y collage, acá podemos ver el nombre, el tamaño, el nombre, las
        dimensiones, y la descripción y etiquetas customizadas de todas las
        imágenes de la carpeta seleccionada como imágenes. Contara con su boton
        <Cancelar> el cual eliminara cualquier cambio no guardado.
    """
setting_txt = """
        En la ventana configuraccion podremos seleccionar directorios:
            - Imagenes: Donde encontraremos las imagenes para etiquetar.
            - Collage: Donde encontraremos las imagenes para generar collage y
                guardarlos.
            - Memes: Donde encontraremos las imagenes para generar memes
                y guardarlos.
        Por defecto iniciamente tendremos nuestras carpetas en:
            \\UNLPimage\\images.
        Estos cambios podran guardarse utilizando utiilizando el boton
            <Guardar> o <Cancelar> los cambios.
    """

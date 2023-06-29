import PySimpleGUI as sg

# sg.theme('Dark Brown')
sg.theme("DarkPurple5")

layout = [
    [sg.Text("Ingrese su tema")],
    [sg.T("Seleccione un color de tema para previsualizarlo")],
    [
        sg.Listbox(
            values=sg.theme_list(), size=(20, 20), key=("-LIST-"), enable_events=True
        )
    ],
    [sg.B("-EXIT-")],
]

window = sg.Window("UNLPimage - Selector de Tema", layout)

while True:
    event, values = window.read()
    print("Event: ", event, " VALOR: ", values)
    match event:
        case sg.WIN_CLOSED | "-EXIT-":
            break
    sg.theme(values["-LIST-"][0])
    sg.popup_get_text("Este es el tema".format(values["-LIST-"][0]))

import PySimpleGUI as sg
import pandas as pd
from UNLPimage.common.path import (
    PATH_DATA_CSV,
    PATH_DATA_JSON,
    PATH_JSON,
    PATH_DEFAULT_COLLAGE,
    PATH_DEFAULT_IMAGES,
    PATH_DEFAULT_MEMES,
    PATH_CSV,
)
import os
import json
import csv


def open_csv(csv_name) -> list:
    route_file = os.path.join(PATH_DATA_CSV, csv_name)
    dict = {}
    try:
        dict = pd.DataFrame.to_dict(pd.read_csv(route_file))
    except FileExistsError:
        print("open_csv in files_function fail")
        raise
    return dict


def open_json(json_name) -> list:
    route = PATH_DATA_JSON
    route_file = os.path.join(route, json_name)
    try:
        with open(route_file, "r", encoding="utf8") as file:
            data = list(json.load(file))
        return data
    except FileExistsError:
        print("open_json in files_function fail")
        raise


# IR A BUSCAR DATOS DE UN USUARIO SELECCIONADO
def get_user(nick: str) -> dict:
    """Esta funcion recibe un string que representa la clave 'nick'
    y si lo encuentra retorna un diccionario que representa al usuario"""
    ruta = PATH_DATA_JSON
    rutaArchivo = os.path.join(ruta, "usuarios.json")

    with open(rutaArchivo, "r", encoding="utf8") as archivo:
        data = list(json.load(archivo))

    user = list(filter((lambda x: x["nick"] == nick), data))

    return user[0]


def open_record():
    """
    Esta funcion intenta abrir el archivo y recupera las rutas dentro o te
    retorna un diccionario vacio.
    @return: dict_paths: diccionario cn los caminos a los respositorios.
    """
    try:
        directories = open(PATH_JSON)
        dict_paths = json.load(directories)
        directories.close()
    except FileNotFoundError:
        dict_paths = {
            "-IMAGEPATH-": PATH_DEFAULT_IMAGES,
            "-COLLAGEPATH-": PATH_DEFAULT_COLLAGE,
            "-MEMEPATH-": PATH_DEFAULT_MEMES,
        }
        try:
            directories = open(PATH_JSON, "w")
            directories.write(
                json.dumps(
                    {clave: valor for clave, valor in dict_paths.items()}, indent=4
                )
            )
            directories.close()
        except MemoryError:
            sg.popup(
                "ERROR: excepcion MemoryError, no se pudo crear el archivo json de rutas"
            )
        except PermissionError:
            sg.popup(
                "ERROR: excepcion PermissionError, no se pudo crear el archivo json de rutas"
            )
    return dict_paths


def try_open_csv(header: list[str], file_name="metadata.csv"):
    """
    Esta funcion intenta abrir el csv, si no existe creamos el archivo y
    le escribimos la cabecera con las
    las columnas que necesitamos.
    @param header: Contiene un lista de strings con header a poner si
    elcommand:black-formatter.showLogs
    csv no existe.
    @param file_name: Nombre del archivo a abrir/crear.
    """
    try:
        tags = open(os.path.join(PATH_CSV, file_name), "r", encoding="utf-8")
        tags.close()
    except FileNotFoundError:
        try:
            with open(os.path.join(PATH_CSV, file_name), "w", newline="") as file:
                writer = csv.writer(file)
                writer.writerow(header)
        except MemoryError:
            sg.popup(f"ERROR: excepcion MemoryError, no se pudo crear el {file_name}")
        except PermissionError:
            sg.popup(
                f"ERROR: excepcion PermissionError, no se pudo crear el {file_name}"
            )

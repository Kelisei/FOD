from UNLPimage.common.path import PATH_CSV
import csv
import os
from datetime import datetime


class Log:
    """
    Esta clase tiene la funcionalidad para poder guardar en
    un archivo llamado logs.csv aquellos
    acciones como modificado de una imagen nueva, modificado
    de una imagen ya etiquetada o cambio
    en la configuración.
    """

    nick = "default"

    @classmethod
    def try_open_logs(cls):
        """
        Este metodo de clase se utiliza para chequear que el
        archivo de logs existe, para así poder escribir a el,
        sino lo intenta crear. De no poderlo crear esto no
        es comunicado al usuario. Sino que se maneja internamente,
        pues es algo que no afecta directamemente a funcionamiento
        de la aplicación.
        """
        try:
            tags = open(os.path.join(PATH_CSV, "logs.csv"), "r", encoding="utf-8")
            tags.close()
        except FileNotFoundError:
            try:
                with open(os.path.join(PATH_CSV, "logs.csv"), "w", newline="") as file:
                    writer = csv.writer(file)
                    writer.writerow(["date", "nick", "operation", "values", "text"])
            except Exception as e:
                print(f"No se pudo crear el archivo de logs | {e}")

    @classmethod
    def write_log(cls, operation: str, values="", text=""):
        """
        Este metodo de clase intenta abrir el archivo de logs en
        modo append para guardar una acción realizada por el usuario.
        Si hay un excepción es manejada internamente, pero no para el programa.
        @param operation: esta es la operación realizada por el usuario.
        """
        try:
            with open(
                os.path.join(PATH_CSV, "logs.csv"), "a", newline="", encoding="utf-8"
            ) as file:
                timestamp = datetime.timestamp(datetime.now())
                date = datetime.fromtimestamp(timestamp)
                log = [
                    date.strftime("%m/%d/%Y, %H:%M:%S"),
                    cls.nick,
                    operation,
                    values,
                    text,
                ]
                writer_obj = csv.writer(file)
                writer_obj.writerow(log)
        except Exception as e:
            print(f"No se pudo guardar la acción en logs.csv | {e}")

# Grupo 19
====================
# Notas:
### Menu de inicio no recarga la informacion del JSON al volver a esa venta

No requiere instalacion
----------------------

``` python  grupo19/UNLPimage/main.py ```
### Licensia:
  Copyright [2023] [Massera Felipe, Alvarez Ayrton, Percara Francisco, Bruschi Tomas]

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
### Desarollo:
  El programa fue desarrollado dividiendonos cada pantalla entre los integrantes
  Bruschi Tomas: se encargo de la pantalla start, memes y el readme.
  Felipe Massera: se encargo de la pantalla main, collage y help.
  Alvarez Ayrton: se encargo de la pantalla new profile y edit profile.
  Percara Francisco: se encargo de la pantalla labelling y settings.
  Tras realizar las ventanas se realizaron cambios en el codigo para que sea mas
  claro y se implementaron formas de aprovechar los recursos de manera mas eficiente
  tras dialogarse y llegarse a un concenso entre los integrantes del grupo.
### Archivos:
  Los archivos que se pueden borrar en este programa serian los archivos de la carpeta
  fonts ubicada en la carpeta UNLPimage\static, 
  los archivos de todas las carpetas de la carpeta UNLPimage\images exceptuando el archivo
  "DEFAULT_ICON.png", los archivos readme que estan en distintas carpetas y finalmente 
  los archvios json y csv que se encuentran en las carpetas csv_files y json_files en UNLPimage\data.
  El resto de archivos no deberian de ser borrados.
### Carpetas:
  Ninguna carpeta deberia de ser eliminada.
### Formatos de imagenes:
  Nuestro programa soporta el uso de imagenes de tipo jpg, jpeg y png con las que puede
  hacer distintos tipos de operaciones y modificaciones como collages, memes y personalizar
  su perfil.
### Funcionamiento del generador de memes y el generador de collages:
  Estas funciones estan todavia pendientes a la hora de esta entrega, una vez que
  se implementen se explicaran acordemente.
### Librerias usadas:
  Utilizamos una variedad de librerias para realizar distintas operaciones durante
  el programa. Estas serian:
  PySimpleGUI. Version: 4.60.4
  json. Version: 2.0.9
  PIL de la cual utilizamos image e imagedraw. Version: 9.5.0
  csv. Version: 1.0
### Python
  Este programa fue realizado con la version 3.11.2 de python y se trabajo con el
  mediante Visual Studio Code.
### Guia de instalacion:
  Todavia no tenemos un metodo de instalacion mas que tener descargados los archivos y
  ejecutar el programa directamente. En el momento en que se tenga una manera de instalarse
  esta guia sera actualizada.
### Configuraciones posibles:
  Nuestro programa al enfocarse en la edicion de memes y creaciones de collages permitimos
  que se configuren las carpetas de las cuales se toman o guardan las imagenes tanto para la edicion de memes y
  la creacion de collages. La carpeta que contiene las imagenes a utilizar por el usuario en el 
  programa tambien puede ser modificada. Tambien permitimos una personalizacion del perfil 
  que va desde la foto de perfil hasta el genero, nombre, edad y finalmente un nick que no puede 
  ser modificado una vez seleccionado.
## Agradecimientos:
  Queremos expresar nuestros agradecimientos tanto a los profesores como ayudantes de la materia
  "Seminario de Lenguajes de Programacion - Python 2023" por su amplio apoyo y contribucion a este
  proyecto y guiarnos en los momentos que tuvieramos dudas sobre cualquier problema que nos surgiera
  durante el desarollo.
  Especialmente queremos darle las gracias a nuestro ayudante Facundo Diaz por acompanarños durante
  este proyecto y a su disponibiladad a la hora de ayudarnos a implementar nuevas soluciones que
  no hubieramos pensado frente a distintos problemas que surgieron a lo largo de nuestro proyecto.
  Desde ya muchas gracias:
    Percara Francisco - Lic. en Informatica.
    Bruschi Tomas - Lic. en Informatica.
    Alvarez Ayrton - Analista programador Universitario.
    Massera Felipe - Analista en tecnologias de la informacion y la comunicacion.
## Guia de uso:
  ### Start:
    Es la primer ventana que aparece al iniciar el programa y cuenta con distintas funcionalidades que
    serian un boton <+> que permite ir a la ventana de new profile con el fin de crear un nuevo perfil
    en la aplicacion. Luego de que se cuente con al menos 1 perfil, van a aparecer la imagenes seleccionadas
    para los perfiles al lado del boton <+>, con las que se puede interactuar con el fin de acceder a la 
    ventana main con ese perfil. Finalmente cuenta con un boton llamado "ver mas" que permite mostrar mas
    perfiles en caso de que haya mas de 4 creados. 
  ### New profile:
    Esta ventana aparece cuando clickeas el <+> en start. En esta ventana se muestra un menu en el que se puede
    escribir el nick/alias que es permanente una vez creado y tambien el nombre del usuario, la edad y el genero que 
    puede ser elegido de 2 formas que serian una lista que contiene masculino, femenino y no binario o debajo de la 
    lista una opcion de "otro" en caso de no sentirse identificado con ninguno de estos, lo que abre una casilla de 
    texto para ingresar el genero deseado. Finalmente en el lado derecho de la ventana se visualiza la foto de perfil y 
    un boton de "Seleccionar Avatar" que permite cambiar el avatar que se esta utilizando. Al darle a guardar se ingresara 
    a la ventana main con el nuevo perfil y en caso de darle a la flecha en la esquina derecha superior se volvera a la 
    ventana start y no se guardaran los datos del perfil a crear.
  ### Main:
    Esta es la ventana principal del programa y cuenta con acceso al resto de ventanas. Tiene una variedad
    de botones que realizan las siguientes funciones:
    Flecha (esquina superior izquierda): Permite volver a la ventana start y seleccionar otro perfil o crear
    uno nuevo.
    Icono humano generico (esquina superior izquierda): Permite acceder a la ventana de edit profile y
    cambiar los datos del perfil actual.
    Llave inglesa (esquina superior derecha): Permite acceder a la ventana de configuracion para configurar
    las carpetas que utiliza la aplicacion.
    Signo de pregunta (Esquina superior derecha): Permite acceder a la ventana de ayuda con el fin de obtener
    explicaciones sobre la aplicacion.
    Boton "Etiquetar imagenes": Permite acceder a la ventana de de Etiquetar imagenes en la que realizar
    distintos etiquetados y cambios en la descripcion en las imagenes y tambien ver los datos de estas.
    Boton "Generar meme": Permite acceder a la ventana de generar meme que todavia no tiene funcionalidad
    Boton "Generar collage": Permite acceder a la ventana de generar collage que todavia no tiene funcionalidad
    Boton "Salir": Permite salir de la aplicacion directamente.
    En el centro de la pantalla se muesta la imagen del perfil y debajo se encuentra el nombre del usuario.
  ### Meme:
    Actualmente la ventana no tiene una funcionalidad y cuando se le implemente su correspondiente
    funcion se actualizara su guia de uso y se accede mediante la ventana main.
  ### Collage:
    Actualmente la ventana no tiene una funcionalidad y cuando se le implemente su correspondiente
    funcion se actualizara su guia de uso y se accede mediante la ventana main.
  ### Settings:
    En esta ventana que se accede desde la ventana main se puede modificar las carpetas con las que 
    la aplicacion puede trabajar mediantelos botones browse al lado a la derecha de la ventana. 
    Las carpetas que utiliza son destinadas paralas imagenes, para los collages y para los memes y lo 
    que se guarda es el direccion hasta la carpeta. Una vez modificados se puede utilizar el boton resetear 
    para deshacer los cambios hechos antes de guardalos, si se utiliza el boton guardar los cambios se 
    mantendran y al resetearlos se utilizaran las nuevas direcciones guardadas a la carpeta. 
    Para salir de la ventana se clickea la flecha en la esquina superior derecha.
  ### Labelling:
    Se accede atravez del main y permite realizar distintas acciones con las imagenes en un directorio ya
    seleccionado.
    La ventana muestra en la parte superior central la direccion del directorio donde estan las imagenes, en 
    el lado izquierdo muestra una lista con las imagenes que se encuentran en el directorio seleccionado y con 
    las que se puede trabajar una vez seleccionadas mediante un click sobre ellas y finalmente en el lado derecho
    de la ventana se muestra la imagen seleccionda junto a sus datos que son el nombre, las dimensiones,
    su tamaño en megabytes, los tags y la descripcion. La funcion principal de la ventana es agregar o eliminar tags que 
    tienen que ser separados con comas por el usuario y tambien agregarle o modificar la descripcion, pero para 
    que estos dos ultimos datos se guarden se tiene que clickear el boton "guardar cambios" ya que en caso de 
    que use la flecha en la esquina superior derecha sin utilizar el boton no se guardaran los cambios hechos 
    a la descripcion ni los tags agregados.
  ### Edit profile:
    Esta ventana aparece cuando clickeas el boton de humano generico en main. En esta ventana
    se muestra un menu en el que puede modifcar el nombre del usuario, la edad y el genero que puede ser 
    modificado de 2 formas que serian una lista que contiene masculino, femenino y no binario o debajo de la 
    lista una opcion de "otro" en caso de no sentirse identificado con ninguno de estos, lo que abre una casilla 
    de texto para ingresar el genero deseado. Finalmente en el lado derecho de la ventana se visualiza la foto 
    de perfil y un boton de "Seleccionar Avatar" que permite cambiar el avatar que se esta utilizando.
    Al darle a guardar se regresara a la ventana main con el perfil modificado y en caso de darle a la flecha
    en la esquina derecha superior se volvera a la ventana main y no se guardaran los cambios al perfil.
  ### Help:
    Es una ventana accedible desde la ventana main que presenta 3 botones que muestran 
    distintas ventanas con informacion sobre distintos aspectos de la aplicacion:
    Como funciona UNLPimage: Muestra una guia de como usar la aplicacion 
    y los pasos estan divididos por ventana con el fin de que sea mas comprensible de leer. 
    INFO ventanas: Muestra la informacion de las ventanas separadas por tabs y gracias a esto se 
    puede elegir ver la informacion de la ventana que se desea buscar y no todas al mismo tiempo.
    Quienes Somos: Muestra los agradecimientos a los profesores y ayudantes de la catedra que nos
    ayudaron con el proyecto y muestra el nombre de los integrantes del grupo y sus carreras.

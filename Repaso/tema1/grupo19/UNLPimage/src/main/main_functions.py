from UNLPimage.common.path import PATH_IMAGE_AVATAR
from UNLPimage.common.const import AVATAR_DEFAULT
import os


def load(menu_window, dicci):
    """Recarga la imagen <AVATAR> del diccionario en la Ventana main"""
    avatar_img = os.path.join(PATH_IMAGE_AVATAR, dicci["avatar"])
    if os.path.exists(avatar_img):
        menu_window["-PFP-"].update(source=avatar_img, subsample=4)
    else:
        avatar_img = os.path.join(PATH_IMAGE_AVATAR, AVATAR_DEFAULT)
        dicci["avatar"] = AVATAR_DEFAULT
        menu_window["-PFP-"].update(source=avatar_img, subsample=4)

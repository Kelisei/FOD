import os


PATH = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))


def path(*args):
    return os.path.join(PATH, "UNLPimage", *args)


PATH_SETTINGS_ICO = path("static", "icon", "-settings-big-.png")
PATH_PLUS_ICO = path("static", "icon", "-plus-icon-.png")
PATH_HELP_ICO = path("static", "icon", "-help-ldark-big-.png")
PATH_BACK_ICO = path("static", "icon", "-back-big-.png")
PATH_BOX_2V = path("static", "icon", "-box-2v-.png")
PATH_BOX_2H = path("static", "icon", "-box-2h-.png")
PATH_BOX_2D = path("static", "icon", "-box-2d-.png")
PATH_BOX_3 = path("static", "icon", "-box-3-.png")
PATH_BOX_3I = path("static", "icon", "-box-3i-.png")
PATH_BOX_3H = path("static", "icon", "-box-3h-.png")
PATH_BOX_4 = path("static", "icon", "-box-4-.png")
PATH_BOX_6 = path("static", "icon", "-box-6-.png")
PATH_PFP_ICO = path("static", "icon", "-pfp-big-.png")
PATH_IMAGE_AVATAR = path("images", "avatar")
PATH_DATA_JSON = path("data", "json_files")
PATH_DATA_CSV = path("data", "csv_files")
PATH_DEFAULT_IMAGES = path("images", "images")
PATH_DEFAULT_MEMES = path("images", "meme")
PATH_DEFAULT_COLLAGE = path("images", "collage")
PATH_JSON = path("data", "json_files", "directories.json")
PATH_CSV = path("data", "csv_files")
PATH_FONT = path("static", "font", "Roboto-Bold.ttf")

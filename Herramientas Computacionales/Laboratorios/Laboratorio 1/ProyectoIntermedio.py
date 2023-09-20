
directorio = "./Archivos/edad.txt"

def archivo_a_lista(directorio):
    lineas = []  # Inicializa una lista vacía
    
    try:
        # Abre el archivo en modo lectura
        with open(directorio, "r") as archivo:
            # Lee el contenido del archivo línea por línea
            lineas = archivo.readlines()
    except FileNotFoundError:
        print("El archivo no existe.")
    
    return lineas


edad=archivo_a_lista(directorio)


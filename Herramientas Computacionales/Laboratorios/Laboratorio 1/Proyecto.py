directorio = "./Archivos/tesoro.txt"

def read_txt():
    with open(directorio, "r") as f:
        lines = f.readlines()
    return lines

lines_read = read_txt()

# Ahora puedes hacer algo con las líneas leídas, por ejemplo, imprimir el contenido
for line in lines_read:
    print(line)
    
directorio = "./Archivos/tesoro.txt"

def read_txt():
    with open(directorio, "r") as f:
        lines = f.readlines()
    return lines

lines_read = read_txt()

# Ahora puedes hacer algo con las líneas leídas, por ejemplo, imprimir el contenido
for line in lines_read:
    print(line)


##Watermelon


def watermelon(w):
    for a in range(w):
        for b in range(w):
            if a+b==w:
                if a%2==0 and b%2==0:
                    print(a,b)
                    return True
    return False

prueba_wa=watermelon(80)

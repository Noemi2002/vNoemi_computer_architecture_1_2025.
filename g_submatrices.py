import os

def cargar_matriz(nombre_archivo):
    with open(nombre_archivo, 'r') as f:
        valores = [int(linea.strip()) for linea in f.readlines()]
    matriz = [valores[i*100:(i+1)*100] for i in range(100)]
    return matriz

def generar_submatrices(matriz, carpeta_salida):
    os.makedirs(carpeta_salida, exist_ok=True)  # Crea la carpeta si no existe
    contador = 0
    for i in range(99):  # Hasta fila 98 para formar 2x2
        for j in range(99):  # Hasta columna 98
            submatriz = [
                matriz[i][j],
                matriz[i][j+1],
                matriz[i+1][j],
                matriz[i+1][j+1]
            ]
            guardar_submatriz(submatriz, contador, carpeta_salida)
            contador += 1

def guardar_submatriz(submatriz, numero, carpeta_salida):
    nombre = os.path.join(carpeta_salida, f"submatriz_{numero}.txt")
    with open(nombre, 'w') as f:
        for valor in submatriz:
            f.write(f"{valor}\n")

# Uso
carpeta_destino = "submatrices"
matriz = cargar_matriz("pixeles_cuadrante.txt")
generar_submatrices(matriz, carpeta_destino)

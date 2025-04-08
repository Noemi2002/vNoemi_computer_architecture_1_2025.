def txt_a_matriz(input_txt, output_txt, filas=100, columnas=100):
    """
    Convierte un archivo con un valor por línea a formato de matriz.

    Args:
        input_txt (str): Archivo de entrada con un valor por línea
        output_txt (str): Archivo de salida con formato de matriz
        filas (int): Número de filas de la matriz
        columnas (int): Número de columnas de la matriz
    """
    # Leer todos los valores del archivo
    with open(input_txt, 'r') as f:
        valores = [line.strip() for line in f.readlines()]

    # Verificar que tenemos suficientes valores
    if len(valores) != filas * columnas:
        raise ValueError(f"Se esperaban {filas * columnas} valores, pero hay {len(valores)}")

    # Escribir la matriz en el archivo de salida
    with open(output_txt, 'w') as f:
        for i in range(filas):
            # Obtener los valores para esta fila
            inicio = i * columnas
            fin = inicio + columnas
            fila = valores[inicio:fin]

            # Escribir la fila separando los valores con espacios
            f.write(' '.join(fila) + '\n')

    print(f"Matriz {filas}x{columnas} guardada en {output_txt}")


# Ejemplo de uso
txt_a_matriz(
    input_txt='pixeles_cuadrante.txt',  # Archivo con 10000 valores (1 por línea)
    output_txt='matriz.txt',  # Archivo de salida con formato matriz
    filas=100,
    columnas=100
)
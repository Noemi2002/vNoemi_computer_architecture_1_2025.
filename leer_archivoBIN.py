def reordenar_bytes_pares(input_bin, output_txt, mapeo_pares):
    """
    Versión donde especificas pares (pos_original, pos_destino).

    Args:
        mapeo_pares (dict): Diccionario {pos_original: pos_destino}.
    """
    with open(input_bin, 'rb') as f:
        bytes_originales = list(f.read())

    bytes_reordenados = [None] * len(bytes_originales)
    for orig, dest in mapeo_pares.items():
        bytes_reordenados[dest] = bytes_originales[orig]

    with open(output_txt, 'w') as f:
        for byte in bytes_reordenados:
            f.write(f"{byte}\n")


# Ejemplo de uso:
mapeo = {
    0: 0, 1: 3, 2: 12, 3: 15,
    4: 1, 5: 2, 6: 4, 7: 8,
    8: 13, 9: 14, 10: 7, 11: 11,
    12: 5, 13: 6, 14: 9, 15: 10
}
archivo_binario = 'ensamblador/algo/output.bin'
archivo_texto = 'prueba.txt'
reordenar_bytes_pares(archivo_binario, archivo_texto, mapeo)


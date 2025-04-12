import numpy as np


def cargar_submatrices_interpoladas(n_submatrices):
    submatrices = []
    for i in range(n_submatrices):
        filename = f"interpolacion/interpolado{i}.img"
        with open(filename, 'r') as f:
            valores = [int(linea.strip()) for linea in f.readlines()]

        # Convertir a matriz 4x4
        matriz = np.array(valores).reshape(4, 4)
        submatrices.append(matriz)
    return submatrices


def reconstruir_matriz(submatrices):

    # Tamaño de la submatriz interpolada
    k_interpolado = 4
    # Tamaño de la matriz original
    n_original = 100

    # Tamaño de la matriz reconstruida
    n_reconstruido = (n_original - 1) * (k_interpolado - 1) + 1
    matriz_reconstruida = np.zeros((n_reconstruido, n_reconstruido))

    paso = k_interpolado - 1

    # Llenar la matriz reconstruida
    idx = 0
    for i in range(n_original - 1):
        for j in range(n_original - 1):
            submatriz = submatrices[idx]

            # Posición en la matriz reconstruida
            x = i * paso
            y = j * paso

            # Evitar solapamiento
            if i == 0 and j == 0:
                matriz_reconstruida[x:x + k_interpolado, y:y + k_interpolado] = submatriz
            elif i == 0:
                matriz_reconstruida[x:x + k_interpolado, y + 1:y + k_interpolado] = submatriz[:, 1:]
            elif j == 0:
                matriz_reconstruida[x + 1:x + k_interpolado, y:y + k_interpolado] = submatriz[1:, :]
            else:
                matriz_reconstruida[x + 1:x + k_interpolado, y + 1:y + k_interpolado] = submatriz[1:, 1:]
            idx += 1
    return matriz_reconstruida

# Función principal
def matriz_final():
    n_submatrices = 9801  # Para una matriz 100x100
    submatrices = cargar_submatrices_interpoladas(n_submatrices)
    matriz_final = reconstruir_matriz(submatrices)

    # Guardar la matriz final (opcional)
    np.savetxt("matriz_reconstruida.img", matriz_final, fmt="%d")


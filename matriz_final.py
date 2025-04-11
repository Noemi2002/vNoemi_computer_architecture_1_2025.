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


def reconstruir_matriz(submatrices, n_original=100):
    # Tamaño de la submatriz interpolada (4x4 en tu ejemplo)
    k_interpolado = 4

    # Tamaño de la matriz reconstruida (ajustado por interpolación)
    # Cada submatriz 2x2 original se interpoló a 4x4, pero hay solapamiento
    # La matriz final tendrá: (n_original - 1) * (k_interpolado - 1) + 1
    n_reconstruido = (n_original - 1) * (k_interpolado - 1) + 1
    matriz_reconstruida = np.zeros((n_reconstruido, n_reconstruido))

    # Tamaño del paso (cada submatriz original estaba en pasos de 1x1)
    paso = k_interpolado - 1

    # Llenar la matriz reconstruida
    idx = 0
    for i in range(n_original - 1):
        for j in range(n_original - 1):
            submatriz = submatrices[idx]
            # Posición en la matriz reconstruida
            x = i * paso
            y = j * paso
            # Tomamos solo la parte no solapada (excepto para la primera submatriz)
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


# Uso
n_submatrices = 9801  # Para una matriz 100x100
submatrices = cargar_submatrices_interpoladas(n_submatrices)
matriz_final = reconstruir_matriz(submatrices)

# Guardar la matriz final (opcional)
np.savetxt("matriz_reconstruida.img", matriz_final, fmt="%d")
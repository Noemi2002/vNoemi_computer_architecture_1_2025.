import subprocess
import shutil
import os

# Función para convertir texto → binario
def escribir_binario(input_txt, output_bin):
    with open(input_txt, "r") as f_in, open(output_bin, "wb") as f_out:
        for line in f_in:
            num = int(line.strip())
            if 0 <= num <= 255:
                f_out.write(bytes([num]))
            else:
                print(f"❌ Valor fuera de rango en {input_txt}: {num}")

# Función para reordenar bytes según mapeo
def reordenar_bytes_pares(input_bin, output_txt, mapeo_pares):
    with open(input_bin, 'rb') as f:
        bytes_originales = list(f.read())

    bytes_reordenados = [None] * len(bytes_originales)
    for orig, dest in mapeo_pares.items():
        bytes_reordenados[dest] = bytes_originales[orig]

    with open(output_txt, 'w') as f:
        for byte in bytes_reordenados:
            f.write(f"{byte}\n")

# Mapeo definido para la interpolación
mapeo = {
    0: 0, 1: 3, 2: 12, 3: 15,
    4: 1, 5: 2, 6: 4, 7: 8,
    8: 13, 9: 14, 10: 7, 11: 11,
    12: 5, 13: 6, 14: 9, 15: 10
}

# Ruta base del proyecto (ajustá si hace falta)
base_dir = "/home/noemi/Descargas/Proyecto1/Repo/vNoemi_computer_architecture_1_2025."  # o usar os.path.abspath...

carpeta_submatrices = os.path.join(base_dir, "submatrices")
ruta_ensamblador = os.path.join(base_dir, "ensamblador/algo")
ejecutable = "./algoritmo"
carpeta_output = os.path.join(base_dir, "resultados")
carpeta_interpolacion = os.path.join(base_dir, "interpolacion")

# Crear carpetas necesarias
os.makedirs(carpeta_output, exist_ok=True)
os.makedirs(carpeta_interpolacion, exist_ok=True)

# Procesar submatrices del 0 al 9800
for i in range(0, 9801):
    nombre_archivo = f"submatriz_{i}.img"
    ruta_submatriz = os.path.join(carpeta_submatrices, nombre_archivo)

    if not os.path.exists(ruta_submatriz):
        print(f"❌ Archivo no encontrado: {ruta_submatriz}, saltando...")
        continue

    # Convertir a binario crudo para input
    input_bin = os.path.join(ruta_ensamblador, "input.img")
    escribir_binario(ruta_submatriz, input_bin)

    # Ejecutar el ensamblador
    subprocess.run([ejecutable], cwd=ruta_ensamblador)

    # Mover output generado
    output_bin = os.path.join(ruta_ensamblador, "output.img")
    nuevo_output_bin = os.path.join(carpeta_output, f"output{i}.img")
    shutil.move(output_bin, nuevo_output_bin)

    # Aplicar reordenamiento e interpolación
    archivo_interpolado = os.path.join(carpeta_interpolacion, f"interpolado{i}.img")
    reordenar_bytes_pares(nuevo_output_bin, archivo_interpolado, mapeo)

    print(f"✔ Procesado submatriz_{i}.img → output{i}.img → interpolado{i}.txt")

print("✅ ¡Todos los archivos fueron procesados e interpolados!")

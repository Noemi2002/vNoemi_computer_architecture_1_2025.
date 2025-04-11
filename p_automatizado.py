import subprocess
import shutil
import os

def escribir_binario(input_txt, output_bin):
    with open(input_txt, "r") as f_in, open(output_bin, "wb") as f_out:
        for line in f_in:
            num = int(line.strip())
            if 0 <= num <= 255:
                f_out.write(bytes([num]))
            else:
                print(f"❌ Valor fuera de rango en {input_txt}: {num}")

# Ruta base del proyecto
base_dir = "/home/noemi/Descargas/Proyecto1/Repo/vNoemi_computer_architecture_1_2025."

# Rutas relativas a la raíz del proyecto
carpeta_submatrices = os.path.join(base_dir, "submatrices")
ruta_ensamblador = os.path.join(base_dir, "ensamblador/algo")
ejecutable = "./algoritmo"
carpeta_output = os.path.join(base_dir, "resultados")

# Crear carpeta de resultados si no existe
os.makedirs(carpeta_output, exist_ok=True)

# Procesar submatrices del 0 al 9800
for i in range(0, 9801):
    nombre_archivo = f"submatriz_{i}.img"
    ruta_submatriz = os.path.join(carpeta_submatrices, nombre_archivo)

    if not os.path.exists(ruta_submatriz):
        print(f"❌ Archivo no encontrado: {ruta_submatriz}, saltando...")
        continue

    # Convertir archivo de texto plano a binario crudo
    input_bin = os.path.join(ruta_ensamblador, "input.img")
    escribir_binario(ruta_submatriz, input_bin)

    # Ejecutar el ensamblador
    subprocess.run([ejecutable], cwd=ruta_ensamblador)

    # Guardar output
    output_generado = os.path.join(ruta_ensamblador, "output.img")
    nuevo_nombre_output = os.path.join(carpeta_output, f"output{i}.img")
    shutil.move(output_generado, nuevo_nombre_output)

    print(f"✔ Procesado submatriz_{i}.img → output{i}.img")

print("✅ ¡Todos los archivos procesables fueron manejados correctamente!")

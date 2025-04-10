def escribir_binario(input_txt, output_bin):
    with open(input_txt, "r") as f_in, open(output_bin, "wb") as f_out:
        for line in f_in:
            num = int(line.strip())       # Convertir cada línea a entero
            if 0 <= num <= 255:           # Asegurar que cabe en un byte
                f_out.write(bytes([num]))  # Escribir como byte
            else:
                print(f"Valor fuera de rango: {num}")


escribir_binario(
    input_txt='submatrices/submatriz_0.img',  # Archivo con 10000 valores (1 por línea)
    output_bin='submatrices/valor.bin',  # Archivo de salida con formato matriz

)
#!/bin/bash

# Validar que se pase una carpeta como argumento
if [ -z "$1" ]; then
  echo "Uso: $0 <ruta_de_la_carpeta>"
  exit 1
fi

# Verificar si la carpeta existe
if [ ! -d "$1" ]; then
  echo "La carpeta $1 no existe."
  exit 1
fi

# Archivo de salida
OUTPUT_FILE="reporte_archivos.txt"
> "$OUTPUT_FILE"  # Limpiar archivo si existe

# Variables para acumular el tamaño total en bytes
total_size=0

# Recorrer cada archivo en la carpeta
for file in "$1"/*; do
  if [ -f "$file" ]; then
    # Obtener el tamaño del archivo en bytes
    size_bytes=$(stat --format="%s" "$file")
    
    # Convertir el tamaño a una unidad más legible
    size_human=$(du -h "$file" | cut -f1)
    
    # Obtener el nombre del archivo
    filename=$(basename "$file")
    
    # Escribir el nombre del archivo y su tamaño en el archivo de salida
    echo "$filename -> $size_human" >> "$OUTPUT_FILE"
    
    # Sumar el tamaño al total
    total_size=$((total_size + size_bytes))
  fi
done

# Convertir el tamaño total a una unidad legible
total_human=$(numfmt --to=iec --suffix=B --format="%.2f" "$total_size")

# Escribir el tamaño total en el archivo de salida
echo "Total: $total_human" >> "$OUTPUT_FILE"

# Mostrar el archivo de salida
cat "$OUTPUT_FILE"

# Incluya aquí las instrucciones necesarias para ejecutar su compilador

INPUT_FILE=$1
OUTPUT_FILE=${INPUT_FILE:0: -2}mips

# Si su compilador no lo hace ya, aquí puede imprimir la información de contacto
echo "tooCool 1.0.0"   # Recuerde cambiar estas
echo "Copyright (c) 2019: Julio Cesar Sanchez Garcia, Juan Jose Roque Cires, Joel David Hernandez Cruz"    # líneas a los valores correctos

# Llamar al compilador
echo "Compiling $INPUT_FILE into $OUTPUT_FILE"
python3 compile.py $INPUT_FILE $OUTPUT_FILE

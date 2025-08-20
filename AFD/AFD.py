def cargar_configuracion(nombre_archivo):
    estados=set()
    alfabeto=set()
    transiciones={}
    estado_inicial=None
    estados_finales=set()

    with open(nombre_archivo, 'r') as f:
        lineas=[linea.strip() for linea in f if linea.strip()]

    i=0
    while i<len(lineas):
        linea=lineas[i]
        if linea.startswith('estados:'):
            estados=set(linea.split(':')[1].strip().split())
        elif linea.startswith('alfabeto de entrada:'):
            alfabeto=set(linea.split(':')[1].strip().split())
        elif linea.startswith('funciones de transicion:'):
            i+=1
            while i<len(lineas) and '->' in lineas[i]:
                parte=lineas[i].split('->')
                estado_origen=parte[0].strip()
                destino_simbolo=parte[1].split(':')
                estado_destino=destino_simbolo[0].strip()
                simbolo=destino_simbolo[1].strip()
                transiciones[(estado_origen, simbolo)]=estado_destino
                i+=1
            i-=1  
        elif linea.startswith('estado inicial:'):
            estado_inicial=linea.split(':')[1].strip()
        elif linea.startswith('estado final:'):
            estados_finales=set(linea.split(':')[1].strip().split())
        i+=1

    return estados, alfabeto, transiciones, estado_inicial, estados_finales


def validar_cadena(cadena, estados, alfabeto, transiciones, estado_inicial, estados_finales):
    estado_actual=estado_inicial
    for simbolo in cadena:
        if simbolo not in alfabeto:
            return False
        if (estado_actual, simbolo) not in transiciones:
            return False
        estado_actual=transiciones[(estado_actual, simbolo)]
    return estado_actual in estados_finales


if __name__=='__main__':
    archivo_conf='conf.txt'
    archivo_cadenas='cadenas.txt'

    estados, alfabeto, transiciones, estado_inicial, estados_finales=cargar_configuracion(archivo_conf)

    with open(archivo_cadenas, 'r') as f:
        cadenas=[linea.strip() for linea in f if linea.strip()]

    for c in cadenas:
        resultado=validar_cadena(c, estados, alfabeto, transiciones, estado_inicial, estados_finales)
        print ("aceptado" if resultado else "no aceptado")

Organizacion del archivo AFD:
	|AFD.py
	|AFD.l
	|Lex.yy.c
	|AFD.y
	|AFD.tab.h
	|AFD.tab.c
	|AFD
	|conf.txt
	
COMO EJECUTAR:
Descargar la carpeta AFD, y en la terminal ubicar la direccion donde se ecuentra este
Python:
	python3 AFD.py
	ó
	python AFD.py
dependiendo la version de python que tengas instalado
C:
	./AFD conf.txt cadenas.txt
	o para cargar los archivo correctamente
	
	flex AFD.l
	bison -d AFD.y
	gcc AFD.tab.c lex.yy.c main.c -o AFD -lfl
	./AFD conf.txt cadenas.txt
	
EXPLICACIÓN
En el ejecutable de Python, primero se obtiene la información del archivo de "conf.txt" y tambien de la entrada de cadenas "cadenas.txt", primero se guarda la informacion de la configuracion por medio de una funcion que guarda los datos, y luego usando los datos del texto de la cadena se manda a la otra funcion para validar la entrada junto con los otros argumentos de la configuracion para el automata, y linea por linea de entrada luego de verificar muestra si dicha entrada es determinista o no
Y el de C es similar pero primero el lex crea y guarda los tokens para las configuracion y simbolos para la asignacion en las funciones de transicion y los valores de entrada, el bison se encarga de reconocer y asociar estos tokens a la hora de leer el texto de configuracion para el automata, y además esta el main en C que es el encargado de tomar la informacion que se compilo del parsing y recibir la informacion al ingreso de los textos de la configuracion y la cadena de entrada.

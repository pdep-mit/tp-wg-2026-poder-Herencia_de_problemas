

class Pantalla{
    method image() 
    method position() = game.at(0, 0)
}

object pantallaInicio inherits Pantalla{
    override method image() = "imagenes/pantallaInicial_BomberBot.png"
}

object tocarEspacioPantalla inherits Pantalla{ // Es provisional, despues esto va a estar incluido en pantallaInicio
    override method image() = "imagenes/Toca_Espacio.png"
}

object pantallaNivel1 inherits Pantalla {
    override method image() = "imagenes/Nivel1.png"
}

object pantallaNivel2 inherits Pantalla {
    override method image() = "imagenes/Nivel2.png"
}

class MenuMuerte{
	const property image = "imagenes/HasMuerto.png" 
	method position() = game.at(3.4, 2.75)
}

class MenuDeVictoria{
	const property image = "imagenes/Ganaste.png"
	method position() = game.at(3.4, 2.75)
}

import sonidos.*
import niveles.*

object juego{
	var property nivelActual = nivel1 

	method cargarNivel() { nivelActual.cargarNivel() }

	method recargarNivel() { nivelActual.volverAEmpezar() }


	method perderJuego() {
		game.schedule(5, {game.clear() 
						 game.addVisual(new MenuMuerte())
						 (new SonidoPerder()).reproducir()
						 }) 	
	}

	method ganarJuego() {
	  game.schedule(5, {game.clear() 
						 game.addVisual(new MenuDeVictoria())
						 (new SonidoGanar()).reproducir()
						 }) 
	}
}

class MenuMuerte{
	const property image = "imagenes/HasMuerto.png" 
	method position() = game.at(3.4, 2.75)
}

class MenuDeVictoria{
	const property image = "imagenes/Ganaste.png"
	method position() = game.at(3.4, 2.75)
}
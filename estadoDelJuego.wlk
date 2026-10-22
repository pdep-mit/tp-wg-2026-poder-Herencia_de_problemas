import sonidos.*
import niveles.*
import jugador.*
import pantalla.*


object juego{
	var property nivelActual = nivel1 

	method empezarJuego(){
		nivelActual.cargarFondo()
		game.addVisual(pantallaInicio)
		game.addVisual(tocarEspacioPantalla)
		keyboard.space().onPressDo({ game.clear()
									self.cargarNivel() })	/*Empezar Nivel 1 */ 
		
	}

	method cargarNivel() { nivelActual.cargarNivel() }

	method recargarNivel() {
		jugador.reiniciar()
		nivelActual.terminar()
		nivelActual = nivel1
		self.cargarNivel()     }

	method pasarANivel2() {
		nivelActual.terminar()
		self.nivelActual(nivel2)
		self.cargarNivel()
	}

	method perderJuego() {
		game.schedule(5, {game.clear()
						 self.cargarControlesPantalla()
						 game.addVisual(new MenuMuerte())
						 (new SonidoPerder()).reproducir()
						 }) 	
	}

	method ganarJuego() {
	  game.schedule(5, {game.clear() 
	  					 self.cargarControlesPantalla()
						 game.addVisual(new MenuDeVictoria())
						 (new SonidoGanar()).reproducir()
						 }) 
	}

	method cargarControlesPantalla(){
        keyboard.r().onPressDo({ self.recargarNivel() })
    }
}

object marcadorDeVidas {
	method position()= game.at(0, game.height()-1)
	method text()= "Vidas: " + jugador.vidas()
	method textColor() = "FFFFFFFF"
	method permitePasar() = true
	method recibirExplosion() {} 
}
object marcadorDePuntaje {
	var property puntos = 0
	method position() = game.at(4, game.height()-1)
	method text() = "Puntos: " + puntos
	method textColor() = "FFFFFFFF"
	method permitePasar() = true
	method recibirExplosion() {} 
	method sumar(cantidad) { puntos += cantidad }
	method reiniciar() {
		puntos = 0
	}
	method chocarConJugador(){}
}

class Corazon{
 const property  numero 
 method position() = game.at(numero - 1, game.height() - 1)
 method image() = if (jugador.vidas() >= numero) "imagenes/corazonRojo.png" else "imagenes/corazonNegro.png"
 method permitePasar() = true
 method recibirExplosion() {} 
 method chocarConJugador(){}
}
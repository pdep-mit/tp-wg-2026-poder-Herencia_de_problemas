import sonidos.*
import jugador.*
import objetos.*
import estadoDelJuego.*

const muroIndestruible = "Muro Indestruible"
const muroDestruible = "Muro Destruible"

class Nivel{ 
    const property cantidadFilasDeMuros = 4
    const property cantidadColumnasDeMuros = 8 
    var property cancionDeFondo = game.sound("audio/Tema de Fondo - Zelda Song of Storms.mp3")
    var property cancionActiva = false 

    method cargarNivel(){
        self.cargarMapa()
        self.cargarElementos()
        self.cargarEnemigos()
        self.cargarJugadorEn(game.at(2,2))
        self.cargarControles()
        self.cargarMusica()
        self.cargarInterfaz()
    }

    method cargarMapa(){
	    game.boardGround("imagenes/Fondo.jpg")
    }
    method cargarInterfaz(){
     game.addVisual(new Corazon(numero = 1))
    game.addVisual(new Corazon(numero = 2))
    game.addVisual(new Corazon(numero = 3))
}

    method cargarElementos()
    method cargarEnemigos(){}

    method cargarJugadorEn(posicion){
    jugador.reiniciar()
    jugador.position(posicion)
    game.addVisual(jugador)
}

    method cargarControles(){
        keyboard.up().onPressDo({ jugador.subir() })
        keyboard.down().onPressDo({ jugador.bajar() })
        keyboard.left().onPressDo({ jugador.irALaIzquierda() })
        keyboard.right().onPressDo({ jugador.irALaDerecha() })
        keyboard.w().onPressDo({ jugador.subir() })
        keyboard.s().onPressDo({ jugador.bajar() })
        keyboard.a().onPressDo({ jugador.irALaIzquierda() })
        keyboard.d().onPressDo({ jugador.irALaDerecha() })

        keyboard.q().onPressDo({ jugador.plantarBomba() })

        keyboard.r().onPressDo({ juego.recargarNivel()})
    }

    method cargarMusica(){
        cancionDeFondo = new CancionFondo()
        cancionDeFondo.volumenEn(0.3)
        cancionDeFondo.sonido().shouldLoop(true)
        game.schedule(500, {cancionDeFondo.reproducir()
                            cancionActiva = true } )
    }

    method volverAEmpezar(){
        game.clear()
        cancionDeFondo.parar()
        self.cargarNivel()
    }

    method agregarMurosIndestruibles(){
        const inicioPrimerFila = game.at(1,1)
        const iniciosDeFilas = (0..cantidadFilasDeMuros-1).map({num => num*2}).map({x => inicioPrimerFila.up(x)})
        iniciosDeFilas.forEach({primerPosicion => self.crearFila(primerPosicion)})
    }

    method crearFila(posicion){
        self.agregar(muroIndestruible,self.calcularFila(posicion))
    }

    method calcularFila(inicioFila) {
        return (0..cantidadColumnasDeMuros-1).map({x => x*2}).map({columna => inicioFila.right(columna)})
    } 

    method agregar(clase, posiciones){
        if(clase == "Muro Destruible"){
            posiciones.forEach({ posicion => game.addVisual(new MuroDestruible(position = posicion))})
            }
        if(clase == "Muro Indestruible"){
            posiciones.forEach{ posicion => game.addVisual(new MuroIndestruible(position = posicion))}
            }
    } 
    method crearPuertaEn(posicion){
        const puerta = new Puerta(position = posicion)
        game.addVisual(puerta)
        game.onCollideDo(puerta, {objeto => objeto.entrarEnPuerta()})
    }
}

object mapaPruebas inherits Nivel {
  override method cargarElementos(){
	game.addVisual(new MuroDestruible(position = game.center().right(1)))
	game.addVisual(new MuroIndestruible(position = game.at(3,3)))
	self.crearPuertaEn(game.at(8,8))
  }
}

object nivel1 inherits Nivel {
  const columnaEnemigo = 10

  override method cargarElementos() {
    const fila1 = self.calcularFila(game.at(0, 7))
    const fila2 = self.calcularFila(game.at(0, 3))

    const muros = (fila1 + fila2 + [game.at(3, 0), game.at(3, 2), game.at(8, 5)])
      .filter({ pos => pos.x() != columnaEnemigo })

    self.agregar(muroDestruible, muros)
    self.agregarMurosIndestruibles()
    self.crearPuertaEn(game.at(12, 9))
  }

  override method cargarEnemigos() {
    const enemigo = new Enemigo(position = game.at(columnaEnemigo, 4))
    game.addVisual(enemigo)
    enemigo.activar()
  }
    override method agregarMurosIndestruibles(){
        super()
        self.agregar(muroIndestruible, [game.at(7,9),game.at(7,8),game.at(7,6),game.at(7,4)])
    }
    
}

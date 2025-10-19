class Nave {
	var property velocidad

	method propulsar(){
		//EXCEPCIÓN SUPERA LIMITE VELOCIDAD
		if(velocidad < 300000){
			velocidad = (velocidad + 20000).min(300000)
		} 
	}

	method prepararViaje(){
		if(velocidad < 300000){
			velocidad = (velocidad + 15000).min(300000)
		}
	}

	method recibirAmenaza(){
		
	}

	method encuentraEnemigo(){
		self.recibirAmenaza()
		self.propulsar()
	}
}


class NaveDeCarga inherits Nave {

	var property carga 

	method sobrecargada() = carga > 100000

	method excedidaDeVelocidad() = velocidad > 100000

	override method recibirAmenaza() {
		carga = 0
	}

}

class NaveDePasajeros inherits Nave {

	var property alarma = false
	const cantidadDePasajeros

	method cantTripulantes() {
		return cantidadDePasajeros + 4
	}

	method velocidadMaximaLegal() {
		return 300000 / self.cantTripulantes() - self.regulacionVelocidadSegunPasajeros()
	}

	method regulacionVelocidadSegunPasajeros(){
		if(cantidadDePasajeros > 100){
			return 200
		} else {
			return 100
		}
	}

	method estaEnPeligro() {
		return velocidad > self.velocidadMaximaLegal() or alarma
	}

	override method recibirAmenaza() {
		alarma = true
	}

}

class NaveDeCombate inherits Nave {
	var property modo = reposo
	const property mensajesEmitidos = []

	method emitirMensaje(mensaje) {
		mensajesEmitidos.add(mensaje)
	}
	
	method ultimoMensaje() {
		return mensajesEmitidos.last()
	}

	method estaInvisible() {
		return velocidad < 10000 and modo.invisible()
	}

	override method recibirAmenaza() {
		modo.recibirAmenaza(self)
	}

	override method prepararViaje(){
		super()
		modo.prepararViaje(self)
	}

}

object reposo {

	method invisible() {
		return false
	}

	method recibirAmenaza(nave) {
		nave.emitirMensaje("¡RETIRADA!")
	}

	method prepararViaje(nave){
		nave.emitirMensaje("Saliendo en misión")
	}
}

object ataque {

	method invisible() {
		return true
	}

	method recibirAmenaza(nave) {
		nave.emitirMensaje("Enemigo encontrado")
	}

	method prepararViaje(nave){
		nave.emitirMensaje("Volviendo a la base")
	}
}

class NaveDeCargaResiduo inherits NaveDeCarga {
	var property sellado 

	method cerrarAlVacio(){

	}

	override method recibirAmenaza(){
		velocidad = 0
	}

	override method prepararViaje(){
		super()
		sellado = true
	}
}

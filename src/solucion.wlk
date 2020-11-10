object asado { 
	const facu = new Persona(posicion = 1, elementosCercanos = ["aceite","cuchillo"], criterio = pasarTodo, elementoQueQuiere = "sal", eleccionComida = dietetico, comidaQueComio = [new Comida(nombre = "vacio", calorias = 350, esCarne = true)])
	const moni = new Persona(posicion = 11, elementosCercanos = ["sal","mostaza","vinagre","aceto"], criterio = sordo, elementoQueQuiere = "mayonesa", eleccionComida = vegetariano, comidaQueComio = [])
	const vero = new Persona(posicion = 3, elementosCercanos = ["cuchara"], criterio = cambiarPosicion, elementoQueQuiere = "vinagre", eleccionComida = combinacion, comidaQueComio = [])
	const osky = new Persona(posicion = 6, elementosCercanos = ["tenedor","plato"], criterio = cambiarPosicion, elementoQueQuiere = "vinagre", eleccionComida = vegetariano, comidaQueComio = [])
	
	method laEstaPasandoBien(comensal) = (not comensal.comidaQueComio().isEmpty()) && moni.obtenerPosicion() == 11 && facu.comioCarne() && vero.elementos().length() < 3
}

class Persona {
	var posicion
	var elementosCercanos = []
	var criterio
	var elementoQueQuiere
	var eleccionComida
	var comidaQueComio = []
	
	method elementos() = elementosCercanos
	method pedirPasarCosa(comensalObjetivo) = criterio.pasarCosa(self, comensalObjetivo)
	method primeraCosa() = elementosCercanos.head()
	method obtenerPosicion() = posicion
	method cambiarPosicion(nuevaPosicion) { posicion = nuevaPosicion }
	method elementoPedido() = elementoQueQuiere
	method pedirCosa(personaObjetivo) {	
		if(not self.objetivoTieneObjeto(personaObjetivo, elementoQueQuiere))
		self.error("El objetivo no tiene tal objeto")
		criterio.pasarCosa(self, personaObjetivo)
	}
	method objetivoTieneObjeto(objetivo, objeto) = objetivo.elementos().contains(objeto)
	method cambiarCriterioComida(nuevoCriterio) { criterio = nuevoCriterio }
	method comer(bandejaComida) = comidaQueComio.add(eleccionComida.criterioComida(bandejaComida))
	method estaPipon() = comidaQueComio.any({ unaComida => unaComida.esPesada() })
	method comioCarne() = comidaQueComio.any({ unaComida => unaComida.comidaEsCarne()})
}

object sordo {
	method pasarCosa(comensal1, comensal2) {
		const cosa = comensal2.primeraCosa()
		comensal2.elementos().add(cosa)
		comensal1.elementos().remove(cosa)
	}
}

object pasarTodo {
	method pasarCosa(comensal1, comensal2) {
		comensal2.elementos().addAll(comensal1.elementos())
		comensal1.elementos().clear()
	}
}
object cambiarPosicion {
	method pasarCosa(comensal1, comensal2) {
		const aux = comensal1.obtenerPosicion()
		comensal1.cambiarPosicion(comensal2.obtenerPosicion())
		comensal2.cambiarPosicion(aux)
	}
}
object pasarElemento {
	method pasarCosa(comensal1, comensal2) {
		const cosa = comensal1.elementoPedido()
		comensal2.elementos().add(cosa)
		comensal1.elementos().remove(cosa) //hace falta hacer una pequeña superclase para no repetir solo esta logica con el primer criterio?
	}
}

class Comida {
	var nombre
	var calorias
	var esCarne
	
	method comidaEsCarne() = esCarne
	method caloriasQueContiene() = calorias
	method esPesada() = calorias > dietetico.limiteCalorias()
}

object vegetariano {
	method criterioComida(bandejaComida) = bandejaComida.filter({ unaComida => unaComida.esCarne().negate()})
}
object dietetico {
	var property limiteCalorias = 500
	method criterioComida(bandejaComida) = bandejaComida.filter({ unaComida => unaComida.caloriasQueContiene() < limiteCalorias})
}

object alternado {
	method criterioComida(bandejaComida) = bandejaComida.filter({  })
}

object combinacion {
	const listaCriterios = [vegetariano, dietetico]
	method criterioComida(bandejaComida) = listaCriterios.all({ unCriterio => unCriterio.criterioComida(bandejaComida) })
}
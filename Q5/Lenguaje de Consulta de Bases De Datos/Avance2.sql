
----Creación----
CREATE DATABASE proyecto;
GO

USE proyecto;

----------------------------INICIO de PRIMER linea del diagrama, tablas padres------------------------------------------------

CREATE TABLE Roles (
    id_rol     INT IDENTITY(1,1)             PRIMARY KEY,
    nombre      VARCHAR(100)    NOT NULL

);

CREATE TABLE Tema (
    id_tema     INT IDENTITY(1,1)               PRIMARY KEY,
    nombre      VARCHAR(100)    NOT NULL

);


CREATE TABLE Canal (
    id_canal    INT IDENTITY(1,1)              PRIMARY KEY,
    nombre      VARCHAR(60)     NOT NULL

);

CREATE TABLE Encuesta (
    encuesta_id     INT IDENTITY(1,1)               PRIMARY KEY,
    nombre          VARCHAR(120)    NOT NULL,
    descripcion     VARCHAR(200)    NOT NULL,
    fecha_inicio    DATE            NOT NULL,
    fecha_fin       DATE            NOT NULL,
    activa          CHAR(2)         NOT NULL

);
----------------------------FIN de PRIMER linea del diagrama------------------------------------------------



----------------------------INICIO de SEGUNDA linea del diagrama, tablas hijas de primer nivel------------------------------------------------

-- Personas tiene relacion con Roles 
CREATE TABLE Personas (
    id_persona      INT            PRIMARY KEY, --unico que no usa IDENTITY ya que utilizara cedulas
    nombre          VARCHAR(30)     NOT NULL,
    apellidos       VARCHAR(30)     NOT NULL,
    correo          VARCHAR(100)    NULL,
    telefono        INT             NULL,
    id_rol      INT,             --FK
    CONSTRAINT FK_Personas_Roles
        FOREIGN KEY (id_rol) REFERENCES Roles(id_rol)
);

-- Evento tiene relacion con Tema y Canal 
CREATE TABLE Evento (
    id_evento       INT IDENTITY(1,1)              PRIMARY KEY,
    nombre          VARCHAR(120)    NOT NULL,
    fecha_inicio    DATE            NOT NULL,
    fecha_fin       DATE            NOT NULL,
    provincia       VARCHAR(30)     NOT NULL,
    lugar           VARCHAR(50)     NOT NULL,
    id_canal        INT,            --FK
    id_tema         INT,             --FK
    CONSTRAINT FK_Evento_Canal
        FOREIGN KEY (id_canal) REFERENCES Canal(id_canal),
    CONSTRAINT FK_Evento_Tema
        FOREIGN KEY (id_tema) REFERENCES Tema(id_tema)
);

-- Mensaje tiene relacion con Tema y Canal 
CREATE TABLE Mensaje (
    id_mensaje  INT IDENTITY(1,1)              PRIMARY KEY,
    titulo      VARCHAR(120)    NOT NULL,
    contenido   VARCHAR(500)    NOT NULL,
    id_canal    INT,            --FK
    id_tema     INT,             --FK
    CONSTRAINT FK_Mensaje_Canal
        FOREIGN KEY (id_canal) REFERENCES Canal(id_canal),
    CONSTRAINT FK_Mensaje_Tema
        FOREIGN KEY (id_tema) REFERENCES Tema(id_tema)
);

----------------------------FIN de SEGUNDA linea del diagrama------------------------------------------------





----------------------------INICIO de TERCERA linea del diagrama, tablas hijas de segundo nivel------------------------------------------------

-- Interaccion tiene relacion con Personas y Canal 
CREATE TABLE Interaccion (
    interaccion_id      INT IDENTITY(1,1)              PRIMARY KEY,
    persona_id          INT,            --FK
    canal_id            INT,            --FK
    fecha_hora          DATETIME        NOT NULL,
    descripcion         VARCHAR(1000)   NOT NULL,
    CONSTRAINT FK_Interaccion_Personas
        FOREIGN KEY (persona_id) REFERENCES Personas(id_persona),
    CONSTRAINT FK_Interaccion_Canal
        FOREIGN KEY (canal_id) REFERENCES Canal(id_canal)

);

-- Donaciones tiene relacion con Personas 
CREATE TABLE Donaciones (
    donacion_id     INT IDENTITY(1,1)              PRIMARY KEY,
    persona_id      INT,            --FK
    monto           DECIMAL(10,2)   NOT NULL,
    fecha_hora      DATETIME        NOT NULL,
    referencia      VARCHAR(30)     NULL,
    estado          VARCHAR(50)     NOT NULL,
    observacion     VARCHAR(200)    NULL,
    CONSTRAINT FK_Donaciones_Personas
        FOREIGN KEY (persona_id) REFERENCES Personas(id_persona)

);

-- Respuesta_Encuesta tiene relacion con Personas, Encuesta y Tema 
CREATE TABLE Respuesta_encuesta (
    respuesta_id        INT IDENTITY(1,1)              PRIMARY KEY,
    encuesta_id         INT,            --FK
    persona_id          INT,            --FK
    fecha_hora          DATETIME        NOT NULL,
    intencion_voto      VARCHAR(20)     NOT NULL,
    id_tema             INT             NULL,
    comentario          VARCHAR(200)    NULL,
    CONSTRAINT FK_Respuesta_encuesta_Encuesta
        FOREIGN KEY (encuesta_id) REFERENCES Encuesta(encuesta_id),
    CONSTRAINT FK_Respuesta_encuesta_Personas
        FOREIGN KEY (persona_id) REFERENCES Personas(id_persona),
    CONSTRAINT FK_Respuesta_encuesta_Tema
        FOREIGN KEY (id_tema) REFERENCES Tema(id_tema)
);


----------------------------FIN de TERCERA linea del diagrama------------------------------------------------





----------------------------INICIO de CUARTA linea del diagrama, tablas pivote------------------------------------------------

-- persona_evento tiene relacion con Personas y Evento 
CREATE TABLE persona_evento(
    id_persona_evento   INT IDENTITY(1,1)          PRIMARY KEY,
    id_persona          INT,        --FK
    id_evento           INT,        --FK
    fecha_registro      DATE        NOT NULL,
    asistencia          CHAR(2)     NULL,
    CONSTRAINT FK_persona_evento_Personas
        FOREIGN KEY (id_persona) REFERENCES Personas(id_persona),
    CONSTRAINT FK_persona_evento_Evento
        FOREIGN KEY (id_evento) REFERENCES Evento(id_evento)
);

-- persona_Mensaje tiene relacion con Personas y Mensaje 
CREATE TABLE persona_mensaje (
    id_persona_mensaje  INT IDENTITY(1,1)              PRIMARY KEY,
    id_persona          INT,            --FK
    id_mensaje          INT,            --FK
    fecha_envio         DATE            NOT NULL,
    enviado             CHAR(2)         NULL,
    leido               CHAR(2)         NULL,
    respuesta           VARCHAR(100)    NULL,
    CONSTRAINT FK_persona_mensaje_Personas
        FOREIGN KEY (id_persona) REFERENCES Personas(id_persona),
    CONSTRAINT FK_persona_mensaje_Mensaje
        FOREIGN KEY (id_mensaje) REFERENCES Mensaje(id_mensaje)
);

-- persona_interes tiene relacion con Personas y Tema
CREATE TABLE persona_interes (
    id_persona_interes  INT IDENTITY(1,1)          PRIMARY KEY,
    id_persona          INT,        --FK
    id_tema             INT,        --FK
    nivel_interes       NUMERIC     NOT NULL,
    CONSTRAINT FK_persona_interes_Personas
        FOREIGN KEY (id_persona) REFERENCES Personas(id_persona),
    CONSTRAINT FK_persona_interes_Tema
        FOREIGN KEY (id_tema) REFERENCES Tema(id_tema)
);
----------------------------FIN de CUARTA linea del diagrama------------------------------------------------

----------------------------INSERTS de datos--------------------------------


INSERT INTO Roles (nombre) VALUES
('Presidente'),
('Vicepresidente'),
('Voluntariado'),
('Tesorería'),
('Comunicación'),
('Logística'),
('Fiscalización'),
('Atención Ciudadana'),
('Analítica de Datos'),
('Donante'),
('Interesado');
GO

INSERT INTO Tema (nombre) VALUES
('Educación'),
('Salud'),
('Economía'),
('Seguridad'),
('Infraestructura'),
('Ambiente'),
('Empleo'),
('Tecnología'),
('Transparencia'),
('Cultura');
GO

INSERT INTO Canal (nombre) VALUES
('WhatsApp'),
('Facebook'),
('Instagram'),
('X/Twitter'),
('TikTok'),
('Correo'),
('SMS'),
('Llamada'),
('YouTube'),
('Sitio Web'),
('Presentacion'),
('Rally'),
('Conferencia');

GO

INSERT INTO Encuesta (nombre, descripcion, fecha_inicio, fecha_fin, activa) VALUES
('Esperanzas de trabajo I','Percepción de oportunidades laborales y prioridades de empleo.','2026-02-01','2026-02-15','SI'),
('Esperanzas de trabajo II','Seguimiento: cambios en expectativas laborales y capacitación.','2026-02-16','2026-03-02','SI'),
('Esperanzas de trabajo III','Seguimiento final: estabilidad, salario y formalidad.','2026-03-03','2026-03-17','SI'),

('Costo de vida: canasta básica (Ola 1)','Impacto del costo de la canasta básica en hogares.','2026-02-02','2026-02-16','SI'),
('Costo de vida: canasta básica (Ola 2)','Seguimiento: precios, consumo y sustitución de productos.','2026-02-17','2026-03-03','SI'),

('Seguridad en el barrio (Diagnóstico)','Percepción de seguridad, iluminación y patrullaje.','2026-02-03','2026-02-17','SI'),
('Seguridad en el barrio (Seguimiento)','Cambios percibidos y medidas sugeridas por la comunidad.','2026-02-18','2026-03-04','SI'),

('Salud: tiempos de espera','Opinión sobre listas de espera y atención primaria.','2026-02-04','2026-02-18','SI'),
('Salud: acceso a EBAIS','Disponibilidad, horarios y calidad de atención local.','2026-02-19','2026-03-05','SI'),

('Educación pública: infraestructura','Estado de centros educativos y necesidades urgentes.','2026-02-05','2026-02-19','SI'),
('Educación pública: conectividad','Acceso a internet, dispositivos y apoyo académico.','2026-02-20','2026-03-06','SI'),

('Transporte público: calidad','Frecuencia, puntualidad y seguridad en rutas.','2026-02-06','2026-02-20','SI'),
('Transporte público: cobertura','Zonas con baja cobertura y propuestas de mejora.','2026-02-21','2026-03-07','SI'),

('Infraestructura vial: rutas cantonales','Baches, señalización y prioridades de intervención.','2026-02-07','2026-02-21','SI'),
('Infraestructura vial: movilidad peatonal','Aceras, cruces seguros y accesibilidad.','2026-02-22','2026-03-08','SI'),

('Ambiente: reciclaje y residuos (Ola 1)','Hábitos, puntos de acopio y recolección.','2026-02-08','2026-02-22','SI'),
('Ambiente: reciclaje y residuos (Ola 2)','Seguimiento: participación y barreras para reciclar.','2026-02-23','2026-03-09','SI'),

('Agua potable: calidad y continuidad','Cortes, presión y calidad percibida del servicio.','2026-02-09','2026-02-23','SI'),
('Energía: tarifas y consumo','Percepción de tarifas, eficiencia energética y ahorro.','2026-02-24','2026-03-10','SI'),

('Tecnología: alfabetización digital','Acceso a herramientas digitales y capacitación.','2026-02-10','2026-02-24','SI'),
('Tecnología: trámites en línea','Experiencia con trámites digitales y barreras.','2026-02-25','2026-03-11','SI'),

('Transparencia: rendición de cuentas','Confianza, acceso a información y control del gasto.','2026-02-11','2026-02-25','SI'),
('Transparencia: participación y veeduría','Interés en auditoría ciudadana y mecanismos de denuncia.','2026-02-26','2026-03-12','SI'),

('Empleo juvenil: primer trabajo','Experiencia de búsqueda y requisitos de entrada.','2026-02-12','2026-02-26','SI'),
('Empleo juvenil: prácticas y pasantías','Oferta, calidad y remuneración de prácticas.','2026-02-27','2026-03-13','SI'),

('Pymes: acceso a crédito','Facilidad de crédito, tasas y requisitos.','2026-02-13','2026-02-27','SI'),
('Pymes: trámites y permisos','Burocracia, tiempos y simplificación.','2026-02-28','2026-03-14','SI'),

('Vivienda: alquiler y costo','Alquiler, depósitos y dificultades para pagar.','2026-02-14','2026-02-28','SI'),
('Vivienda: bonos y opciones','Conocimiento y acceso a programas de vivienda.','2026-03-01','2026-03-15','SI'),

('Cultura y deporte: espacios públicos','Uso de parques, canchas y actividades culturales.','2026-02-15','2026-03-01','SI'),
('Cultura y deporte: apoyo local','Necesidades de grupos culturales y deportivos.','2026-03-02','2026-03-16','SI'),

('Turismo: empleo y encadenamientos','Impacto local del turismo en empleo y comercio.','2026-02-16','2026-03-02','SI'),
('Agricultura: apoyo y mercado','Asistencia técnica, precios y acceso a mercado.','2026-03-03','2026-03-17','SI'),

('Seguridad vial: puntos críticos','Zonas peligrosas, señalización y control.','2026-02-17','2026-03-03','SI'),
('Salud preventiva: vacunación','Acceso a campañas y percepción de prevención.','2026-03-04','2026-03-18','SI'),

('Educación técnica: empleabilidad','Carreras técnicas, demanda laboral y becas.','2026-02-18','2026-03-04','SI'),
('Gestión pública: atención al usuario','Calidad de servicio y tiempos de respuesta.','2026-03-05','2026-03-19','SI'),

('Participación ciudadana: cabildos','Interés en participar y principales obstáculos.','2026-02-19','2026-03-05','SI'),
('Canales de comunicación preferidos','Preferencias de canal y frecuencia de mensajes.','2026-03-06','2026-03-20','SI'),

('Opinión general del movimiento (Ola 1)','Percepción general y expectativas de propuestas.','2026-02-20','2026-03-06','SI'),
('Opinión general del movimiento (Ola 2)','Seguimiento: cambios en percepción y prioridades.','2026-03-07','2026-03-21','SI'),
('Cierre de campaña: evaluación final','Evaluación final de actividades y comunicación.','2026-03-08','2026-03-22','SI');
GO

INSERT INTO Personas (id_persona, nombre, apellidos, correo, telefono, id_rol) VALUES
(110000288,'Rafael Angel','Arguedas Segura','persona110000288@ejemplo.com',80000288,1),
(110000305,'Adriana Maria','Murillo Chaves','persona110000305@ejemplo.com',80000305,2),
(119010053,'Priscilla Saray','Sequeira Parreaguirre','persona119010053@ejemplo.com',89010053,3),
(119100969,'Christian','Navarro Ellerbrock','persona119100969@ejemplo.com',89100969,3),
(119110869,'Kevin Gustavo','Carmona Ramirez','persona119110869@ejemplo.com',89110869,4),
(210000278,'Justino Abel','Gudiel Espinoza','persona210000278@ejemplo.com',80000278,5),
(210150980,'Santos Andres','Galeano Sanchez','persona210150980@ejemplo.com',80150980,6),
(211180902,'Kyara Camila','Campos Araya','persona211180902@ejemplo.com',81180902,7),
(211160072,'Jerlin Beneth','Flores Hondoy','persona211160072@ejemplo.com',81160072,8),
(211000336,'Ezequiel','Espinoza Espinoza','persona211000336@ejemplo.com',81000336,9),

(300660431,'Herlinda','Romero Zuñiga','persona300660431@ejemplo.com',70660431,10),
(301090033,'Adilia','Piedra Navarro','persona301090033@ejemplo.com',71090033,11),
(301080191,'Octavio','Navarro Leiva','persona301080191@ejemplo.com',71080191,11),
(400450373,'Blanca Rosa','Calvo Arce','persona400450373@ejemplo.com',80450373,11),
(400680089,'Mercedes Maria','Gonzalez White','persona400680089@ejemplo.com',80680089,11),
(400680205,'Rafael Angel','Zuñiga Maroto','persona400680205@ejemplo.com',80680205,10),
(400690944,'Luis Paulino','Chavarria Sanchez','persona400690944@ejemplo.com',80690944,11),
(500410783,'Maria Felicitas','Zuñiga Jaen','persona500410783@ejemplo.com',70410783,11),
(500450780,'Sixto','Villagra Villagra','persona500450780@ejemplo.com',70450780,11),
(500610605,'Leonidas','Villegas Cortes','persona500610605@ejemplo.com',70610605,11),

(500640012,'Jose Angel','Arguedas Muñoz','persona500640012@ejemplo.com',70640012,11),
(500310638,'Jose','Rosales Vallejos','persona500310638@ejemplo.com',70310638,10),
(500470963,'Juana','Molina Vallejo','persona500470963@ejemplo.com',70470963,11),
(500500445,'Bernabe Felix','Perez Perez','persona500500445@ejemplo.com',70500445,11),
(600210609,'Jose Rafael','Carrillo Carrillo','persona600210609@ejemplo.com',70210609,11),
(600290670,'Lorenzo','Figueroa Figueroa','persona600290670@ejemplo.com',70290670,11),
(600390384,'Dinorah','Perez Carvajal','persona600390384@ejemplo.com',70390384,11),
(600430457,'Felipe','Chin Fong','persona600430457@ejemplo.com',70430457,11),
(600250547,'Nimia','Fallas Bolaños','persona600250547@ejemplo.com',70250547,11),
(600400232,'Paulina','Martinez Gomez','persona600400232@ejemplo.com',70400232,10),

(600410234,'Valentin','Trejos Herrera','persona600410234@ejemplo.com',70410234,11),
(600430441,'Victoriano','Elizondo Ledezma','persona600430441@ejemplo.com',70430441,11),
(700109881,'Lino Samuel','Henrry Henrry','persona700109881@ejemplo.com',70109881,11),
(700200261,'Zeneida','Calero Hidalgo','persona700200261@ejemplo.com',70200261,11),
(700260940,'Edwin Josia','Slach Myers','persona700260940@ejemplo.com',70260940,11),
(700270314,'Margarita','Moya Rodriguez','persona700270314@ejemplo.com',70270314,11),
(700190809,'Arturo','Madrigal Fernandez','persona700190809@ejemplo.com',70190809,11),
(700270837,'Fernando Manuel','Henry Petters','persona700270837@ejemplo.com',70270837,11),
(700280796,'Maria Teresa','Alvarado Vargas','persona700280796@ejemplo.com',70280796,11),
(800010114,'Ethel','Goldberg Blusstain','persona800010114@ejemplo.com',70010114,11);
GO

INSERT INTO Evento (nombre, fecha_inicio, fecha_fin, provincia, lugar, id_canal, id_tema) VALUES
('Cabildo abierto: empleo y capacitación','2026-03-01','2026-03-01','San José','Barrio Escalante',1,7),
('Foro comunitario: listas de espera','2026-03-02','2026-03-02','Heredia','Centro Cultural',6,2),
('Encuentro con pymes: crédito y trámites','2026-03-03','2026-03-03','Alajuela','Parque Central',2,3),
('Mesa barrial: seguridad y convivencia','2026-03-04','2026-03-04','Cartago','Municipalidad',8,4),
('Taller: movilidad y aceras seguras','2026-03-05','2026-03-05','San José','Casa Comunal',3,5),
('Jornada ambiental: reciclaje y puntos limpios','2026-03-06','2026-03-06','Puntarenas','Playa Puntarenas',5,6),
('Feria de empleo local: asesoría de CV','2026-03-07','2026-03-07','Alajuela','Salón Comunal',1,7),
('Charla: alfabetización digital para adultos','2026-03-08','2026-03-08','Heredia','Universidad',9,8),
('Conversatorio: transparencia y rendición de cuentas','2026-03-09','2026-03-09','San José','Auditorio',4,9),
('Noche cultural: talentos del cantón','2026-03-10','2026-03-10','Cartago','Gimnasio',10,10),

('Ruta de escucha ciudadana (GAM)','2026-03-11','2026-03-11','San José','Zapote',1,9),
('Taller: seguridad vial en puntos críticos','2026-03-12','2026-03-12','Heredia','Barreal',6,4),
('Foro: economía familiar y costo de vida','2026-03-13','2026-03-13','Alajuela','El Coyol',2,3),
('Capacitación interna: voluntariado en campo','2026-03-14','2026-03-14','Cartago','Tres Ríos',1,7),
('Foro: ambiente y energía limpia','2026-03-15','2026-03-15','Puntarenas','Quepos',5,6),
('Mesa educativa: conectividad y becas','2026-03-16','2026-03-16','Limón','Centro Cívico',3,1),
('Clínica informativa: salud preventiva','2026-03-17','2026-03-17','San José','Hatillo',8,2),
('Encuentro sector comercio: encadenamientos','2026-03-18','2026-03-18','Alajuela','Grecia',2,3),
('Revisión cantonal: prioridades viales','2026-03-19','2026-03-19','Cartago','Oreamuno',9,5),
('Festival cultural barrial','2026-03-20','2026-03-20','Heredia','San Rafael',10,10),

('Diálogo: empleo juvenil y primer trabajo','2026-03-21','2026-03-21','San José','San Pedro',1,7),
('Mesa técnica: trámites digitales','2026-03-22','2026-03-22','Heredia','Belén',9,8),
('Taller: veeduría ciudadana municipal','2026-03-23','2026-03-23','Cartago','Centro',6,9),
('Caminata comunitaria por el ambiente','2026-03-24','2026-03-24','Puntarenas','Jacó',5,6),
('Foro: seguridad comunitaria (comités)','2026-03-25','2026-03-25','Alajuela','San Ramón',8,4),
('Conversatorio: salud y acceso a EBAIS','2026-03-26','2026-03-26','San José','Curridabat',3,2),
('Taller: infraestructura vial y mantenimiento','2026-03-27','2026-03-27','Cartago','Paraíso',2,5),
('Charla: educación técnica y empleabilidad','2026-03-28','2026-03-28','Heredia','Santo Domingo',9,1),
('Encuentro: cultura y deporte (ligas comunales)','2026-03-29','2026-03-29','San José','La Sabana',10,10),
('Cierre semanal: resumen de propuestas','2026-03-30','2026-03-30','Limón','Puerto Limón',4,9),

('Asamblea regional: economía y empleo','2026-03-31','2026-03-31','Guanacaste','Liberia',2,3),
('Foro: turismo, empleo y comercio local','2026-04-01','2026-04-01','Puntarenas','Monteverde',5,7),
('Charla: innovación y startups locales','2026-04-02','2026-04-02','San José','Escazú',9,8),
('Mesa: seguridad y convivencia','2026-04-03','2026-04-03','Heredia','Centro',8,4),
('Taller: acceso a salud y prevención','2026-04-04','2026-04-04','Cartago','Turrialba',6,2),
('Feria educativa: apoyo a estudiantes','2026-04-05','2026-04-05','Alajuela','Atenas',3,1),
('Foro: transparencia y datos abiertos','2026-04-06','2026-04-06','San José','Pavas',4,9),
('Jornada: reciclaje y limpieza comunal','2026-04-07','2026-04-07','Guanacaste','Nicoya',5,6),
('Encuentro cultural provincial','2026-04-08','2026-04-08','Heredia','San Isidro',10,10),
('Reunión final: coordinación logística','2026-04-09','2026-04-09','San José','Sede Central',1,9);
GO

INSERT INTO Mensaje (titulo, contenido, id_canal, id_tema) VALUES
('Confirmación de cabildo: empleo y capacitación','Te esperamos hoy. Si tenés preguntas sobre empleo o capacitación, traelas al cabildo.',1,7),
('Encuesta activa: costo de vida','Ya está disponible la encuesta sobre canasta básica. Tu respuesta es anónima.',6,3),
('Recordatorio: foro de salud','Mañana conversamos sobre listas de espera y acceso a EBAIS. ¡Te esperamos!',6,2),
('Actualización de agenda semanal','Se actualizó la agenda de actividades. Revisá fechas y ubicaciones.',10,9),
('Invitación: taller de movilidad','Conversaremos sobre aceras seguras y movilidad peatonal.',3,5),
('Jornada ambiental','Traé materiales reciclables para el punto limpio comunal.',5,6),
('Feria de empleo local','Habrá asesoría de CV y orientación. Compartí con amistades que busquen empleo.',2,7),
('Charlas de alfabetización digital','Inscripción abierta para la charla. Cupo limitado.',9,8),
('Transparencia: reporte de actividades','Publicamos el resumen de actividades y próximos pasos.',10,9),
('Noche cultural','Actividad cultural con talentos locales. Entrada gratuita.',2,10),

('Seguimiento: seguridad en el barrio','¿Qué puntos considerás más críticos? Respondé con tu zona y comentario.',1,4),
('Convocatoria de voluntariado','Necesitamos apoyo en registro y logística. Escribí para asignarte tarea.',1,7),
('Resultados preliminares de encuesta','Gracias por participar. Compartimos hallazgos preliminares (sin datos personales).',10,9),
('Información: pymes y crédito','Resumen de propuestas para pymes: crédito, trámites y acompañamiento.',6,3),
('Salud preventiva','Recomendaciones y propuestas para fortalecer prevención y atención primaria.',6,2),
('Educación: conectividad y becas','Compartimos medidas para conectividad y apoyo a estudiantes.',10,1),
('Aviso de cambio de lugar','La actividad cambia de sede por logística. Revisá el detalle antes de salir.',1,9),
('Invitación a conversatorio','Espacio abierto para escuchar propuestas y preocupaciones del cantón.',2,9),
('Transporte público','Queremos saber qué rutas tienen más problemas. Respondé con tu ruta.',8,5),
('Infraestructura vial','Recopilamos reportes de baches/señalización. Enviá ubicación aproximada.',1,5),

('Empleo juvenil','Programas propuestos para primer empleo, pasantías y capacitación.',3,7),
('Tecnología: trámites en línea','Contanos tu experiencia con trámites digitales: ¿qué fue lo más difícil?',9,8),
('Ambiente: gestión de residuos','Propuestas para residuos y reciclaje. Invitación a jornada comunal.',5,6),
('Rendición de cuentas','Transparencia en donaciones y uso proyectado. Publicaremos cortes periódicos.',10,9),
('Recordatorio de encuesta de canales','¿Preferís WhatsApp, correo o redes? Ayudanos a mejorar la comunicación.',6,9),
('Seguridad vial: puntos críticos','Mencioná intersecciones peligrosas o lugares con poca señalización.',4,4),
('Cultura y deporte','Apoyo a espacios culturales y ligas comunales. Sumate con ideas.',2,10),
('Agua y energía','Opinión sobre tarifas, consumo y continuidad del servicio.',6,6),
('Participación ciudadana','Tu voz importa. Participá en cabildos y encuestas.',10,9),
('Cierre semanal','Gracias por acompañarnos esta semana. Agenda nueva disponible en el sitio web.',10,9),

('Confirmación de asistencia','Por favor confirmá si asistirás al evento de mañana.',1,9),
('Enlace de transmisión en vivo','Transmitiremos el foro en vivo. Conectate a las 7:00 pm.',9,9),
('Seguimiento a tu comentario','Gracias por escribir. Lo incorporaremos en el análisis por tema.',6,9),
('Material informativo','Adjuntamos resumen de propuestas por tema (PDF).',10,9),
('Recordatorio: taller ciudadano','Actividad mañana. Traé preguntas y propuestas.',1,9),
('Mensaje para donantes','Gracias por tu apoyo. Tu aporte se registra con total transparencia.',6,9),
('Convocatoria regional','Invitación a asamblea regional. Cupo abierto.',2,9),
('Encuesta final: evaluación de campaña','Compartí tu experiencia con actividades y comunicación.',10,9),
('Solicitud de retroalimentación','¿Qué tema considerás más urgente: empleo, salud, seguridad u otro?',3,9),
('Mensaje final de semana','Buen cierre de semana. Próximas actividades pronto.',10,9);
GO

INSERT INTO persona_evento (id_persona, id_evento, fecha_registro, asistencia) VALUES
(110000288,1,'2026-02-20','SI'),
(110000305,2,'2026-02-20','SI'),
(119010053,3,'2026-02-21','SI'),
(119100969,4,'2026-02-21','NO'),
(119110869,5,'2026-02-22','SI'),
(210000278,6,'2026-02-22','SI'),
(210150980,7,'2026-02-23','SI'),
(211180902,8,'2026-02-23','SI'),
(211160072,9,'2026-02-24','NO'),
(211000336,10,'2026-02-24','SI'),
(300660431,11,'2026-02-25','SI'),
(301090033,12,'2026-02-25','SI'),
(301080191,13,'2026-02-26','SI'),
(400450373,14,'2026-02-26','NO'),
(400680089,15,'2026-02-27','SI'),
(400680205,16,'2026-02-27','SI'),
(400690944,17,'2026-02-28','SI'),
(500410783,18,'2026-02-28','SI'),
(500450780,19,'2026-03-01','NO'),
(500610605,20,'2026-03-01','SI'),
(500640012,21,'2026-03-02','SI'),
(500310638,22,'2026-03-02','SI'),
(500470963,23,'2026-03-03','SI'),
(500500445,24,'2026-03-03','NO'),
(600210609,25,'2026-03-04','SI'),
(600290670,26,'2026-03-04','SI'),
(600390384,27,'2026-03-05','SI'),
(600430457,28,'2026-03-05','SI'),
(600250547,29,'2026-03-06','NO'),
(600400232,30,'2026-03-06','SI'),
(600410234,31,'2026-03-07','SI'),
(600430441,32,'2026-03-07','SI'),
(700109881,33,'2026-03-08','SI'),
(700200261,34,'2026-03-08','NO'),
(700260940,35,'2026-03-09','SI'),
(700270314,36,'2026-03-09','SI'),
(700190809,37,'2026-03-10','SI'),
(700270837,38,'2026-03-10','SI'),
(700280796,39,'2026-03-11','NO'),
(800010114,40,'2026-03-11','SI');
GO

INSERT INTO persona_mensaje (id_persona, id_mensaje, fecha_envio, enviado, leido, respuesta) VALUES
(110000288,1,'2026-02-20','SI','SI',NULL),
(110000305,2,'2026-02-20','SI','SI','Gracias, recibido.'),
(119010053,3,'2026-02-21','SI','NO',NULL),
(119100969,4,'2026-02-21','SI','SI','¿Dónde confirmo asistencia?'),
(119110869,5,'2026-02-22','SI','SI',NULL),
(210000278,6,'2026-02-22','SI','SI',NULL),
(210150980,7,'2026-02-23','SI','NO','¿A qué hora inicia?'),
(211180902,8,'2026-02-23','SI','SI',NULL),
(211160072,9,'2026-02-24','SI','SI',NULL),
(211000336,10,'2026-02-24','SI','NO',NULL),
(300660431,11,'2026-02-25','SI','SI','Confirmo asistencia.'),
(301090033,12,'2026-02-25','SI','SI',NULL),
(301080191,13,'2026-02-26','SI','NO',NULL),
(400450373,14,'2026-02-26','SI','SI','¿Hay parqueo cerca?'),
(400680089,15,'2026-02-27','SI','SI',NULL),
(400680205,16,'2026-02-27','SI','NO',NULL),
(400690944,17,'2026-02-28','SI','SI',NULL),
(500410783,18,'2026-02-28','SI','SI',NULL),
(500450780,19,'2026-03-01','SI','NO','¿Me pasan el enlace del resumen?'),
(500610605,20,'2026-03-01','SI','SI',NULL),
(500640012,21,'2026-03-02','SI','SI',NULL),
(500310638,22,'2026-03-02','SI','NO',NULL),
(500470963,23,'2026-03-03','SI','SI','Gracias por la información.'),
(500500445,24,'2026-03-03','SI','SI',NULL),
(600210609,25,'2026-03-04','SI','NO',NULL),
(600290670,26,'2026-03-04','SI','SI',NULL),
(600390384,27,'2026-03-05','SI','SI',NULL),
(600430457,28,'2026-03-05','SI','NO',NULL),
(600250547,29,'2026-03-06','SI','SI','¿Cómo puedo participar como voluntario?'),
(600400232,30,'2026-03-06','SI','SI',NULL),
(600410234,31,'2026-03-07','SI','NO',NULL),
(600430441,32,'2026-03-07','SI','SI',NULL),
(700109881,33,'2026-03-08','SI','SI',NULL),
(700200261,34,'2026-03-08','SI','NO',NULL),
(700260940,35,'2026-03-09','SI','SI','Confirmo.'),
(700270314,36,'2026-03-09','SI','SI',NULL),
(700190809,37,'2026-03-10','SI','NO',NULL),
(700270837,38,'2026-03-10','SI','SI',NULL),
(700280796,39,'2026-03-11','SI','SI',NULL),
(800010114,40,'2026-03-11','SI','NO',NULL);
GO

INSERT INTO persona_interes (id_persona, id_tema, nivel_interes) VALUES
(110000288,7,5),
(110000305,2,4),
(119010053,3,3),
(119100969,4,4),
(119110869,1,5),
(210000278,5,3),
(210150980,6,4),
(211180902,7,5),
(211160072,8,3),
(211000336,9,4),
(300660431,10,2),
(301090033,1,4),
(301080191,2,3),
(400450373,3,5),
(400680089,4,4),
(400680205,5,3),
(400690944,6,4),
(500410783,7,5),
(500450780,8,2),
(500610605,9,3),
(500640012,10,4),
(500310638,1,5),
(500470963,2,4),
(500500445,3,3),
(600210609,4,4),
(600290670,5,3),
(600390384,6,4),
(600430457,7,5),
(600250547,8,3),
(600400232,9,4),
(600410234,10,2),
(600430441,1,4),
(700109881,2,3),
(700200261,3,5),
(700260940,4,4),
(700270314,5,3),
(700190809,6,4),
(700270837,7,5),
(700280796,8,2),
(800010114,9,4);
GO

INSERT INTO Interaccion (persona_id, canal_id, fecha_hora, descripcion) VALUES
(110000288,1,'2026-02-20 10:15:00','Consulta sobre empleo y capacitación.'),
(110000305,6,'2026-02-20 11:05:00','Solicita enlace de encuesta activa.'),
(119010053,2,'2026-02-21 09:40:00','Pregunta por ubicación exacta del evento.'),
(119100969,1,'2026-02-21 12:10:00','Confirma asistencia y consulta duración.'),
(119110869,3,'2026-02-22 08:55:00','Envía comentario sobre educación pública.'),
(210000278,8,'2026-02-22 13:30:00','Solicita información sobre seguridad en el barrio.'),
(210150980,4,'2026-02-23 10:05:00','Pregunta por propuesta de costo de vida.'),
(211180902,1,'2026-02-23 15:20:00','Solicita material informativo por tema.'),
(211160072,6,'2026-02-24 09:10:00','Consulta cómo participar como voluntariado.'),
(211000336,2,'2026-02-24 16:00:00','Pregunta por canales oficiales de comunicación.'),
(300660431,9,'2026-02-25 10:40:00','Solicita enlace de transmisión en vivo.'),
(301090033,1,'2026-02-25 14:15:00','Envía comentario sobre infraestructura vial.'),
(301080191,6,'2026-02-26 08:30:00','Pide resumen de propuestas de salud.'),
(400450373,1,'2026-02-26 18:05:00','Confirma asistencia y consulta parqueo.'),
(400680089,2,'2026-02-27 10:10:00','Consulta sobre transparencia y rendición de cuentas.'),
(400680205,6,'2026-02-27 12:00:00','Solicita información para donar.'),
(400690944,1,'2026-02-28 09:25:00','Pregunta por apoyo a pymes.'),
(500410783,3,'2026-02-28 17:30:00','Envía recomendación sobre reciclaje.'),
(500450780,2,'2026-03-01 10:05:00','Consulta agenda semanal de actividades.'),
(500610605,1,'2026-03-01 15:45:00','Pregunta por transporte público y rutas.'),
(500640012,6,'2026-03-02 09:35:00','Solicita enlace de encuesta de canales.'),
(500310638,8,'2026-03-02 14:00:00','Consulta seguridad vial en su zona.'),
(500470963,1,'2026-03-03 11:20:00','Confirma asistencia a cabildo.'),
(500500445,10,'2026-03-03 19:10:00','Revisa material en el sitio web y comenta.'),
(600210609,6,'2026-03-04 09:05:00','Solicita información sobre salud preventiva.'),
(600290670,2,'2026-03-04 13:25:00','Pregunta por educación técnica y becas.'),
(600390384,1,'2026-03-05 10:55:00','Envía comentario sobre empleo juvenil.'),
(600430457,6,'2026-03-05 16:10:00','Solicita confirmación de inscripción.'),
(600250547,1,'2026-03-06 09:45:00','Pregunta por actividades culturales.'),
(600400232,2,'2026-03-06 12:30:00','Consulta por propuesta de energía limpia.'),
(600410234,6,'2026-03-07 10:00:00','Pide detalle de evento y hora de inicio.'),
(600430441,1,'2026-03-07 17:05:00','Confirma asistencia.'),
(700109881,2,'2026-03-08 09:20:00','Pregunta por reporte de transparencia.'),
(700200261,6,'2026-03-08 11:15:00','Solicita enlace de encuesta abierta.'),
(700260940,1,'2026-03-09 10:35:00','Envía comentario sobre seguridad comunitaria.'),
(700270314,3,'2026-03-09 18:00:00','Pregunta por horarios de voluntariado.'),
(700190809,4,'2026-03-10 09:50:00','Consulta por movilidad peatonal.'),
(700270837,6,'2026-03-10 12:40:00','Solicita material informativo.'),
(700280796,1,'2026-03-11 10:10:00','Confirma asistencia al cierre de actividades.'),
(800010114,6,'2026-03-11 15:30:00','Pregunta por cómo participar en encuestas.');
GO

INSERT INTO Donaciones (persona_id, monto, fecha_hora, referencia, estado, observacion) VALUES
(110000288,10000.00,'2026-02-20 12:00:00','CR-0001-AP','Aprobada','Aporte para material informativo.'),
(110000305,15000.00,'2026-02-20 13:30:00','CR-0002-AP','Aprobada',NULL),
(119010053,8000.00,'2026-02-21 10:15:00','CR-0003-AP','Aprobada',NULL),
(119100969,12000.00,'2026-02-21 16:40:00','CR-0004-AP','Pendiente','Pendiente por verificación de referencia.'),
(119110869,20000.00,'2026-02-22 09:10:00','CR-0005-AP','Aprobada',NULL),
(210000278,6000.00,'2026-02-22 14:05:00','CR-0006-AP','Aprobada','Aporte para logística.'),
(210150980,30000.00,'2026-02-23 11:45:00','CR-0007-AP','Aprobada',NULL),
(211180902,10000.00,'2026-02-23 18:20:00','CR-0008-AP','Aprobada',NULL),
(211160072,9000.00,'2026-02-24 10:00:00','CR-0009-AP','Aprobada',NULL),
(211000336,7000.00,'2026-02-24 16:25:00','CR-0010-AP','Pendiente','Pendiente por confirmación del banco.'),

(300660431,15000.00,'2026-02-25 12:10:00','CR-0011-AP','Aprobada',NULL),
(301090033,11000.00,'2026-02-25 15:50:00','CR-0012-AP','Aprobada','Aporte para impresión de afiches.'),
(301080191,13000.00,'2026-02-26 09:35:00','CR-0013-AP','Aprobada',NULL),
(400450373,9000.00,'2026-02-26 18:40:00','CR-0014-AP','Aprobada',NULL),
(400680089,20000.00,'2026-02-27 10:30:00','CR-0015-AP','Aprobada',NULL),
(400680205,25000.00,'2026-02-27 12:45:00','CR-0016-AP','Pendiente','Pendiente por validación de datos.'),
(400690944,8000.00,'2026-02-28 09:45:00','CR-0017-AP','Aprobada',NULL),
(500410783,10000.00,'2026-02-28 17:50:00','CR-0018-AP','Aprobada','Aporte para sonido y sillas.'),
(500450780,6000.00,'2026-03-01 10:20:00','CR-0019-AP','Aprobada',NULL),
(500610605,15000.00,'2026-03-01 16:10:00','CR-0020-AP','Aprobada',NULL),

(500640012,12000.00,'2026-03-02 10:00:00','CR-0021-AP','Aprobada',NULL),
(500310638,9000.00,'2026-03-02 14:35:00','CR-0022-AP','Aprobada',NULL),
(500470963,18000.00,'2026-03-03 11:30:00','CR-0023-AP','Pendiente','Pendiente por confirmación de depósito.'),
(500500445,7000.00,'2026-03-03 19:30:00','CR-0024-AP','Aprobada',NULL),
(600210609,10000.00,'2026-03-04 09:30:00','CR-0025-AP','Aprobada',NULL),
(600290670,11000.00,'2026-03-04 13:50:00','CR-0026-AP','Aprobada','Aporte para material informativo.'),
(600390384,8000.00,'2026-03-05 11:10:00','CR-0027-AP','Aprobada',NULL),
(600430457,30000.00,'2026-03-05 16:40:00','CR-0028-AP','Aprobada',NULL),
(600250547,6000.00,'2026-03-06 10:05:00','CR-0029-AP','Aprobada',NULL),
(600400232,15000.00,'2026-03-06 12:55:00','CR-0030-AP','Aprobada','Aporte para logística.'),

(600410234,9000.00,'2026-03-07 10:25:00','CR-0031-AP','Aprobada',NULL),
(600430441,20000.00,'2026-03-07 17:20:00','CR-0032-AP','Pendiente','Pendiente por verificación de referencia.'),
(700109881,7000.00,'2026-03-08 09:40:00','CR-0033-AP','Aprobada',NULL),
(700200261,8000.00,'2026-03-08 11:35:00','CR-0034-AP','Aprobada',NULL),
(700260940,12000.00,'2026-03-09 10:55:00','CR-0035-AP','Aprobada',NULL),
(700270314,10000.00,'2026-03-09 18:20:00','CR-0036-AP','Aprobada',NULL),
(700190809,15000.00,'2026-03-10 10:10:00','CR-0037-AP','Aprobada','Aporte para impresión.'),
(700270837,6000.00,'2026-03-10 13:05:00','CR-0038-AP','Aprobada',NULL),
(700280796,9000.00,'2026-03-11 10:35:00','CR-0039-AP','Aprobada',NULL),
(800010114,11000.00,'2026-03-11 15:55:00','CR-0040-AP','Aprobada',NULL);
GO

INSERT INTO Respuesta_encuesta (encuesta_id, persona_id, fecha_hora, intencion_voto, id_tema, comentario) VALUES
(1,110000288,'2026-02-20 12:10:00','Probable',7,'Me interesa empleo y capacitación.'),
(2,110000305,'2026-02-20 13:10:00','Definitivo',7,'Buen seguimiento de oportunidades laborales.'),
(3,119010053,'2026-02-21 10:20:00','Indeciso',7,NULL),
(4,119100969,'2026-02-21 17:10:00','Probable',3,'El costo de vida es prioridad.'),
(5,119110869,'2026-02-22 09:40:00','Probable',3,NULL),
(6,210000278,'2026-02-22 14:30:00','Indeciso',4,'Seguridad e iluminación son urgentes.'),
(7,210150980,'2026-02-23 11:20:00','Definitivo',4,'Se necesitan medidas claras en seguridad.'),
(8,211180902,'2026-02-23 18:40:00','Probable',2,'Reducir listas de espera debería ser prioridad.'),
(9,211160072,'2026-02-24 10:30:00','Indeciso',2,NULL),
(10,211000336,'2026-02-24 16:55:00','Probable',1,'Educación y conectividad ayudan muchísimo.'),

(11,300660431,'2026-02-25 12:45:00','Probable',1,NULL),
(12,301090033,'2026-02-25 16:15:00','Indeciso',5,'Infraestructura y aceras seguras.'),
(13,301080191,'2026-02-26 09:55:00','Probable',5,NULL),
(14,400450373,'2026-02-26 18:35:00','Probable',6,'Ambiente y reciclaje son importantes.'),
(15,400680089,'2026-02-27 10:55:00','Definitivo',6,NULL),
(16,400680205,'2026-02-27 12:30:00','Indeciso',8,'Trámites digitales deberían mejorar.'),
(17,400690944,'2026-02-28 09:30:00','Probable',8,NULL),
(18,500410783,'2026-02-28 18:05:00','Probable',9,'Transparencia y rendición de cuentas.'),
(19,500450780,'2026-03-01 10:45:00','Indeciso',9,NULL),
(20,500610605,'2026-03-01 16:25:00','Probable',10,'Cultura y deporte en comunidades.'),

(21,500640012,'2026-03-02 10:20:00','Probable',7,NULL),
(22,500310638,'2026-03-02 15:05:00','Indeciso',3,'Costo de vida afecta bastante.'),
(23,500470963,'2026-03-03 11:55:00','Probable',4,NULL),
(24,500500445,'2026-03-03 19:55:00','Nulo',2,'No me convence aún, quiero más detalles.'),
(25,600210609,'2026-03-04 09:55:00','Probable',1,NULL),
(26,600290670,'2026-03-04 14:15:00','Probable',5,'Infraestructura y transporte público.'),
(27,600390384,'2026-03-05 11:35:00','Indeciso',6,NULL),
(28,600430457,'2026-03-05 17:10:00','Probable',8,'Digitalización y trámites más rápidos.'),
(29,600250547,'2026-03-06 10:35:00','Probable',10,NULL),
(30,600400232,'2026-03-06 13:20:00','Definitivo',9,'Transparencia debe ser prioridad.'),

(31,600410234,'2026-03-07 10:50:00','Probable',2,NULL),
(32,600430441,'2026-03-07 17:55:00','Indeciso',4,'Seguridad comunitaria es clave.'),
(33,700109881,'2026-03-08 09:55:00','Probable',3,NULL),
(34,700200261,'2026-03-08 11:50:00','Probable',7,'Empleo juvenil y capacitación.'),
(35,700260940,'2026-03-09 11:10:00','Indeciso',8,NULL),
(36,700270314,'2026-03-09 18:45:00','Probable',1,'Educación técnica y becas.'),
(37,700190809,'2026-03-10 10:35:00','Probable',5,NULL),
(38,700270837,'2026-03-10 13:30:00','Probable',6,'Ambiente y residuos bien gestionados.'),
(39,700280796,'2026-03-11 11:05:00','Blanco',9,NULL),
(40,800010114,'2026-03-11 16:10:00','Probable',9,'Buena comunicación y seguimiento.');
GO
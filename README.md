# bbdd_catalogo_proyectos

Categoría de servicios o líneas de negocio
1. Desarrollo Web y E-commerce
2. Desarrollo movil
3. QA
4. Diseño UX/UI
5. IA y machine learning
6. Cloud & DevOps
7. Datos & Analítica
8. Realidad virtual (VR)
9. Realidad aumentada (AR)


Categoria empresarial
1. Sector Salud
2. Sector Publico
3. Retail y consumo masivo (e-commerce, marcas)
4. Industria y manufactura (fabricas, plantas de produccion)
5. Banca y Finanzas
6. Enegia y Servicios publicos (Electricas, gas, agua, energia renov)
7. Educación
8. Telecomunicaciones y medios (Agencias de publi, Operadoras)
9. Transporte y Logistica
10. Turismo y Ocio
11. Startups y Pequeñas empresas

Modelo descripcion para Asana:
[NOMBRE_DEL_PROYECTO] es [descripción: qué es, para qué sirve, cuál es su propósito principal, tipo cliente].

[Frase sobre el valor o mejora que aporta: qué resuelve, qué permite, qué impacto tiene].

**Funcionalidades implementadas:**
1. [Funcionalidad principal 1]
2. [Funcionalidad principal 2]
3. [Funcionalidad principal 3]
4. [Funcionalidad adicional, si aplica]
5. [Pruebas, revisión funcional y despliegue finalizado] (siempre incluirlo)


quiro tener un lugar donde almacenar datos de proyectos que. esos datos los voy a recoger de asana mediante n8n.
esos datos los voy a usar para que una web los muestre como un "catalogo de proyectos" como si fuera un curriculum de los proyecots que hizo la empresa para que lo vena clientes en una web.

Para ello usare postgresql que tiene una base de datos vectorial, que correra en nuestros servidores

ademas que tambien pueda ser consumida por una ia para poder hacerle preguntas a cerca de los proyectos. ejemplo: "Dime que proyectos tenemos de bussines intelligence".

tambien quiero que esos datos se usen para haer modelos predictivos (aunque no es una prioridad)

tambien quiero establecer una especie de gobierno del dato


Pasos:

[Cada vez que un proyecto se marca como "Completado" en Asana]
                    ↓
         [Webhook de Asana] → [n8n recibe el evento]
                    ↓
         [n8n consulta datos completos del proyecto]
                    ↓
    [n8n transforma y mapea campos a tu esquema]
                    ↓
    [n8n inserta/actualiza en PostgreSQL]
                    ↓
    [Trigger en PostgreSQL] → [Generar embedding con pgvector]
                    ↓
              [¡Datos listos para Web e IA!]
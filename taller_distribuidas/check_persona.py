#!/usr/bin/env python3
import psycopg2

try:
    conn = psycopg2.connect(
        host='localhost',
        port=5434,
        user='postgres',
        password='123456',
        dbname='db_clientes'
    )
    cursor = conn.cursor()
    
    # Consulta para ver la persona
    cursor.execute("""
        SELECT p.id, p.nombre, p.apellido, p.identificacion, p.email, 
               p.tipo_persona, p.activo, p.fecha_creacion,
               pn.fecha_nacimiento, pn.genero
        FROM personas p
        LEFT JOIN persona_natural pn ON p.id = pn.id
        WHERE p.identificacion = '1751704196'
    """)
    
    result = cursor.fetchone()
    
    print("\n=== DATOS DE LA PERSONA CREADA ===\n")
    if result:
        print(f"  ID: {result[0]}")
        print(f"  Nombre: {result[1]}")
        print(f"  Apellido: {result[2]}")
        print(f"  Identificación: {result[3]}")
        print(f"  Email: {result[4]}")
        print(f"  Tipo: {result[5]}")
        print(f"  Activo: {result[6]}")
        print(f"  Fecha Creación: {result[7]}")
        print(f"  Fecha Nacimiento: {result[8]}")
        print(f"  Género: {result[9]}")
    else:
        print("  ⚠️  No se encontró el registro")
    
    # Contar total de personas
    cursor.execute("SELECT COUNT(*) FROM personas")
    count = cursor.fetchone()[0]
    print(f"\n  📊 Total de personas en la BD: {count}")
    
    cursor.close()
    conn.close()
    
except Exception as e:
    print(f"❌ Error: {e}")

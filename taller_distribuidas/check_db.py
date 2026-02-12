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
    
    # Obtener todas las tablas
    cursor.execute("""
        SELECT table_name FROM information_schema.tables 
        WHERE table_schema = 'public'
    """)
    tables = cursor.fetchall()
    
    print("\n=== TABLAS EN db_clientes ===\n")
    if tables:
        for table in tables:
            print(f"  - {table[0]}")
            
            # Obtener estructura de cada tabla
            cursor.execute(f"""
                SELECT column_name, data_type, is_nullable
                FROM information_schema.columns
                WHERE table_name = '{table[0]}'
            """)
            columns = cursor.fetchall()
            for col in columns:
                nullable = "NULL" if col[2] == "YES" else "NOT NULL"
                print(f"      • {col[0]}: {col[1]} ({nullable})")
    else:
        print("  ⚠️  No hay tablas creadas aún")
    
    cursor.close()
    conn.close()
    
except ImportError:
    print("❌ psycopg2 no está instalado. Instalando...")
    import subprocess
    subprocess.check_call(['pip', 'install', 'psycopg2-binary'])
    print("Instalación completada. Ejecuta nuevamente el script.")
except Exception as e:
    print(f"❌ Error: {e}")

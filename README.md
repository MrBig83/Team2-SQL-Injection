# Team2 – SQL Injection & Database First (EF Core)

## Scenario
Detta projekt är ett utbildningsprojekt med fokus på **databassäkerhet och SQL Injection**.  
Vi bygger en konsolbaserad .NET-applikation som kopplar mot en SQL Server-databas med **Entity Framework Core (Database First)**.

Syftet är att:
- förstå hur databaser och användare hanteras i SQL Server
- arbeta med **Database First-scaffolding**
- kunna testa och analysera **sårbara och säkra menyflöden**
- separera databasåtkomst från applikationslogik på ett korrekt sätt

---

## Tekniker
- .NET 9
- SQL Server Express
- Entity Framework Core 9
- Database First (Scaffold-DbContext)
- Console Application

---

## Hur man kör SQL-filerna (i rätt ordning)

Öppna **SQL Server Management Studio (SSMS)** och anslut till servern  
`t.ex. localhost\SQLEXPRESS`

Kör SQL-filerna i denna ordning:

1. **01_create_database.sql**  
   - Skapar databasen

2. **02_create_tables.sql**  
   - Skapar tabeller och relationer

3. **03_insert_data.sql**  
   - Lägger in testdata

4. **04_create_users.sql** (valfri men rekommenderad)  
   - Skapar t.ex. `security`-användare
   - Sätter rättigheter för säkerhetstester

!!!! Varje fil ska köras klart innan nästa körs.

---

## Hur man scaffoldar Database First (EF Core)

Öppna **Terminal i Visual Studio** i projektmappen (`Team2`).

Kör:

```powershell
dotnet ef dbcontext scaffold "Server=localhost\SQLEXPRESS;Database=SQLTeam2;Trusted_Connection=True;TrustServerCertificate=True" Microsoft.EntityFrameworkCore.SqlServer -o Models -c AppDbContext --force

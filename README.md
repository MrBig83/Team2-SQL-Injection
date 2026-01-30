# Team2-SQL-Injection
Databaser (SQL) – gruppprojekt i kursen där vi designar och bygger en relationsdatabas med ER-modell, normalisering och CRUD-skript.

## Arbetssätt
### GitHub
Klona ner projektet.
Skapa en branch för det du skall göra
Pusha din branch
Skapa en PR för att mergea till 'development' (Krävs minst 1 review för)
Main-branchen är låst. 

### GitHub Projects
Projektet bryts ner till mindre delar och varje del blir en 'task' i GitHub Projects. 
När du är klar med en task så flytta över den till "Review", sen tar du en annan task genom att 'assigna' dig själv till den och flytta tasken till 'In Progress'

## SQL Queries
Sparas i mappen som heter SQLQueries, som ligger i projektet







# 📦 InventoryOps – Team2  
SQL + .NET Console App (Database First)

---

## 🧩 Scenario – vad bygger vi och varför?

I detta grupparbete har vi byggt **InventoryOps**, ett enkelt men realistiskt system för **produktlager och orderhantering**.

Syftet med projektet är att visa hur en relationsdatabas används som *källan till sanningen*, och hur en .NET Console-applikation kopplas till databasen via **Database First** med Entity Framework.

Systemet hanterar:
- Produkter med prisinformation
- Lager (warehouses)
- Lagersaldo per produkt och lager
- Ordrar och orderrader
- Rapporter för att få överblick över verksamheten

Scenariot är valt eftersom det är vanligt förekommande i verkliga affärssystem och lämpar sig väl för att visa:
- relationer (1–1, 1–M, M–M)
- transaktionsdata
- JOINs och rapportfrågor
- views och säkerhet

---

## 🗄️ Databas – köra SQL-filer i rätt ordning

Alla SQL-filer finns i mappen `/sql`.  
De ska köras **i följande ordning** i SQL Server Management Studio:

1. `01_create_database.sql`  
   Skapar databasen `SQLTeam2` och sätter context med `USE`

2. `02_create_tables.sql`  
   Skapar alla tabeller med primärnycklar, främmande nycklar, constraints och CHECK-regler

3. `03_seed_data.sql`  
   Lägger in testdata i samtliga tabeller

4. `04_crud_examples.sql`  
   Exempel på INSERT, SELECT, UPDATE och DELETE

5. `05_queries_joins.sql`  
   Rapport- och JOIN-queries enligt uppgiftskraven

6. `06_views.sql`  
   Skapar views (public view + report view)

7. `07_security.sql`  
   Skapar role och user samt sätter rättigheter på views

8. `08_cleanup.sql`  
   (Valfri) Rensar databasen så man kan börja om

---

## 🔧 Database First – scaffolda Entity Framework

Projektet använder **Database First** enligt uppgiften.

### Förutsättningar
- SQL Server (lokal instans)
- .NET SDK installerad
- Entity Framework Core installerat i projektet

### Scaffold-kommando (exempel)

Kör följande kommando i projektmappen:

```powershell
Scaffold-DbContext "Server=SECFRAME;Database=SQLTeam2;Trusted_Connection=True;TrustServerCertificate=True" Microsoft.EntityFrameworkCore.SqlServer -OutputDir Models -Force

using Team2.Models;

namespace Team2
{
    class Program
    {
        static void Main()
        {
            bool running = true;

            while (running)
            {
                Console.Clear();
                Console.WriteLine("=== InventoryOps – Team2 ===");
                Console.WriteLine("1. Lista produkter");
                Console.WriteLine("2. Lista lager");
                Console.WriteLine("3. Visa lagersaldo");
                Console.WriteLine("4. Skapa order");
                Console.WriteLine("5. Uppdatera orderstatus");
                Console.WriteLine("6. Ta bort order");
                Console.WriteLine("7. Lista alla orderrader");
                Console.WriteLine("8. Rapport: Toppkunder");
                Console.WriteLine("9. Rapport: Senaste aktivitet");
                Console.WriteLine("10. Rapport: Lågt lagersaldo");
                Console.WriteLine("0. Avsluta");
                Console.Write("Val: ");

                var choice = Console.ReadLine();

                try
                {
                    switch (choice)
                    {
                        case "1": ListProducts(); break;
                        case "2": ListWarehouses(); break;
                        case "3": ShowInventory(); break;
                        case "4": CreateOrder(); break;
                        case "5": UpdateOrderStatus(); break;
                        case "6": DeleteOrder(); break;
                        case "7": ListOrderLines(); break;
                        case "8": ReportTopCustomers(); break;
                        case "9": ReportLatestActivity(); break;
                        case "10": ReportLowStock(); break;
                        case "0": running = false; break;
                        default: Pause("Ogiltigt val."); break;
                    }
                }
                catch (Exception ex)
                {
                    Pause($"Fel: {ex.Message}");
                }
            }
        }

        // =========================
        // GRUNDVYER
        // =========================

        static void ListProducts()
        {
            using var db = new SqlTeam2Context();

            var products = db.Products
                .OrderBy(p => p.Name)
                .ToList();

            Console.WriteLine("\nProdukter:");
            foreach (var p in products)
            {
                Console.WriteLine($"{p.ProductId,-3} {p.Sku,-10} {p.Name,-25} {p.UnitPrice,8} kr");
            }

            Pause();
        }

        static void ListWarehouses()
        {
            using var db = new SqlTeam2Context();

            Console.WriteLine("\nLager:");
            foreach (var w in db.Warehouses)
            {
                Console.WriteLine($"{w.WarehouseId,-3} {w.Name} ({w.Address})");
            }

            Pause();
        }

        static void ShowInventory()
        {
            using var db = new SqlTeam2Context();

            var inventory = db.Inventories
                .Select(i => new
                {
                    Warehouse = i.Warehouse.Name,
                    Product = i.Product.Name,
                    i.QuantityOnHand,
                    i.ReorderLevel
                })
                .OrderBy(i => i.Warehouse)
                .ThenBy(i => i.Product)
                .ToList();

            Console.WriteLine("\nLagersaldo:");
            foreach (var i in inventory)
            {
                Console.WriteLine(
                    $"{i.Warehouse,-18} | {i.Product,-25} | {i.QuantityOnHand,4} (Min {i.ReorderLevel})"
                );
            }

            Pause();
        }

        // =========================
        // CRUD
        // =========================

        static void CreateOrder()
        {
            using var db = new SqlTeam2Context();

            Console.Write("Kundnamn: ");
            var customer = Console.ReadLine();
            if (string.IsNullOrWhiteSpace(customer))
                return;

            Console.Write("Produkt-ID: ");
            if (!int.TryParse(Console.ReadLine(), out int productId))
                return;

            Console.Write("Antal: ");
            if (!int.TryParse(Console.ReadLine(), out int qty))
                return;

            var product = db.Products.Find(productId);
            if (product == null)
            {
                Pause("Produkten finns inte.");
                return;
            }

            var order = new Order
            {
                CustomerName = customer,
                Status = "New"
            };

            db.Orders.Add(order);
            db.SaveChanges();

            var line = new OrderLine
            {
                OrderId = order.OrderId,
                LineNr = 1,
                ProductId = productId,
                Quantity = qty,
                UnitPriceAtOrder = product.UnitPrice
            };

            db.OrderLines.Add(line);
            db.SaveChanges();

            Pause($"Order {order.OrderId} skapad.");
        }

        static void UpdateOrderStatus()
        {
            using var db = new SqlTeam2Context();

            Console.Write("Order-ID: ");
            if (!int.TryParse(Console.ReadLine(), out int orderId))
                return;

            var order = db.Orders.Find(orderId);
            if (order == null)
            {
                Pause("Order hittades inte.");
                return;
            }

            Console.Write("Ny status (New/Picking/Shipped/Cancelled): ");
            var status = Console.ReadLine();

            if (!new[] { "New", "Picking", "Shipped", "Cancelled" }.Contains(status))
            {
                Pause("Ogiltig status.");
                return;
            }

            order.Status = status;
            db.SaveChanges();

            Pause("Status uppdaterad.");
        }

        static void DeleteOrder()
        {
            using var db = new SqlTeam2Context();

            Console.Write("Order-ID att ta bort: ");
            if (!int.TryParse(Console.ReadLine(), out int orderId))
                return;

            var order = db.Orders.Find(orderId);
            if (order == null)
            {
                Pause("Order hittades inte.");
                return;
            }

            db.Orders.Remove(order);
            db.SaveChanges();

            Pause("Order borttagen (orderlines raderades via cascade).");
        }

        static void ListOrderLines()
        {
            using var db = new SqlTeam2Context();

            var lines = db.OrderLines
                .Select(ol => new
                {
                    ol.OrderId,
                    ol.LineNr,
                    ProductName = ol.Product.Name,
                    ol.Quantity,
                    ol.UnitPriceAtOrder,
                    OrderStatus = ol.Order.Status,
                    ol.CreatedAt
                })
                .OrderByDescending(l => l.CreatedAt)
                .ToList();

            Console.WriteLine("\nOrderrader:");
            Console.WriteLine("Order  Ln  Produkt                    Antal  Pris     Status     Datum");
            Console.WriteLine("--------------------------------------------------------------------------");

            foreach (var l in lines)
            {
                Console.WriteLine(
                    $"{l.OrderId,-6} {l.LineNr,-3} {l.ProductName,-25} {l.Quantity,-6} {l.UnitPriceAtOrder,-8} {l.OrderStatus,-10} {l.CreatedAt:yyyy-MM-dd}"
                );
            }

            Pause();
        }

        // =========================
        // RAPPORTER (LINQ)
        // =========================

        static void ReportTopCustomers()
        {
            using var db = new SqlTeam2Context();

            var report = db.Orders
                .Join(db.OrderLines,
                    o => o.OrderId,
                    ol => ol.OrderId,
                    (o, ol) => new { o.CustomerName, o.OrderId, ol.Quantity, ol.UnitPriceAtOrder })
                .GroupBy(x => x.CustomerName)
                .Select(g => new
                {
                    CustomerName = g.Key,
                    OrdersCount = g.Select(x => x.OrderId).Distinct().Count(),
                    ItemsSold = g.Sum(x => x.Quantity),
                    TotalSpend = g.Sum(x => x.Quantity * x.UnitPriceAtOrder)
                })
                .OrderByDescending(x => x.TotalSpend)
                .ThenByDescending(x => x.OrdersCount)
                .Take(10)
                .ToList();

            Console.WriteLine("\nToppkunder:");
            Console.WriteLine("Kund                     Ordrar  Artiklar  Total Spend");
            Console.WriteLine("--------------------------------------------------------");

            foreach (var r in report)
            {
                Console.WriteLine(
                    $"{r.CustomerName,-25} {r.OrdersCount,-7} {r.ItemsSold,-9} {r.TotalSpend,12:C}"
                );
            }

            Pause();
        }

        static void ReportLatestActivity()
        {
            using var db = new SqlTeam2Context();

            var report = db.OrderLines
                .Select(ol => new
                {
                    ol.Order.CreatedAt,
                    ol.OrderId,
                    ol.Order.CustomerName,
                    ol.Order.Status,
                    ol.LineNr,
                    ol.Product.Sku,
                    ProductName = ol.Product.Name,
                    ol.Quantity,
                    ol.UnitPriceAtOrder,
                    LineTotal = ol.Quantity * ol.UnitPriceAtOrder
                })
                .OrderByDescending(x => x.CreatedAt)
                .ThenByDescending(x => x.OrderId)
                .ThenByDescending(x => x.LineNr)
                .Take(20)
                .ToList();

            Console.WriteLine("\nSenaste aktivitet:");
            Console.WriteLine("Datum       Order  Kund          Status     SKU       Produkt        Antal  Summa");
            Console.WriteLine("-------------------------------------------------------------------------------");

            foreach (var r in report)
            {
                Console.WriteLine(
                    $"{r.CreatedAt:yyyy-MM-dd} {r.OrderId,-6} {r.CustomerName,-12} {r.Status,-10} " +
                    $"{r.Sku,-8} {r.ProductName,-14} {r.Quantity,-6} {r.LineTotal,8:C}"
                );
            }

            Pause();
        }

        static void ReportLowStock()
        {
            using var db = new SqlTeam2Context();

            var report = db.Inventories
                .Where(i => i.QuantityOnHand < i.ReorderLevel)
                .Select(i => new
                {
                    Warehouse = i.Warehouse.Name,
                    i.Product.Sku,
                    ProductName = i.Product.Name,
                    i.QuantityOnHand,
                    i.ReorderLevel,
                    Shortage = i.ReorderLevel - i.QuantityOnHand
                })
                .OrderByDescending(x => x.Shortage)
                .ThenBy(x => x.Warehouse)
                .ThenBy(x => x.Sku)
                .ToList();

            Console.WriteLine("\n⚠ Lågt lagersaldo:");
            Console.WriteLine("Lager              SKU       Produkt                    I lager  Min  Brist");
            Console.WriteLine("----------------------------------------------------------------------------");

            foreach (var r in report)
            {
                Console.WriteLine(
                    $"{r.Warehouse,-18} {r.Sku,-8} {r.ProductName,-25} {r.QuantityOnHand,-7} {r.ReorderLevel,-4} {r.Shortage,-5}"
                );
            }

            Pause();
        }

        // =========================
        // HJÄLP
        // =========================

        static void Pause(string? message = null)
        {
            if (!string.IsNullOrWhiteSpace(message))
                Console.WriteLine(message);

            Console.WriteLine("\nTryck valfri tangent...");
            Console.ReadKey();
        }
    }
}

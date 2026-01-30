using System;
using System.Collections.Generic;

namespace Team2.Models;

public partial class Inventory
{
    public int WarehouseId { get; set; }

    public int ProductId { get; set; }

    public int QuantityOnHand { get; set; }

    public int ReorderLevel { get; set; }

    public DateTime CreatedAt { get; set; }

    public virtual Product Product { get; set; } = null!;

    public virtual Warehouse Warehouse { get; set; } = null!;
}

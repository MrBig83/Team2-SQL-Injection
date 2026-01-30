using System;
using System.Collections.Generic;

namespace Team2.Models;

public partial class OrderLine
{
    public int OrderId { get; set; }

    public int LineNr { get; set; }

    public int ProductId { get; set; }

    public int Quantity { get; set; }

    public decimal UnitPriceAtOrder { get; set; }

    public DateTime CreatedAt { get; set; }

    public virtual Order Order { get; set; } = null!;

    public virtual Product Product { get; set; } = null!;
}

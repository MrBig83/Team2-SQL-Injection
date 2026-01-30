using System;
using System.Collections.Generic;

namespace Team2.Models;

public partial class Order
{
    public int OrderId { get; set; }

    public string CustomerName { get; set; } = null!;

    public string Status { get; set; } = null!;

    public DateTime CreatedAt { get; set; }

    public virtual ICollection<OrderLine> OrderLines { get; set; } = new List<OrderLine>();
}

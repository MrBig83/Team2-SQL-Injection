using System;
using System.Collections.Generic;

namespace Team2.Models;

public partial class ProductDetail
{
    public int ProductId { get; set; }

    public decimal? WeightKg { get; set; }

    public string? DimensionsCm { get; set; }

    public DateTime CreatedAt { get; set; }

    public virtual Product Product { get; set; } = null!;
}

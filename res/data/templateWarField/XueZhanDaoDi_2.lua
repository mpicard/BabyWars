return {
  warFieldName = "血战到底",
  authorName   = "RushFTK",
  playersCount = 4,

  width = 14,
  height = 14,
  layers = {
    {
      type = "tilelayer",
      name = "TileBase",
      x = 0,
      y = 0,
      width = 14,
      height = 14,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 85, 69, 69, 69, 69, 69, 69, 69, 69, 69, 69, 86, 1,
        1, 71, 19, 78, 70, 70, 70, 70, 70, 70, 74, 22, 72, 1,
        1, 71, 76, 1, 1, 1, 1, 1, 1, 1, 1, 79, 72, 1,
        1, 71, 72, 1, 1, 1, 1, 1, 1, 1, 1, 71, 72, 1,
        1, 71, 72, 1, 1, 1, 1, 1, 1, 1, 1, 71, 72, 1,
        1, 71, 72, 1, 1, 1, 1, 1, 1, 1, 1, 71, 72, 1,
        1, 71, 72, 1, 1, 1, 1, 1, 1, 1, 1, 71, 72, 1,
        1, 71, 72, 1, 1, 1, 1, 1, 1, 1, 1, 71, 72, 1,
        1, 71, 72, 1, 1, 1, 1, 1, 1, 1, 1, 71, 72, 1,
        1, 71, 80, 1, 1, 1, 1, 1, 1, 1, 1, 75, 72, 1,
        1, 71, 20, 73, 69, 69, 69, 69, 69, 69, 77, 26, 72, 1,
        1, 88, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 87, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
      }
    },
    {
      type = "tilelayer",
      name = "TileObject",
      x = 0,
      y = 0,
      width = 14,
      height = 14,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        124, 164, 0, 0, 154, 154, 123, 154, 0, 164, 0, 159, 174, 124,
        174, 0, 0, 0, 0, 0, 0, 0, 147, 0, 0, 0, 0, 164,
        159, 0, 192, 0, 0, 0, 0, 0, 0, 0, 0, 190, 0, 0,
        0, 0, 0, 154, 0, 124, 154, 125, 169, 169, 154, 0, 0, 0,
        164, 0, 0, 169, 152, 104, 125, 123, 124, 150, 0, 0, 0, 154,
        0, 147, 0, 169, 124, 154, 104, 103, 154, 106, 124, 0, 0, 154,
        154, 0, 0, 125, 123, 105, 157, 155, 106, 125, 154, 0, 0, 123,
        123, 0, 0, 154, 125, 103, 156, 157, 104, 123, 125, 0, 0, 154,
        154, 0, 0, 124, 103, 154, 106, 105, 154, 124, 169, 0, 147, 0,
        154, 0, 0, 0, 151, 124, 123, 125, 105, 153, 169, 0, 0, 164,
        0, 0, 0, 154, 169, 169, 125, 154, 124, 0, 154, 0, 0, 0,
        0, 0, 191, 0, 0, 0, 0, 0, 0, 0, 0, 193, 0, 159,
        164, 0, 0, 0, 0, 147, 0, 0, 0, 0, 0, 0, 0, 174,
        124, 174, 159, 0, 164, 0, 154, 123, 154, 154, 0, 0, 164, 124
      }
    },
    {
      type = "tilelayer",
      name = "Unit",
      x = 0,
      y = 0,
      width = 14,
      height = 14,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 210, 306, 210, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        212, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        308, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 212, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 213, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 309,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 213,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 211, 307, 211, 0, 0, 0, 0, 0, 0, 0
      }
    }
  }
}

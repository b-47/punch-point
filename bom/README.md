# Bill of materials

[`parts.csv`](parts.csv) lists the parts of the braille embosser. The [bill of materials page](https://b-47.github.io/punch-point/bom/) reads it and adds up the totals.

To change a price or add a part, edit `parts.csv` on GitHub, one part per row. Write any text that contains a comma inside double quotes.

| Column | What to write |
| --- | --- |
| `part` | The part's name. |
| `details` | Size, model or anything needed to buy the right one. |
| `unit_cost` | The cost of one, in US dollars, without the dollar sign. |
| `qty_one_stylus` | How many the one-stylus design needs. |
| `qty_six_styli` | How many the six-styli design needs. |
| `checked` | The date you checked the price, such as 2026-10-16. |
| `link` | The store page the price came from. Leave it empty for an estimate. |

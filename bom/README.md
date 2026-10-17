# Parts and costs

[`parts.csv`](parts.csv) lists every part we buy, with its price. It is a CSV file: a spreadsheet saved as plain text, one row per line. The [parts and costs page](https://b-47.github.io/punch-point/bom/) reads it and adds up the totals, so it updates as soon as the file changes on GitHub.

## Change a price or add a part

1. Open `parts.csv` on GitHub and click the pencil icon to edit it. A spreadsheet program works too, if you save as CSV.
2. Change the row, or add one. Keep one part per row.
3. Put today's date in `checked`.
4. Commit the change.

## Columns

| Column | What to write |
| --- | --- |
| `build` | Which build the part belongs to: `test-rig`, `design-a` (the one-stylus embosser) or `design-b-extra` (what six styli add to design A). |
| `section` | A group within the build, such as `Electronics`. The page lists rows with the same section together. |
| `item` | The part's name. |
| `details` | Size, model or anything needed to buy the right one. |
| `qty` | How many one build uses, in the unit below. |
| `unit` | `each`, `set`, `g`, `m`, `drops` or `ream`. |
| `pack_price` | What one pack costs, in US dollars, without the dollar sign. |
| `pack_qty` | How many units come in that pack. Use 1 for a single part. |
| `counts` | `part` counts toward the cost of a build. `tool` counts only toward "buy everything". `optional` counts toward neither. |
| `price_from` | `order sheet`, `store page` or `estimate`. |
| `checked` | The date you saw the price, as year-month-day, such as 2026-10-16. |
| `link` | Where to buy it, if we know. |
| `notes` | Anything a buyer should know. |

Write any text that contains a comma inside double quotes, such as `"M3 x 18, steel"`.

## How the totals work

- **Cost per build** adds up `qty` times `pack_price` divided by `pack_qty`, for every `part` row.
- **Buy everything** adds up the price of every whole pack you'd need, for every `part` and `tool` row.
- **Design B** is design A plus the `design-b-extra` rows.
